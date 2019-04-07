defmodule Transmit.MixProject do
  use Mix.Project

  def project do
    [
      app: :transmit,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Docs
      name: "Transmit",
      source_url: "https://github.com/revelrylabs/transmit",
      homepage_url: "https://github.com/revelrylabs/transmit",
      # The main page in the docs
      docs: [main: "Transmit", extras: ["README.md"]]
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
      {:plug, "~> 1.8"},
      {:uuid, "~> 1.1"},
      {:ex_aws, "~> 2.0", optional: true},
      {:ex_aws_s3, "~> 2.0", optional: true},
      {:jason, "~> 1.0", optional: true},
      {:ex_doc, "~> 0.20", only: :dev},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp description do
    """
    Transmit
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE", "CHANGELOG.md"],
      maintainers: ["Revelry Labs"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/revelrylabs/transmit"
      },
      build_tools: ["mix"]
    ]
  end
end