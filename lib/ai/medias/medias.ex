defmodule Ai.Medias do
  @moduledoc """
  The Medias context.
  """

  import Ecto.Query, warn: false
  alias Ai.Repo
  alias Ai.Medias.Media
  require Logger


  @doc """
  Creates a media for a user.

  ## Examples

      iex> create_media(%User{}, %{
        title: "A song name",
        url: "http://t.co/1234"})
      {:ok, %Media{}}
      iex> create_media(%User{})
      {:error, %Ecto.Changeset{}}

  """
  def create_media(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:medias)
    |> Media.changeset(attrs)
    |> Repo.insert()
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


  @doc """
  Gets a single media.

  Raises `Ecto.NoResultsError` if the Media does not exist.

  ## Examples

      iex> get_media!(123)
      %Media{}
      iex> get_media!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_media!(id) do
    Repo.get!(Media, id)
  end

  @doc """
  Gets a single media belonging to a user.

  Raises `Ecto.NoResultsError` if the Media does not exist.

  ## Examples

      iex> get_user_media!(user, 123)
      %Media{}
      iex> get_user_media!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_user_media!(user, id) do
    Repo.get_by!(Media, user_id: user.id, id: id)
  end

  @doc """
  Returns a list of medias for a specific user.

  ## Examples

      iex> Medias.list_medias_for_user(user)
      [%Ai.Medias.Media{}, ...]

  """
  def list_medias_for_user(user) do
    query = Media
    query = from m in query, where: m.user_id == ^user.id
    query = from m in query, order_by: m.title
    query = from m in query, preload: :user
    Repo.all(query)
  end

  @doc """
  Update an existing media.

  ## Examples

      iex> Medias.update_media(%Media{}, %{
        title: "A better song title"})
      {:ok, %Media{}}
      iex> Medias.update_media(%Media{}, %{
        title: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_media(%Media{} = media, attrs \\ %{}) do
    changeset = Media.changeset(media, attrs)
    Repo.update(changeset)
  end
end
