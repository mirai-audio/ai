defmodule Ai.Router do
  use Ai.Web, :router
  require Ueberauth

  # unauthenticated requests
  pipeline :api do
    plug(:accepts, ["json-api", "json"])
  end

  pipeline :api_auth do
    plug(:accepts, ["json-api", "json"])
    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource)
    plug(Guardian.Plug.EnsureAuthenticated, handler: Ai.AuthErrorHandler)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/login", Ai do
    pipe_through([:browser])

    get("/:provider", LoginController, :request)
    get("/:provider/callback", LoginController, :callback)
    post("/:provider/callback", LoginController, :callback)
    delete("/logout", LoginController, :delete)
  end

  scope "/api/v1", Ai do
    pipe_through(:api)

    # user signup / registration
    post("/users", UnauthenticatedUserController, :create)
    # user authentication
    post("/users/token", SessionController, :create, as: :login)

    # media
    resources("/medias", MediaController, except: [:new, :edit])
  end

  scope "/api/v1", Ai do
    pipe_through(:api_auth)
    get("/users/current", UserController, :current)
  end
end
