defmodule Ai.MediaProvider do
  defstruct provider: "",
            provider_uid: ""

  @callback parse(String.t) :: {:ok, %__MODULE__{}} | {:error, String.t}

  def parse!(url) do
    implementation = detect_implementation(url)
    case implementation.parse(url) do
      {:error, error} -> {:error, "parse error: #{error}"}
      data -> data
    end
  end

  defp detect_implementation(nil), do: Ai.MediaProvider.Example
  defp detect_implementation(url) do
    host = URI.parse(url).host
    cond do
      Regex.match?(~r/youtu(be\.com|\.be)+$/, host) ->
        Ai.MediaProvider.Youtube
      true ->
        Ai.MediaProvider.Example
    end
  end
end
