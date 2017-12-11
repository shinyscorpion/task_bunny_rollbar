defmodule TaskBunnyRollbar.Mixfile do
  use Mix.Project

  @version "0.1.2"
  @description "TaskBunny job failure backend that reports the error to Rollbar"

  def project do
    [
      app: :task_bunny_rollbar,
      version: @version,
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: [
        extras: ["README.md"], main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/shinyscorpion/task_bunny_rollbar"
      ],
      description: @description,
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:rollbax]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:rollbax, ">= 0.6.0 and < 0.9.0"},
      {:task_bunny, "~> 0.2"},

      # dev
      {:ex_doc, "~> 0.14", only: :dev},
      {:inch_ex, "~> 0.5", only: :dev}
    ]
  end

  defp package do
    [
      name: :task_bunny_rollbar,
      files: [
        "mix.exs", "README.md", "LICENSE.md", # Project files
        "lib"
      ],
      maintainers: [
        "Elliott Hilaire",
        "Francesco Grammatico",
        "Ian Luites",
        "Ricardo Perez",
        "Tatsuya Ono"
      ],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/shinyscorpion/task_bunny_rollbar"}
    ]
  end
end
