defmodule Mutiny.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :mutiny,
      version: @version,
      elixir: "~> 1.9",
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      description: "Simple database immutability",
      maintainers: ["N. G. Scheurich"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/newaperio/mutiny"}
    ]
  end

  defp docs do
    [
      name: "Mutiny",
      main: "readme",
      logo: "mark.png",
      source_ref: "v#{@version}",
      canonical: "https://hexdocs.pm/mutiny",
      source_url: "https://github.com/newaperio/mutiny",
      extras: ["README.md"]
    ]
  end
end
