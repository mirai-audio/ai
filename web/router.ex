defmodule Ai.Router do
  use Ai.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api", "json"]
  end

  scope "/", Ai do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", Ai do
    pipe_through :api
    resources "/medias", MediaController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Ai do
  #   pipe_through :api
  # end
end
