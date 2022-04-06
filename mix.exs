defmodule ExUp.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_up,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        "test.watch": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 0.5", only: [:dev, :test]}
    ]
  end
end
