defmodule Ai.Router do
  use Ai.Web, :router

  pipeline :api do
    plug :accepts, ["json-api", "json"]
  end

  scope "/api/v1", Ai do
    pipe_through :api
    resources "/medias", MediaController, except: [:new, :edit]
  end
end
