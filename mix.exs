defmodule Memes.Mixfile do
  use Mix.Project

  def project do
    [
      app: :memes,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Memes, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.4"},
      {:cowboy, "~> 1.1"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.13.0"}
    ]
  end
end
