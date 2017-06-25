# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :user_create_and_login,
  ecto_repos: [UserCreateAndLogin.Repo]

# Configures the endpoint
config :user_create_and_login, UserCreateAndLogin.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+guQbtTM3KbnaA8+HM1A8/GBG1E2wpfdMfSxO+wAq7ZwQmAMIx2AhO9sVLgfPw1H",
  render_errors: [view: UserCreateAndLogin.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UserCreateAndLogin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :guardian, Guardian,
    allowed_algos: ["HS512"],
    verify_module: Guardian.JWT,
    issuer: "UserCreateAndLogin",
    ttl: {30, :days},
    allowed_drift: 2000,
    verify_issuer: true,
    secret_key: "eHa1vCxmO4bJLm0Lk5djDcF/1UMQAcuYUgoijYeAje20b0OHqkdBdn6riR4ReVEM",
    serializer: UserCreateAndLogin.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
