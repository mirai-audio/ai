defmodule AiWeb.API.V1.MediaView do
  use AiWeb, :view
  use JaSerializer.PhoenixView

  attributes([:provider_uid, :title, :url, :inserted_at, :updated_at])
end
