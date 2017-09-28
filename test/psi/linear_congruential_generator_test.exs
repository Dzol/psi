defmodule Psi.LinearCongruentialGeneratorTest do
  use ExUnit.Case

  describe "instance/3" do
    alias Psi.LinearCongruentialGenerator, as: LCG

    test "Wikipedia's 1st + 2nd" do
      x = %LCG{
        modulus:    9,
        multiplier: 2,
        increment:  0
      }
      f = LCG.instance(x)

      s = 1
      assert f.(s) === 2
      assert f.(2) === 4
      assert f.(4) === 8
      assert f.(8) === 7
      assert f.(7) === 5
      assert f.(5) === s

      s = 3
      assert f.(s) === 6
      assert f.(6) === s
    end

    test "Wikipedia's 3rd" do
      x = %LCG{
        modulus:    9,
        multiplier: 4,
        increment:  1
      }
      f = LCG.instance(x)

      s = 0
      assert f.(s) === 1
      assert f.(1) === 5
      assert f.(5) === 3
      assert f.(3) === 4
      assert f.(4) === 8
      assert f.(8) === 6
      assert f.(6) === 7
      assert f.(7) === 2
      assert f.(2) === s
    end
  end

  describe "stream/1" do
    alias Psi.LinearCongruentialGenerator, as: LCG

    test "Knuth (3rd edition)" do
      x = %LCG{
        modulus:    10,
        multiplier: 7,
        increment:  7
      }
      u = LCG.stream(generator: LCG.instance(x), seed: 7)
      assert Psi.PairStream.take(u, 4) === [7, 6, 9, 0]
    end

    test "Knuth (3rd edition) cycle" do
      x = %LCG{
        modulus:    10,
        multiplier: 7,
        increment:  7
      }
      period = 4; u = LCG.stream(generator: LCG.instance(x), seed: 7)
      assert [x, x, x] = Enum.chunk_every(Psi.PairStream.take(u, 3 * period), period)
    end

    test "default is Knuth (3rd edition)" do
      u = LCG.stream(seed: 7)
      assert Psi.PairStream.take(u, 4) === [7, 6, 9, 0]
    end
  end
end
