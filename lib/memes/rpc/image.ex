defmodule Memes.Utils do

  def unpack_data_url(data_url) do
    case data_url do
      "data:image/png;base64," <> data -> Base.decode64(data)
      _ -> :error
    end
  end

end

defmodule Memes.Rpc.Image do
  import Memes.Utils
  import Memes.Rpc.Utils

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

  defp match_header(header, {value, _}) do
    String.downcase(header) == String.downcase(value)
  end

  defp mime_type(headers) do
    case Enum.find(headers, &match_header("Content-Type", &1)) do
      nil -> :error
      {_, type} -> {:ok, type}
    end
  end

  defp to_data_url(%{body: body, headers: headers}) do
    {:ok, type} = mime_type(headers)
    "data:#{type};base64,#{Base.encode64 body}"
  end

  def upload_meme(token, title, data_url) when
      (is_binary(token) or is_nil(token)) and
      is_binary(title) and is_binary(data_url) do
    uname =
      case token do
        nil -> nil
        t ->
          case Memes.AuthToken.verify(t) do
            {:ok, un} -> un
            :error -> error("Invalid token")
          end
      end

    hash =
      case unpack_data_url(data_url) do
        {:ok, d} -> d
        :error -> error("Invalid DataURL")
      end
      |> Memes.ValueStore.put

    title = String.slice(title, 0..31)

    id = gen_meme_id()

    Memes.Repo.insert_all("memes",
      [[id: id, username: uname, title: title, image: hash]])

    ok(id)
  end

  def meme_info(id) when is_binary(id) do
    import Ecto.Query

    "memes"
    |> where([m], m.id == ^id)
    |> select([:id, :username, :title, :image])
    |> Memes.Repo.all
    |> case do
      [] -> error("Meme not exist")
      [info] -> ok(info)
    end
  end

  def user_album(username) when is_binary(username) do
    import Ecto.Query

    "memes"
    |> where([m], m.username == ^username)
    |> select([:id, :username, :title, :image])
    |> Memes.Repo.all
    |> ok
  end

  defp gen_meme_id do
    6 |> :crypto.strong_rand_bytes |> Base.url_encode64
  end

end
