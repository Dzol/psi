defmodule Psi.Mixfile do
  use Mix.Project

  def project do
    [name: "Psi",
     app: :psi,
     version: "0.1.0",
     description: description(),
     elixir: "~> 1.5",
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: documentation(),
     package: package(),
     test_coverage: [tool: ExCoveralls]
    ] ++ dialyzer()
  end

  def application do
    [
      extra_applications: [:logger],
      env: configuration()
    ]
  end

  defp deps do
    [{:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
     {:credo, "~> 0.8.6", only: [:dev, :test]},
     {:ex_doc, "~> 0.16.3", only: :dev, runtime: false},
     {:excoveralls, "~> 0.7.2", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    A PRNG as a stream
    """
  end

  defp documentation do
    [output: "docs",
     main: "Psi"
    ]
  end

  defp package do
    [licenses: ["Apache 2.0"],
     maintainers: ["Joseph Yiasemides"],
     files: ["lib", "mix.exs", "README.md"],
     links: %{"GitHub" => "https://github.com/Dzol/psi/"}
    ]
  end

  defp dialyzer do
    [dialyzer: [plt_core_path: ".dialyzer/"]
    ]
  end

  defp configuration do
    [ default: [ modulus: 10, multiplier: 7, increment: 7 ] ]
  end
end
