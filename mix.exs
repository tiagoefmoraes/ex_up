defmodule ExUp.MixProject do
  use Mix.Project

  @source_url "https://github.com/tiagoefmoraes/ex_up"
  @version "0.1.0"

  def project do
    [
      app: :ex_up,
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      name: "ExUp",
      description: "Use newer elixir features on older versions",
      source_url: @source_url,
      homepage_url: @source_url,
      package: package(),
      docs: docs(),
      preferred_cli_env: [
        "test.watch": :test
      ],
      aliases: aliases(),
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

  # Run "mix help docs" to learn about docs.
  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      groups_for_modules: [
        Internal: [
          ExUp
        ]
      ],
      formatters: ["html"]
    ]
  end

  defp aliases do
    [
      version: fn _ -> IO.puts(@version) end
    ]
  end

  defp package do
    [
      maintainers: ["Tiago Moraes"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false}
    ]
  end
end
