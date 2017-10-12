
defmodule Brunch.Watcher do
  require Logger
  use GenServer

  @restart_interval 10000

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, open_port()}
  end

  def handle_info({port, {:data, text}}, port) do
    text |> String.trim |> IO.puts
    {:noreply, port}
  end

  def handle_info({:EXIT, port, _reason}, port) do
    s = @restart_interval / 1000
    Logger.info("#{__MODULE__}: process crashed, restart after #{s} seconds")
    Process.sleep(@restart_interval)
    {:noreply, open_port()}
  end

  defp open_port do
    cmd = "npm start --prefix #{File.cwd!}/assets"
    Logger.info("#{__MODULE__}: #{cmd}")
    Port.open({:spawn, cmd}, [:binary, :stderr_to_stdout])
  end

end
