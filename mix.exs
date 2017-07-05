defmodule UPS.Mixfile do
  use Mix.Project

  def project do
    [app: :ups,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:httpoison, "~> 0.11.2"},
     {:poison, "~> 3.0"}]
  end
end
