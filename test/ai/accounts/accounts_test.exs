defmodule Ai.Accounts.AccountsTest do
  use Ai.DataCase
  alias Ai.Accounts


  describe "accounts" do
    alias Ai.Accounts.User

    @valid_user_attrs %{username: "fake-user"}
    @valid_user_update_attrs %{username: "asdf"}
    @invalid_user_update_attrs %{username: 1}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> Accounts.create_user()
      user
    end

    test "create_user/1 with valid input creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)
      assert user.username == "fake-user"
    end

    test "find_or_create_email_user/2 without existing user creates new user" do
      user_changeset = User.changeset(%User{}, %{username: "foceu"})
      credential_params = %{
        provider: "email",
        provider_uid: "foceu@example.com",
        password: "Password1234",
        password_confirmation: "Password1234"}
      assert {:ok, %User{} = user} =
        Accounts.find_or_create_email_user(user_changeset, credential_params)
      assert user.username == "foceu"
    end

    test "find_or_create_email_user/2 with existing user returns that user" do
      # create existing user (see above test)
      user_changeset = User.changeset(%User{}, %{username: "user-exists"})
      credential_params = %{
        provider: "email",
        provider_uid: "user-exists@example.com",
        password: "Password1234",
        password_confirmation: "Password1234"}
      {:ok, %User{} = user_a} =
        Accounts.find_or_create_email_user(user_changeset, credential_params)
      assert user_a.username == "user-exists"
      # try again (to enter the `credential ->` path
      assert {:ok, %User{} = user_b} =
        Accounts.find_or_create_email_user(user_changeset, credential_params)
      assert user_b.username == "user-exists"
      assert user_b.username == user_a.username
    end

    test "find_or_create_user/2 without existing user creates new user" do
      user_changeset = User.changeset(%User{}, %{username: "focu-new"})
      credential_params = %{
        provider: "twitter",
        provider_uid: "12345",
        provider_token: "abc123def"}
      assert {:ok, %User{} = user} =
        Accounts.find_or_create_user(user_changeset, credential_params)
      assert user.username == "focu-new"
    end

    test "find_or_create_user/2 with existing user returns that user" do
      # create existing user (see above test)
      user_changeset = User.changeset(%User{}, %{username: "soc-user-exists"})
      credential_params = %{
        provider: "twitter",
        provider_uid: "12345",
        provider_token: "abc123def"}
      {:ok, %User{} = user_a} =
        Accounts.find_or_create_user(user_changeset, credential_params)
      assert user_a.username == "soc-user-exists"
      # try again (to enter the `credential ->` path
      assert {:ok, %User{} = user_b} =
        Accounts.find_or_create_user(user_changeset, credential_params)
      assert user_b.username == "soc-user-exists"
      assert user_b.username == user_a.username
    end

    test "find_user/2 returns nil for no found user" do
      assert Accounts.find_user("", "") == nil
      assert Accounts.find_user("twitter", "uvw456xyz") == nil
    end

    test "find_user/2 returns user for valid user" do
      # create existing user (see above test)
      user_changeset = User.changeset(%User{}, %{username: "soc-user-exists"})
      credential_params = %{
        provider: "email",
        provider_uid: "mike@example.com"}
      {:ok, %User{} = user_a} =
        Accounts.find_or_create_user(user_changeset, credential_params)
      {:ok, user, _credential} = Accounts.find_user("email", "mike@example.com")
      assert user == user_a
    end

    test "find_twitter user/2 returns nil for no found user" do
      assert Accounts.find_twitter_user("", "") == nil
      assert Accounts.find_twitter_user("twitter", "uvw456xyz") == nil
    end

    test "find_twitter_user/2 returns user for valid user" do
      # create existing user (see above test)
      user_changeset = User.changeset(%User{}, %{username: "soc-user-exists"})
      credential_params = %{
        provider: "twitter",
        provider_uid: "12345",
        provider_token: "abc123def"}
      {:ok, %User{} = user_a} =
        Accounts.find_or_create_user(user_changeset, credential_params)
      {:ok, user, _credential} = Accounts.find_twitter_user("12345", "abc123def")
      assert user == user_a
    end

    test "get_user!/1 returns user with valid user id" do
      test_user = user_fixture()
      %User{id: id, username: username} = Accounts.get_user!(test_user.id)
      assert id == test_user.id
      assert username == test_user.username
    end

    test "list_users/0 returns all users" do
      user = user_fixture(%{credentials: []})
      users = Accounts.list_users()
      last = List.first(users)
      assert last.id == user.id
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user_a} = Accounts.update_user(user, @valid_user_update_attrs)
      assert %User{} = user_a
      assert user_a.username == "asdf"
    end

    test "update_user/2 with invalid data doesn't update the user" do
      user = user_fixture()
      assert {:error, _changeset} =
        Accounts.update_user(user, @invalid_user_update_attrs)
    end
  end
end
