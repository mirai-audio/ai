defmodule Ai.MediaProvider.Example do
  @doc """
  Handle URL parsing for example URLs.

  Some examples:
  https://www.example.com/watch?v=kMHXd_iMGRU
  http://www.example.com/watch?v=kMHXd_iMGRU
  http://example.com/watch?v=kMHXd_iMGRU
  """
  @behaviour Ai.MediaProvider

  def parse(nil), do: {:error, "can't be nil"}
  def parse(url) do
    host = URI.parse(url).host
    {:error, "no implementation for #{host}"}
  end
end
