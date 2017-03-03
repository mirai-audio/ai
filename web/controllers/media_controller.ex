defmodule Ai.MediaController do
  use Ai.Web, :controller

  alias Ai.Media
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    medias = Repo.all(Media)
    render(conn, "index.json-api", data: medias)
  end

  def create(conn, %{"data" => data = %{"type" => "media", "attributes" => _media_params}}) do
    changeset = Media.changeset(%Media{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, media} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", media_path(conn, :show, media))
        |> render("show.json-api", data: media)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    media = Repo.get!(Media, id)
    render(conn, "show.json-api", data: media)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "media", "attributes" => _media_params}}) do
    media = Repo.get!(Media, id)
    changeset = Media.changeset(media, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, media} ->
        render(conn, "show.json-api", data: media)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
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
