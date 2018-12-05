use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :exred_ui, ExredUIWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :exred_ui, ExredUI.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "exred_user",
  password: "",
  database: "exred_ui_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
