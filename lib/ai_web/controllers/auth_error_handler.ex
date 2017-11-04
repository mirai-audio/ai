defmodule AiWeb.AuthErrorHandler do
  use AiWeb, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(AiWeb.ErrorView, "401.json")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(AiWeb.ErrorView, "403.json")
  end
end
