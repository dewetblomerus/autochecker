defmodule AutocheckerWeb.HomeLive do
  use AutocheckerWeb, :live_view
  require Logger
  alias Phoenix.PubSub
  alias Autochecker.Poller

  def render(assigns) do
    ~H"""
    <a href="https://ttp.cbp.dhs.gov/" target="_blank">DHS Travel Program</a>

    <h1>
      I have checked <%= @poll_count %> times
    </h1>
    <h1>
      Notification sent: <%= @notified %>
    </h1>
    <.button id="recheck" phx-click="recheck" phx-disable-with class="py-2 px-3">
      Reset
    </.button>
    """
  end

  def mount(_params, _session, socket) do
    PubSub.subscribe(:autochecker_pubsub, "poll")
    poller_state = Poller.get_status()
    {:ok, assign_state(poller_state, socket)}
  end

  def handle_event("recheck", %{"value" => ""}, socket) do
    Logger.warn("rechecking")
    Poller.reset()
    {:noreply, socket}
  end

  def handle_info(poller_status, socket) do
    {:noreply, assign_state(poller_status, socket)}
  end

  def assign_state(%{notified: notified, poll_count: poll_count}, socket) do
    assign(socket, poll_count: poll_count, notified: notified)
  end
end
