defmodule Ai.MediaProvider.MediaProviderTest do
  use Ai.DataCase
  alias Ai.MediaProvider

  @valid_provider_url   "https://www.youtu.be/watch?v=kMHXd_iMGRU"
  @invalid_provider_url "https://www.youtu.be.com/watch?v=kMHXd_iMGRU"

  test "parse! with valid provider url" do
    %MediaProvider{provider: provider, provider_uid: provider_uid} =
      MediaProvider.parse!(@valid_provider_url)
    assert provider == "youtube"
    assert provider_uid == "kMHXd_iMGRU"
  end

  test "parse! with invalid provider url" do
    {:error, message} = MediaProvider.parse!(@invalid_provider_url)
    assert message == "parse error: no implementation for www.youtu.be.com"
  end
end
