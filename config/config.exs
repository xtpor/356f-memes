# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :memes, ecto_repos: [Memes.Repo]

config :memes, Memes.Repo,
  adapter: Sqlite.Ecto2,
  database: "priv/database/data.sqlite3"
