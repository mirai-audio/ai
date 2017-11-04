defmodule AiWeb.UserController do
  use AiWeb, :controller

  def current(conn, _) do
    user =
      conn
      |> Guardian.Plug.current_resource()

    conn
    |> render(AiWeb.UserView, "show.json", user: user)
  end
end
