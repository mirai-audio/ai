defmodule Ai.MediaController do
  use Ai.Web, :controller

  alias Ai.Media

  def index(conn, _params) do
    medias = Repo.all(Media)
    render(conn, "index.json", medias: medias)
  end

  def create(conn, %{"media" => media_params}) do
    changeset = Media.changeset(%Media{}, media_params)

    case Repo.insert(changeset) do
      {:ok, media} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", media_path(conn, :show, media))
        |> render("show.json", media: media)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ai.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    media = Repo.get!(Media, id)
    render(conn, "show.json", media: media)
  end

  def update(conn, %{"id" => id, "media" => media_params}) do
    media = Repo.get!(Media, id)
    changeset = Media.changeset(media, media_params)

    case Repo.update(changeset) do
      {:ok, media} ->
        render(conn, "show.json", media: media)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ai.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    media = Repo.get!(Media, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(media)

    send_resp(conn, :no_content, "")
  end
end
