defmodule Ai.Medias.MediasTest do
  use Ai.DataCase
  alias Ai.Accounts
  alias Ai.Medias


  describe "medias" do
    alias Ai.Medias.Media

    @valid_media_attrs %{title: "test song", url: "http://example.com"}
    @valid_media_update_attrs %{title: "updated song", url: "http://t.co"}
    @invalid_media_attrs %{title: nil, url: nil}
    @valid_user_attrs %{username: "test-user"}

    def media_fixture(user, attrs \\ %{}) do
      attrs = attrs
      |> Enum.into(@valid_media_attrs)
      {:ok, media} = Medias.create_media(user, attrs)
      media
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> Accounts.create_user()
      user
    end

    test "create_media/1 with valid data creates a media" do
      user = user_fixture()
      assert {:ok, %Media{} = audio} = Medias.create_media(user, @valid_media_attrs)
      assert audio.title == "test song"
      assert audio.url == "http://example.com"
    end

    test "delete_media/1 deletes the media" do
      media = media_fixture(user_fixture())
      assert {:ok, %Media{}} = Medias.delete_media(media)
      assert_raise Ecto.NoResultsError, fn -> Medias.get_media!(media.id) end
    end

    test "get_media!/1 returns the media with given id" do
      media = media_fixture(user_fixture())
      assert Medias.get_media!(media.id) == media
    end

    test "get_user_media!/1 returns the media with given user and id" do
      user = user_fixture()
      media = media_fixture(user)
      assert Medias.get_user_media!(user, media.id) == media
    end

    test "list_medias_for_user/1 returns all a users medias" do
      user = user_fixture(%{credentials: []})
      media_a = media_fixture(user, %{title: "Song a"})
      media_b = media_fixture(user, %{title: "Song b"})
      [%Media{id: id_a}, %Media{id: id_b}] = Medias.list_medias_for_user(user)
      assert id_a == media_a.id
      assert id_b == media_b.id
    end

    test "update_media/2 with valid data updates the media" do
      media = media_fixture(user_fixture())
      assert {:ok, media} = Medias.update_media(media, @valid_media_update_attrs)
      assert %Media{} = media
      assert media.title == "updated song"
      assert media.url == "http://t.co"
    end

    test "update_media/2 with invalid data returns error changeset" do
      media = media_fixture(user_fixture())
      assert {:error, %Ecto.Changeset{}} = Medias.update_media(media, @invalid_media_attrs)
      assert media == Medias.get_media!(media.id)
    end
  end
end
