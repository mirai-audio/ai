defmodule AiWeb.API.V1.MediaView do
  use AiWeb, :view
  use JaSerializer.PhoenixView

  attributes([:title, :url, :inserted_at, :updated_at])
end
