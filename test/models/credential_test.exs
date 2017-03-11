defmodule Ai.CredentialTest do
  use Ai.ModelCase

  alias Ai.Credential


  @valid_attrs %{user_id: 1,
                 provider: "email",
                 provider_uid: "a@bb.cc",
                 password: "aaabbbcccddd",
                 password_confirmation: "aaabbbcccddd"}
  @valid_attrs_emoji %{user_id: 1,
                       provider: "email",
                       provider_uid: "a@🍔🎉.🍔🎉",
                       password: "aaabbbcccddd",
                       password_confirmation: "aaabbbcccddd"}
  @invalid_attrs_empty %{}
  @invalid_attrs_short_provider_uid %{user_id: 1,
                                      provider: "email",
                                      provider_uid: "a@b.c",
                                      password: "aaabbbcccddd",
                                      password_confirmation: "aaabbbcccddd"}
  @invalid_attrs_short_emoji_provider_uid %{user_id: 1,
                                            provider: "email",
                                            provider_uid: "a@🍔.🎉",
                                            password: "aaabbbcccddd",
                                            password_confirmation: "aaabbbcccddd"}
  @invalid_attrs_invalid_provider_uid %{user_id: 1,
                                        provider: "email",
                                        provider_uid: "aXbb.cc",
                                        password: "aaabbbcccddd",
                                        password_confirmation: "aaabbbcccddd"}
  @invalid_attrs_bad_pw_len %{user_id: 1,
                              provider: "email",
                              provider_uid: "user@example.com",
                              password: "aaabbbccc",
                              password_confirmation: "aaabbbccc"}
  @invalid_attrs_bad_pw_confirm %{user_id: 1,
                                  provider: "email",
                                  provider_uid: "user@example.com",
                                  password: "aaabbbcccddd",
                                  password_confirmation: "aaabbbccc"}

  test "email_changeset with valid attributes: a@bb.cc" do
    changeset = Credential.email_changeset(%Credential{}, @valid_attrs)
    assert changeset.valid?
  end

  test "email_changeset with valid attributes: emoji" do
    changeset = Credential.email_changeset(%Credential{}, @valid_attrs_emoji)
    assert changeset.valid?
  end

  test "email_changeset with empty attributes" do
    changeset = Credential.email_changeset(%Credential{}, @invalid_attrs_empty)
    refute changeset.valid?
  end

  test "email_changeset with short provider_uid: a@b.c" do
    changeset = Credential.email_changeset(%Credential{}, @invalid_attrs_short_provider_uid)
    refute changeset.valid?
  end

  test "email_changeset with short emoji provider_uid: emoji" do
    changeset = Credential.email_changeset(%Credential{}, @invalid_attrs_short_emoji_provider_uid)
    refute changeset.valid?
  end

  test "email_changeset with invalid provider_uid" do
    changeset = Credential.email_changeset(%Credential{}, @invalid_attrs_invalid_provider_uid)
    refute changeset.valid?
  end

  test "email_changeset with short password" do
    changeset = Credential.email_changeset(%Credential{}, @invalid_attrs_bad_pw_len)
    refute changeset.valid?
  end

  test "email_changeset with wrong password confirmation" do
    changeset = Credential.email_changeset(%Credential{}, @invalid_attrs_bad_pw_confirm)
    refute changeset.valid?
  end
end
