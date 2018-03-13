defmodule Ai.TestHelpers do
  alias Ai.Repo

  def help_insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
       username: "testuser#{Base.encode16(:crypto.strong_rand_bytes(8))}",
     }, attrs)

    %Ai.Accounts.User{}
    |> Ai.Accounts.User.changeset(changes)
    |> Repo.insert!()
  end

  def help_insert_media(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:medias, attrs)
    |> Repo.insert!()
  end

  def help_put_req_jsonapi_headers(conn) do
    conn
    |> Plug.Conn.put_req_header("accept", "application/vnd.api+json")
    |> Plug.Conn.put_req_header("content-type", "application/vnd.api+json")
  end

  def help_authenticate(conn, user) do
    {:ok, jwt, _} = Guardian.encode_and_sign(user, nil, %{})

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer " <> jwt)
  end
end
