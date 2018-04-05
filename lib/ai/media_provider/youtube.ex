defmodule Ai.MediaProvider.Youtube do
  @doc """
  Handle URL parsing for Youtube URLs.

  Some examples:
  https://www.youtube.com/watch?v=kMHXd_iMGRU&list=PLWbHc_FXPo2jV6N5XEjbUQe2GkYcRkZdD
  https://www.youtube.com/v/kMHXd_iMGRU?fs=1&amp;hl=en_US&amp;rel=0
  https://www.youtube.com/watch?v=kMHXd_iMGRU#t=0m10s
  https://www.youtube.com/watch?v=kMHXd_iMGRU
  https://www.youtube.com/embed/kMHXd_iMGRU
  https://youtu.be/kMHXd_iMGRU
  """
  alias Ai.MediaProvider
  @behaviour Ai.MediaProvider
  @name "youtube"

  def parse(nil), do: {:error, "can't be nil"}
  def parse(url) do
    provider_uid = get_provider_uid(url)
    cond do
      String.length(provider_uid) == 0 ->
        {:error, "URL query not supported by parse"}
      true ->
        %MediaProvider{provider: @name, provider_uid: provider_uid}
    end
  end

  defp get_provider_uid(nil), do: nil
  defp get_provider_uid(url) do
    ~r/^.*(?:youtu\.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)(?<id>[^#\&\?]*).*/
    |> Regex.named_captures(url)
    |> get_in(["id"])
  end
end
