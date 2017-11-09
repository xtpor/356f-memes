# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :memes, ecto_repos: [Memes.Repo]

config :memes, Memes.Repo,
  adapter: Sqlite.Ecto2,
  database: "priv/database/data.sqlite3"

config :memes, :sign_key, "64WM6jS9QLw39E4WORiepp6iUZKuV4CpsGQqGVUk"

config :memes, :email_relay, "smtp.gmail.com"
config :memes, :email_username, "comps356f.ouhk@gmail.com"
config :memes, :email_password, "monkeys dictionary"
