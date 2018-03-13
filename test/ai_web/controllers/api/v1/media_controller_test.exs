defmodule AiWeb.API.V1.MediaControllerTest do
  use AiWeb.ConnCase
  alias Ai.Medias.Media
  alias Ai.Repo

  @valid_attrs %{title: "some content", url: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = help_insert_user(username: username)

      conn =
        build_conn()
        |> help_put_req_jsonapi_headers()
        |> help_authenticate(user)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  defp relationships do
    %{}
  end

  @tag login_as: "max"
  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, media_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "prevents listing all entries on index for unauthorized user", %{conn: conn} do
    conn = get(conn, media_path(conn, :index))
    assert json_response(conn, 401)["data"] == nil
  end

  @tag login_as: "john"
  test "shows chosen resource", %{conn: conn, user: user} do
    media_attrs = %{title: "blah", url: "https://"}
    media = help_insert_media(user, media_attrs)
    conn = get(conn, media_path(conn, :show, media))
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{media.id}"
    assert data["type"] == "media"
    assert data["attributes"]["title"] == media.title
    assert data["attributes"]["url"] == media.url
  end

  @tag login_as: "yuuko"
  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent(404, fn ->
      get(conn, media_path(conn, :show, "5d2afd88-f403-43bf-a687-545bfb7a01a9"))
    end)
  end

  @tag login_as: "natsumi"
  test "creates and renders resource when data is valid", %{conn: conn} do
    conn =
      post(conn, media_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "medias",
          "attributes" => @valid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Media, @valid_attrs)
  end

  @tag login_as: "momotaro"
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn =
      post(conn, media_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "medias",
          "attributes" => @invalid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag login_as: "akira"
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    media = Repo.insert!(%Media{})

    conn =
      put(conn, media_path(conn, :update, media), %{
        "meta" => %{},
        "data" => %{
          "type" => "medias",
          "id" => media.id,
          "attributes" => @valid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Media, @valid_attrs)
  end

  @tag login_as: "Genevieve"
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    media = Repo.insert!(%Media{})

    conn =
      put(conn, media_path(conn, :update, media), %{
        "meta" => %{},
        "data" => %{
          "type" => "medias",
          "id" => media.id,
          "attributes" => @invalid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag login_as: "Abelard"
  test "deletes chosen resource", %{conn: conn, user: user} do
    media_attrs = %{title: "blah", url: "https://"}
    media = help_insert_media(user, media_attrs)
    conn = delete(conn, media_path(conn, :delete, media))
    assert response(conn, 204)
    refute Repo.get(Media, media.id)
  end
end
