defmodule TaskBunnyRollbar.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :task_bunny_rollbar,
      version: @version,
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:rollbax]
    ]
  end

  defp deps do
    [
      {:task_bunny, "~> 0.2"},
      {:rollbax, "~> 0.6"},
    ]
  end
end
