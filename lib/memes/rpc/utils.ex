defmodule Memes.Rpc.Utils do

  def ok do
    {:ok, %{"status" => "ok"}}
  end

  def ok(result) do
    {:ok, %{"status" => "ok", "result" => result}}
  end

  def error(reason) do
    {:ok, %{"status" => "error", "reason" => reason}}
  end

end
