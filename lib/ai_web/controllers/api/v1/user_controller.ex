defmodule AiWeb.API.V1.UserController do
  use AiWeb, :controller

  def current(conn, _) do
    user =
      conn
      |> Guardian.Plug.current_resource()

    conn
    |> render("show.json-api", data: user)
  end
end
