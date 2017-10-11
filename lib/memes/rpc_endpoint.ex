defmodule Memes.RpcEndpoint do

  def fetch(url) when is_binary(url) do
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200} = resp} ->
        case valid_mime_type?(resp) do
          true -> {:ok, %{"data" => to_data_url(resp)}}
          false -> {:ok, %{"error" => "The url you requested is not an image :("}}
        end
      {:ok, _} ->
        {:ok, %{"error" => "The url you requested does not exist :("}}
      {:error, _} ->
        {:ok, %{"error" => "The url you requested does not exist :("}}
    end
  end

  defp valid_mime_type?(resp) do
    case mime_type(resp.headers) do
      {:ok, type} ->
        case type do
          "image/gif" -> true
          "image/jpeg" -> true
          "image/png" -> true
          "image/svg+xml" -> true
          _ -> false
        end
      :error ->
        false
    end
  end

  defp mime_type(headers) do
    case Enum.find(headers, &match?({"Content-Type", _}, &1)) do
      nil -> :error
      {"Content-Type", type} -> {:ok, type}
    end
  end

  defp to_data_url(%{body: body, headers: headers}) do
    {:ok, type} = mime_type(headers)
    "data:#{type};base64,#{Base.encode64 body}"
  end

  def upload(data_url) when is_binary(data_url) do
    case unpack_data_url(data_url) do
      {:ok, data} ->
        {:ok, %{"ok" => Memes.ValueStore.put(data)}}
      :error ->
        {:ok, %{"error" => "Invalid DataURL"}}
    end
  end

  defp unpack_data_url(data_url) do
    case data_url do
      "data:image/png;base64," <> data -> Base.decode64(data)
      _ -> :error
    end
  end

end
