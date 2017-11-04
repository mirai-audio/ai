defmodule AiWeb.MediaView do
  use AiWeb, :view
  use JaSerializer.PhoenixView

  attributes([:title, :url, :inserted_at, :updated_at])
end
