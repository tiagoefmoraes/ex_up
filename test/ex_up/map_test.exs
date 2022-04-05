defmodule ExUp.MapTest do
  use ExUnit.Case, async: true

  describe "filter/2" do
    if Version.match?(System.version(), ">= 1.13.0") do
      test "works as Map.filter/2" do
        map = %{a: 1, b: 2}
        fun = fn {_k, v} -> v > 1 end
        assert ExUp.Map.filter(map, fun) == Map.filter(map, fun)
        assert ExUp.Map.__filter__(map, fun) == Map.filter(map, fun)
      end
    else
      test "works as Map.filter/2" do
        map = %{a: 1, b: 2}
        fun = fn {_k, v} -> v > 1 end
        assert ExUp.Map.filter(map, fun) == %{b: 2}
      end
    end
  end

  describe "reject/2" do
    if Version.match?(System.version(), ">= 1.13.0") do
      test "works as Map.reject/2" do
        map = %{a: 1, b: 2}
        fun = fn {_k, v} -> v > 1 end
        assert ExUp.Map.reject(map, fun) == Map.reject(map, fun)
        assert ExUp.Map.__reject__(map, fun) == Map.reject(map, fun)
      end
    else
      test "works as Map.reject/2" do
        map = %{a: 1, b: 2}
        fun = fn {_k, v} -> v > 1 end
        assert ExUp.Map.reject(map, fun) == %{a: 1}
      end
    end
  end
end
