defmodule Ai.Medias.MediaTest do
  use Ai.DataCase
  alias Ai.Medias.Media


  @valid_title_attrs %{
    title: "asdf",
    url: "https://www.youtube.com/watch?v=kMHXd_iMGRU"
  }
  @valid_url_youtube_a_attrs %{
    title: "asdf youtube a",
    url: "https://www.youtube.com/watch?v=kMHXd_iMGRU&list=PLWbHc_FXPo2jV6N5XEjbUQe2GkYcRkZdD"
  }
  @invalid_attrs %{}
  @invalid_url_attrs %{
    title: "asdf youtube a",
    url: "https://www.youtu.be.com/watch?v=kMHXd_iMGRU"
  }

  test "changeset with valid title attributes" do
    changeset = Media.changeset(%Media{}, @valid_title_attrs)
    assert changeset.valid?
  end

  test "changeset with valid url youtube (a) attributes" do
    changeset = Media.changeset(%Media{}, @valid_url_youtube_a_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Media.changeset(%Media{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid url attributes" do
    changeset = Media.changeset(%Media{}, @invalid_url_attrs)
    refute changeset.valid?
  end
end
