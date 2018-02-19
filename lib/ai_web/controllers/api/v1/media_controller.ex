defmodule AiWeb.API.V1.MediaController do
  use AiWeb, :controller
  alias Ai.Media
  alias Ai.Medias
  alias JaSerializer.Params
  require Logger

  plug(:scrub_params, "data" when action in [:create, :update])

  def index(conn, _params) do
    user =
      conn
      |> Guardian.Plug.current_resource()

    query = Media
    query = from m in query, where: m.user_id == ^user.id
    query = from m in query, order_by: m.title
    query = from m in query, preload: :user
    medias = Repo.all(query)

    render(conn, "index.json-api", data: medias)
  end

  def create(conn, %{"data" => data = %{"type" => "medias", "attributes" => _media_params}}) do
    user =
      conn
      |> Guardian.Plug.current_resource()

    changeset =
      user
      |> Ecto.build_assoc(:medias)
      |> Media.changeset(Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, media} ->
        Logger.info("created new media '#{media.title}'.")

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

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "medias", "attributes" => _media_params}
      }) do
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
    user =
      conn
      |> Guardian.Plug.current_resource()

    media = Medias.get_media!(user, id)
    {:ok, _media} = Medias.delete_media(media)

    # http://jsonapi.org/format/#crud-deleting-responses-204
    send_resp(conn, :no_content, "")
  end
end
