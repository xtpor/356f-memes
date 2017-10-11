defmodule Memes do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    opts = [ip: {0, 0, 0, 0}, port: 8080]

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Memes.Endpoint, [], opts),
      worker(Memes.ValueStore, [])
    ]

    opts = [strategy: :one_for_one, name: Memes.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
