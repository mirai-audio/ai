defmodule Ai.UserView do
  use Ai.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Ai.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Ai.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      type: "user",
      id: user.id,
      # "email": user.email
      attributes: %{}
    }
  end
end
