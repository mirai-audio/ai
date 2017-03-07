defmodule Ai.Endpoint do
  use Phoenix.Endpoint, otp_app: :ai

  plug Corsica,
    origins: ["https://mirai.audio",
      "https://app.mirai.audio",
      "http://localhost:3000",
      "http://localhost:4200"],
    max_age: 600,
    log: [rejected: :warn, invalid: :warn, accepted: :info],
    allow_headers: ["accept", "content-type", "authorization", "origin"]

  socket "/socket", Ai.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :ai, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_ai_key",
    signing_salt: "hSgdosBb"

  plug Ai.Router
end
