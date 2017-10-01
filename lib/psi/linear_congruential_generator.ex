defmodule Psi.LinearCongruentialGenerator do
  @moduledoc """
  A Linear Congruential Generator

  ## Example
      iex> alias Psi.LinearCongruentialGenerator, as: LCG
      Psi.LinearCongruentialGenerator
      iex> LCG.stream(seed: 7) |> Psi.PairStream.take(3)
      [7, 6, 9]
  """

  @typedoc """
  Main interface for building an LCG

  See _Wikipedia_ or _Knuth_ to select values for these parameters.
  The current default configuration is awful.
  """
  @type t :: %__MODULE__{
    modulus:    integer(),
    multiplier: integer(),
    increment:  integer()
  }
  @enforce_keys [
    :modulus,
    :multiplier,
    :increment
  ]
  defstruct [
    modulus:    0,
    multiplier: 0,
    increment:  0
  ]

  @type configuration :: [seed: integer] | [generator: function, seed: integer]

  @doc """
  An LCG stream

  Build a generator with the LCG structure + `instance/1`.
  """
  @spec stream(configuration) :: Psi.PairStream.t
  def stream(seed: x) when is_integer(x) do
    stream(generator: instance(default()), seed: x)
  end
  def stream(generator: f, seed: x) when is_function(f) and is_integer(x) do
    [x|fn ->
      stream(generator: f, seed: apply(f, [x]))
    end]
  end

  @doc """
  An Linear Congruential Generator with the given parameters
  """
  @spec instance(t) :: function
  def instance(%__MODULE__{modulus: m, multiplier: a, increment: c}) do
    okay!(m, a, c) and instance(m, a, c)
  end

  @spec default() :: t
  defp default do
    struct!(__MODULE__, Application.fetch_env!(:psi, :default))
  end

  @spec okay!(integer, integer, integer) :: true | no_return
  defp okay!(m, a, c) do
    true = m > 0
    true = m > a and a >= 0
    true = m > c and c >= 0
  end

  @spec instance(integer, integer, integer) :: function
  defp instance(m, a, c) do
    fn (x) ->
      Integer.mod((a * x) + c, m)
    end
  end
end
