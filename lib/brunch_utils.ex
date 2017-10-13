
defmodule Brunch do

  @build_dev "npm run build-dev --prefix assets"
  @build_prod "npm run build --prefix assets"

  def poll(interval \\ 20000) do
    Brunch.Poller.start_link(interval)
  end

  def unpoll do
    GenServer.stop(Brunch.Poller)
  end

  def watch do
    Brunch.Watcher.start_link
  end

  def unwatch do
    GenServer.stop(Brunch.Watcher)
  end

  def build do
    build(:dev)
  end

  def build(:dev) do
    Brunch.Task.run(@build_dev)
  end

  def build(:prod) do
    Brunch.Task.run(@build_prod)
  end

end

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
    Logger.info("brunch watcher crashed, restart in #{s} seconds")
    Process.sleep(@restart_interval)
    {:noreply, open_port()}
  end

  defp open_port do
    cmd = "npm start --prefix assets"
    Logger.info("#{__MODULE__}: #{cmd}")
    Port.open({:spawn, cmd}, [:binary, :stderr_to_stdout])
  end

end

defmodule Brunch.Poller do
  use GenServer
  require Logger

  def start_link(poll_interval) do
    GenServer.start_link(__MODULE__, poll_interval, name: __MODULE__)
  end

  def init(interval) do
    send(self(), :rebuild)
    {:ok, interval}
  end

  def handle_info(:rebuild, interval) do
    Logger.info("#{__MODULE__}: rebuilding")
    Brunch.build
    Process.send_after(self(), :rebuild, interval)
    {:noreply, interval}
  end

end

defmodule Brunch.Task do
  require Logger

  def run(cmd) do
    GenServer.start_link(__MODULE__, cmd)
  end

  def init(cmd) do
    Process.flag(:trap_exit, true)
    Logger.info("#{cmd}")
    {:ok, Port.open({:spawn, cmd}, [:binary, :stderr_to_stdout])}
  end

  def handle_info({port, {:data, text}}, port) do
    text |> String.trim |> IO.puts
    {:noreply, port}
  end

  def handle_info({:EXIT, port, reason}, port) do
    {:stop, reason, port}
  end

end
