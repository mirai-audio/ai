defmodule AiWeb.API.V1.MediaController do
  use AiWeb, :controller
  alias Ai.Medias
  alias JaSerializer.Params
  require Logger

  plug(:scrub_params, "data" when action in [:create, :update])

  def index(conn, _params) do
    user =
      conn
      |> Guardian.Plug.current_resource()

    medias = Medias.list_medias_for_user(user)
    render(conn, "index.json-api", data: medias)
  end

  def create(conn, %{
    "data" => data = %{
      "type" => "medias",
      "attributes" => _media_params
    }
  }) do
    user =
      conn
      |> Guardian.Plug.current_resource()
    attrs = Params.to_attributes(data)

    case Medias.create_media(user, attrs) do
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
    # any user can view any media (no private or permissions required)
    media = Ai.Medias.get_media!(id)
    render(conn, "show.json-api", data: media)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{
          "type" => "medias",
          "attributes" => _media_params
        }
      }) do
    media = Ai.Medias.get_media!(id)
    attrs = Params.to_attributes(data)
    case Medias.update_media(media, attrs) do
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

    # user must own media to be allowed to delete it
    media = Medias.get_user_media!(user, id)
    {:ok, _media} = Medias.delete_media(media)

    # http://jsonapi.org/format/#crud-deleting-responses-204
    send_resp(conn, :no_content, "")
  end
end
