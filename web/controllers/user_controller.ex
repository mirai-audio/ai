defmodule Ai.UserController do
  use Ai.Web, :controller

  def current(conn, _) do
    user =
      conn
      |> Guardian.Plug.current_resource()

    conn
    |> render(Ai.UserView, "show.json", user: user)
  end
end
