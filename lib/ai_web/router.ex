defmodule AiWeb.Router do
  use AiWeb, :router
  require Ueberauth

  # unauthenticated API requests
  pipeline :api do
    plug(:accepts, ["json-api", "json"])
  end

  # strict JSON API requests
  pipeline :json_api do
    plug(:accepts, ["json-api", "json"])
    plug JaSerializer.ContentTypeNegotiation
  end

  pipeline :authenticated do
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource)
    plug(Guardian.Plug.EnsureAuthenticated, handler: AiWeb.AuthErrorHandler)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/login", AiWeb do
    pipe_through([:browser])

    get("/:provider", LoginController, :request)
    get("/:provider/callback", LoginController, :callback)
    post("/:provider/callback", LoginController, :callback)
    delete("/logout", LoginController, :delete)
  end

  scope "/api/v1", AiWeb do
    pipe_through(:api)

    # user signup / registration
    post("/users", UserController, :create)
    # user authentication
    post("/users/token", SessionController, :create, as: :login)
  end

  scope "/api/v1", AiWeb.API.V1 do
    pipe_through([:json_api, :authenticated])

    resources("/medias", MediaController, except: [:new, :edit])
    get("/users/current", UserController, :current)
  end
end
