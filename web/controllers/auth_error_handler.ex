defmodule Ai.AuthErrorHandler do
 use Ai.Web, :controller

 def unauthenticated(conn, _params) do
  conn
   |> put_status(401)
   |> render(Ai.ErrorView, "401.json")
 end

 def unauthorized(conn, _params) do
  conn
   |> put_status(403)
   |> render(Ai.ErrorView, "403.json")
 end
end
