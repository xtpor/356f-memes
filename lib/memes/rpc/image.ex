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
  import Ecto.Query
  alias Memes.Repo

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
    now = DateTime.utc_now
    id = gen_meme_id()

    Repo.insert_all("memes",
      [[id: id, username: uname, title: title, image: hash, created_at: now]])

    ok(id)
  end

  def meme_info(id) when is_binary(id) do
    "memes"
    |> where([m], m.id == ^id)
    |> select([:id, :username, :title, :image, :created_at])
    |> Repo.all
    |> case do
      [] -> error("Meme not exist")
      [info] ->
        info
        |> to_iso8601
        |> calculate_num_likes
        |> fetch_comments
        |> ok()
    end
  end

  def user_album(username) when is_binary(username) do
    "memes"
    |> where([m], m.username == ^username)
    |> select([:id, :username, :title, :image, :created_at])
    |> Repo.all
    |> Enum.map(&to_iso8601/1)
    |> Enum.map(&calculate_num_likes/1)
    |> Enum.map(&fetch_comments/1)
    |> ok
  end

  defp gen_meme_id do
    6 |> :crypto.strong_rand_bytes |> Base.url_encode64
  end

  defp to_iso8601(%{created_at: t} = record) do
    %{ record | created_at: t <> "Z" }
  end

  def like(token, meme) when is_binary(token) and is_binary(meme) do
    username = login_as!(token)
    try do
      Repo.insert_all("likes", [[username: username, meme: meme]])
      ok()
    rescue
      _ -> error("Invalid operation, already liked")
    end
  end

  def unlike(token, meme) when is_binary(token) and is_binary(meme) do
    username = login_as!(token)
    "likes"
    |> where([l], l.username == ^username and l.meme == ^meme)
    |> Repo.delete_all
    ok()
  end

  def like_status(token, meme) when is_binary(token) and is_binary(meme) do
    username = login_as!(token)
    "likes"
    |> where([l], l.username == ^username and l.meme == ^meme)
    |> select([:meme])
    |> Repo.all
    |> case do
      [] -> false
      [_] -> true
    end
    |> ok
  end

  defp calculate_num_likes(%{id: meme} = record) do
    [number] =
      "likes"
      |> where([meme: ^meme])
      |> select([l], count(l.username))
      |> Repo.all

    Map.put(record, :num_likes, number)
  end

  def comment(token, meme, content)
      when is_binary(token) and is_binary(meme) and is_binary(content) do
    now = DateTime.utc_now
    uname = login_as!(token)
    at_least!(content, 1, "Comment cannot be empty")
    at_most!(content, 2000, "Comment cannot has more than 2000 characters")

    Repo.insert_all("comments", [[
      username: uname, meme: meme, content: content, created_at: now]])
    ok()
  end

  defp fetch_comments(%{id: meme} = record) do
    comments =
      "comments"
      |> where([c], c.meme == ^meme)
      |> select([:username, :content, :created_at])
      |> order_by([desc: :created_at])
      |> Repo.all
      |> Enum.map(&to_iso8601/1)

    Map.put(record, :comments, comments)
  end

end
