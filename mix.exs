defmodule UPS.Mixfile do
  use Mix.Project

  def project do
    [app: :ups,
     description: "Basic Elixir HTTPoison wrapper around the UPS street level validation API.",
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     docs: docs(),
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:httpoison, "~> 0.11.2"},
     {:poison, "~> 3.0"},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      maintainers: ["Zachary Berkompas"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/infinitered/ups"
      }
    ]
  end

  defp docs do
    [
      readme: "README.md",
      main: UPS
    ]
  end
end
