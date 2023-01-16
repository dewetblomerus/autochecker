defmodule AutocheckerWeb.HomeLive do
  use AutocheckerWeb, :live_view
  alias Phoenix.PubSub
  alias Autochecker.Poller

  def render(assigns) do
    ~H"""
    <h1>
      I have checked <%= @poll_count %> times
    </h1>
    <h1>
      Notification sent: <%= @notified %>
    </h1>
    """
  end

  def mount(_params, _session, socket) do
    PubSub.subscribe(:autochecker_pubsub, "poll")
    poller_state = Poller.get_state()
    {:ok, assign_state(poller_state, socket)}
  end

  def handle_info(%Autochecker.Poller{} = poller_state, socket) do
    {:noreply, assign_state(poller_state, socket)}
  end

  def assign_state(%Autochecker.Poller{notified: notified, poll_count: poll_count}, socket) do
    assign(socket, poll_count: poll_count, notified: notified)
  end
end
