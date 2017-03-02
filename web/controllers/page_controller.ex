defmodule Ai.PageController do
  use Ai.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
