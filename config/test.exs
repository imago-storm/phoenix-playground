use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_create_and_login, UserCreateAndLogin.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :user_create_and_login, UserCreateAndLogin.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "user_create_and_login_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
