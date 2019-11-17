defmodule ExNotification.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_notification,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      name: "ExNotification",
      source_url: "https://github.com/maxneuvians/ex_notification",
      homepage_url: "https://github.com/maxneuvians/ex_notification",
      docs: [
        main: "ExNotification"
      ],
      description: description(),
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:hackney, "~> 1.14.0"},
      {:joken, "~> 2.0"},
      {:jason, ">= 1.0.0"},
      {:tesla, "~> 1.3.0"},
    ]
  end

  defp description() do
    "An elixir client for the notification system APIs used by the Australian, British, and Canadian governments."
  end

  defp package() do
    [
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/maxneuvians/ex_notification"}
    ]
  end
end
