defmodule AiWeb.UserController do
  use AiWeb, :controller
  alias Ai.Accounts
  alias Ai.Accounts.User


  def create(conn, %{
        "data" => %{
          "type" => "users",
          "attributes" => %{
            "email" => email,
            "password" => password,
            "password-confirmation" => password_confirmation
          }
        }
      }) do
    # ToDo: assign a default username: username
    user_params = %{}
    user_changeset = User.changeset(%User{}, user_params)

    credential_params = %{
      provider: "email",
      provider_uid: email,
      password: password,
      password_confirmation: password_confirmation
    }

    case Accounts.find_or_create_email_user(user_changeset, credential_params) do
      {:ok, credential} ->
        conn
        |> put_status(:created)
        |> render("show.json-api", data: credential)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
