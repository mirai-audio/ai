defmodule Ai.MediaView do
  use Ai.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :url, :inserted_at, :updated_at]

end
