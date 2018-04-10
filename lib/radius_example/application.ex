defmodule RadiusExample.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    # :application.ensure_all_started(:eradius)
    # :eradius.modules_ready([__MODULE__])

    # why do I need to spawn here. Why can't I just call modules_ready/1
    RadiusServer.server()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(RadiusExampleWeb.Endpoint, []),
      # Start your own worker by calling: RadiusExample.Worker.start_link(arg1, arg2, arg3)
      # worker(RadiusExample.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RadiusExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RadiusExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
