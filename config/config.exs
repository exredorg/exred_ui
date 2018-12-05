# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :exred_ui,
  ecto_repos: [ExredUI.Repo]

# Configures the endpoint
config :exred_ui, ExredUIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lNynDH9TigJu4E18vTfeAXKJUU6Vx8ARmpuFUW3DXOTdGiKSKktPPswoWAhx9LwW",
  render_errors: [view: ExredUIWeb.ErrorView, accepts: ~w(json json-api)],
  pubsub: [name: ExredUI.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]



config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}



config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Pchat",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET") || "VR8YBJA94hYgn5KSxAHhr6RtBNJI2ZIdt11Cl3WlaxNtC+lX3hPTVSbFOBDKPEGF",
  serializer: Pchat.GuardianSerializer




# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
