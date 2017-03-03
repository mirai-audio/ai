defmodule Ai.MediaControllerTest do
  use Ai.ConnCase

  alias Ai.Media
  alias Ai.Repo

  @valid_attrs %{title: "some content", url: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, media_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    media = Repo.insert! %Media{}
    conn = get conn, media_path(conn, :show, media)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{media.id}"
    assert data["type"] == "media"
    assert data["attributes"]["title"] == media.title
    assert data["attributes"]["url"] == media.url
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, media_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, media_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "media",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Media, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, media_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "media",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    media = Repo.insert! %Media{}
    conn = put conn, media_path(conn, :update, media), %{
      "meta" => %{},
      "data" => %{
        "type" => "media",
        "id" => media.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Media, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    media = Repo.insert! %Media{}
    conn = put conn, media_path(conn, :update, media), %{
      "meta" => %{},
      "data" => %{
        "type" => "media",
        "id" => media.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    media = Repo.insert! %Media{}
    conn = delete conn, media_path(conn, :delete, media)
    assert response(conn, 204)
    refute Repo.get(Media, media.id)
  end

end
