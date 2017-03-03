defmodule Ai.MediaView do
  use Ai.Web, :view

  def render("index.json", %{medias: medias}) do
    %{data: render_many(medias, Ai.MediaView, "media.json")}
  end

  def render("show.json", %{media: media}) do
    %{data: render_one(media, Ai.MediaView, "media.json")}
  end

  def render("media.json", %{media: media}) do
    %{id: media.id,
      title: media.title,
      url: media.url}
  end
end
