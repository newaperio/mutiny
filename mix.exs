defmodule Mutiny.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/newaperio/mutiny"

  def project do
    [
      app: :mutiny,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: ~w(lib test/support),
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
      links: %{
        "GitHub" => @repo_url,
        "Made by NewAperio" => "https://newaperio.com/"
      }
    ]
  end

  defp docs do
    [
      name: "Mutiny",
      main: "getting-started",
      logo: "mark.png",
      source_ref: "v#{@version}",
      canonical: "https://hexdocs.pm/mutiny",
      source_url: "https://github.com/newaperio/mutiny",
      extras: ["guides/getting-started.md"]
    ]
  end
end
