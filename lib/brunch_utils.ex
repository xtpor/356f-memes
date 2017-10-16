
defmodule Brunch do

  @build_dev "brunch build"
  @build_prod "brunch build --production"
  @clean "npm run clean"

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

  def build(:dev), do: Brunch.Task.run(@build_dev)
  def build(:prod), do: Brunch.Task.run(@build_prod)

  def clean, do: Brunch.Task.run(@clean)

  def cmd(text) do
    require Logger

    Logger.info("#{text}")
    Port.open({:spawn, text}, [:binary, :stderr_to_stdout, {:cd, "assets"}])
  end

end

defmodule Brunch.Watcher do
  use GenServer
  require Logger

  @watch_cmd "brunch watch --stdin"

  def start_link(interval \\ 10000) do
    GenServer.start_link(__MODULE__, interval, name: __MODULE__)
  end

  def init(interval) do
    Process.flag(:trap_exit, true)
    {:ok, {interval, Brunch.cmd(@watch_cmd)}}
  end

  def handle_info({port, {:data, text}}, {interval, port}) do
    text |> String.trim |> IO.puts
    {:noreply, {interval, port}}
  end

  def handle_info({:EXIT, port, _reason}, {interval, port}) do
    Logger.info("brunch watcher crashed, restart in #{interval / 1000} seconds")
    Process.sleep(interval)
    {:noreply, {interval, Brunch.cmd(@watch_cmd)}}
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
    {:ok, Brunch.cmd(cmd)}
  end

  def handle_info({port, {:data, text}}, port) do
    text |> String.trim |> IO.puts
    {:noreply, port}
  end

  def handle_info({:EXIT, port, reason}, port) do
    {:stop, reason, port}
  end

end
