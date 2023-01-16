defmodule Autochecker.Poller do
  alias Phoenix.PubSub
  alias Autochecker.PushoverClient
  require Logger

  @enforce_keys [:poll_func, :notified, :poll_count]
  defstruct [:poll_func, :notified, :poll_count]

  use GenServer

  def start_link(poll_func) when is_function(poll_func) do
    GenServer.start_link(__MODULE__, poll_func, name: __MODULE__)
  end

  @impl true
  def init(poll_func) do
    schedule_poll()

    {:ok, %__MODULE__{poll_func: poll_func, notified: false, poll_count: 0}}
  end

  @impl true
  def handle_info(:poll, %__MODULE__{poll_count: count} = state) do
    Logger.info(%{poll_count: count})
    broadcast(state)

    {:noreply, %__MODULE__{perform_poll(state) | poll_count: count + 1}}
  end

  @impl true
  def handle_call(:get_state, _from, %__MODULE__{} = state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:reset, %__MODULE__{} = state) do
    broadcast(state)
    schedule_poll()
    {:noreply, %__MODULE__{state | poll_count: 0, notified: false}}
  end

  def perform_poll(%__MODULE__{poll_func: poll_func, notified: false} = state) do
    Logger.info("Checking for appointments")

    if poll_func.() do
      notify()
      state = %__MODULE__{state | notified: true}
      broadcast(state)
      state
    else
      schedule_poll()
      %__MODULE__{state | notified: false}
    end
  end

  def broadcast(state) do
    PubSub.broadcast(:autochecker_pubsub, "poll", state)
  end

  def schedule_poll() do
    Process.send_after(self(), :poll, 1000)
  end

  def notify() do
    body = "Global Entry appointment available in Atlanta"
    Logger.warn(body)

    PushoverClient.send_message(%{
      message: body,
      title: body,
      priority: 0,
      retry: 30,
      expire: 180
    })
  end

  def get_status() do
    GenServer.call(__MODULE__, :get_state)
    |> Map.take([:notified, :poll_count])
  end

  def reset() do
    GenServer.cast(__MODULE__, :reset)
  end
end
