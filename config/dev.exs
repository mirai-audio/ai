use Mix.Config

# General configuration
config :ai,
  mir_url: System.get_env("ENV_AI_MIR_URL") || "http://localhost:4200"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :ai, AiWeb.Endpoint,
  http: [port: 4000],
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :ai, Ai.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("ENV_AI_DB_URL") || "ecto://postgres:postgres@localhost/ai_dev",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
