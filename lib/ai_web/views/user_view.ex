defmodule AiWeb.UserView do
  use AiWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, AiWeb.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, AiWeb.UserView, "user.json")}
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
