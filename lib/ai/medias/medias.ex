defmodule Ai.Medias do
  @moduledoc """
  The Medias context.
  """

  import Ecto.Query, warn: false
  alias Ai.Repo
  alias Ai.Media
  require Logger

  @doc """
  Gets a single media.

  Raises `Ecto.NoResultsError` if the Media does not exist.

  ## Examples

      iex> get_media!(user, 123)
      %Media{}

      iex> get_media!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_media!(user, id) do
    Repo.get_by!(Media, user_id: user.id, id: id)
  end

  @doc """
  Deletes a Media.

  ## Examples

      iex> delete_media(media)
      {:ok, %Media{}}

      iex> delete_media(media)
      {:error, %Ecto.Changeset{}}

  """
  def delete_media(%Media{} = media) do
    Logger.info("deleted media '#{media.title}'.")
    Repo.delete(media)
  end
end
