defmodule GradingClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :grading_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {GradingClient.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.10"},
      {:bcrypt_elixir, "~> 3.2"},
      {:httpoison, "~> 2.2"},
      {:benchwarmer,
       github: "mroth/benchwarmer", ref: "12b5a96b38cef09f2bd49e5c2dd5024100c1e8af"},
      {:uuid, "~> 1.1"},
      {:plug, "~> 1.18"},
      {:phoenix, "~> 1.7"},
      {:sobelow, "~> 0.14"}
    ]
  end
end
