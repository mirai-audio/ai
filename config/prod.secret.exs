use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :ai, AiWeb.Endpoint,
  secret_key_base: System.get_env("ENV_AI_SECRET_KEY_BASE") || "changeme"

# Configure your database
config :ai, Ai.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("ENV_AI_DB_URL") || "ecto://postgres:postgres@localhost/ai_prod",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "20")
