# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General configuration
config :ai, mir_url: System.get_env("ENV_AI_MIR_URL") || "http://localhost:4200"

# Configures the endpoint
# overridden by dev/prod.exs
config :ai, Ai.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("ENV_AI_SECRET_KEY_BASE") ||
    "aaaabbbbccccddddaaaabbbbccccddddaaaabbbbccccddddaaaabbbbccccdddd",
  render_errors: [view: Ai.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ai.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure the Ecto Repos
config :ai, ecto_repos: [Ai.Repo]

config :phoenix, :format_encoders, "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"],
  "application/json" => ["json"]
}

# optional
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "ai",
  ttl: {90, :days},
  verify_issuer: true,
  secret_key: System.get_env("ENV_AI_GUARDIAN_SECRET_KEY") || "changeme",
  serializer: Ai.GuardianSerializer

config :ueberauth, Ueberauth,
  base_path: "/login",
  providers: [
    twitter: {Ueberauth.Strategy.Twitter, []}
  ]

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  request_path: "/auth/twitter",
  callback_path: "/auth/twitter/callback",
  consumer_key: System.get_env("ENV_AI_TWITTER_CONSUMER_KEY") || "changeme",
  consumer_secret: System.get_env("ENV_AI_TWITTER_CONSUMER_SECRET") || "changeme",
  redirect_uri: System.get_env("ENV_AI_TWITTER_REDIRECT_URI") || "http://localhost:4200/login"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
