defmodule AiWeb.UserView do
  use AiWeb, :view
  use JaSerializer.PhoenixView


  attributes([:username, :inserted_at, :updated_at])
end
