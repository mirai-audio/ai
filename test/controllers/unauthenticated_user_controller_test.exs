defmodule AiWeb.UnauthenticatedUserControllerTest do
  use AiWeb.ConnCase

  alias Ai.Credential

  @valid_attrs %{
    email: "a@bb.cc",
    password: "aaabbbcccddd",
    "password-confirmation": "aaabbbcccddd"
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn =
      post(conn, unauthenticated_user_path(conn, :create), %{
        data: %{type: "users", attributes: @valid_attrs}
      })

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Credential, %{provider_uid: @valid_attrs[:email]})
  end

  test "does not create resource and renders errors when data is empty", %{conn: conn} do
    assert_error_sent(400, fn ->
      _conn =
        post(conn, unauthenticated_user_path(conn, :create), %{
          data: %{type: "users", attributes: @invalid_attrs}
        })
    end)
  end

  # a@b.c
  test "does not create resource and renders errors when email is too short: a@b.c", %{conn: conn} do
    assert_error_sent(400, fn ->
      _conn =
        post(conn, unauthenticated_user_path(conn, :create), %{
          data: %{
            type: "users",
            attributes: %{
              email: "a@b.c",
              password: "aaabbbcccddd",
              password_confirmation: "aaabbbcccddd"
            }
          }
        })
    end)
  end

  # axbb.cc
  test "does not create resource and renders errors when email is invalid: aXbb.cc", %{conn: conn} do
    assert_error_sent(400, fn ->
      _conn =
        post(conn, unauthenticated_user_path(conn, :create), %{
          data: %{
            type: "users",
            attributes: %{
              email: "aXbb.cc",
              password: "aaabbbcccddd",
              password_confirmation: "aaabbbcccddd"
            }
          }
        })
    end)
  end
end
