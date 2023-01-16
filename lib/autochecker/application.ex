defmodule Autochecker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    atlanta_id = 5182
    # hidalgo has appointments available for testing the notification system
    hidalgo_id = 5001
    poll_atlanta = fn -> Autochecker.DHS.appointments_available_at(atlanta_id) end

    children = [
      # Start the Telemetry supervisor
      AutocheckerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: :autochecker_pubsub},
      # Start Finch
      {Finch, name: Autochecker.Finch},
      # Start the Endpoint (http/https)
      AutocheckerWeb.Endpoint,
      # Start a worker by calling: Autochecker.Worker.start_link(arg)
      {Autochecker.Poller, poll_atlanta}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Autochecker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AutocheckerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
