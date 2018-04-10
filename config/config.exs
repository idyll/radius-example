# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :radius_example, RadiusExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RDs5e82V+/EIfGlH/yYKHaMCoJ49Q9f15H2YGdj/XLb6xSF2kYtFB6o8nB9k39cU",
  render_errors: [view: RadiusExampleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RadiusExample.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

:application.load(:eradius)
config :eradius,
  # defines radius callback, which should be called
  radius_callback: RadiusServer,
  # if you are using a dictionary other than the default, you *must* uncomment
  # the following line and add the missing dictionary. The following example is also
  # using the cisco dictionary.
  # tables: [:dictionary],
  # defines node, where in cluster should be radius callback applied
  session_nodes: [node()],
  # Clients that are able to connect shold be configured here.
  # Every simbolic name server should be configured to accept requests from eradius clients
  root: [
    # every configuration is {name, arguments for a callback} and list of accepted clients with ip and secret
    { {'root', []}, [{'0.0.0.0', "secret"}] }
  ],
  servers: [
    root: {'0.0.0.0', [1812]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
