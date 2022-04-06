defmodule ExUp.MapTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  describe "filter/2" do
    property "works as Map.filter/2" do
      check all map <- map_of(term(), term(), max_length: 10) do
        {filter_key, filter_value} = random_key_value(map)
        fun = fn {k, v} -> k == filter_key || v == filter_value end
        assert_map_filter(map, fun)
      end
    end

    if Version.match?(System.version(), ">= 1.13.0") do
      def assert_map_filter(map, fun) do
        original_result = Map.filter(map, fun)
        assert ExUp.Map.filter(map, fun) == original_result
        assert ExUp.Map.__filter__(map, fun) == original_result
      end
    else
      def assert_map_filter(map, fun) do
        assert ExUp.Map.filter(map, fun) |> Enum.all?(fun)
      end
    end
  end

  describe "reject/2" do
    property "works as Map.reject/2" do
      check all map <- map_of(term(), term(), max_length: 10) do
        {reject_key, reject_value} = random_key_value(map)
        fun = fn {k, v} -> k == reject_key || v == reject_value end
        assert_map_reject(map, fun)
      end
    end

    if Version.match?(System.version(), ">= 1.13.0") do
      def assert_map_reject(map, fun) do
        original_result = Map.reject(map, fun)
        assert ExUp.Map.reject(map, fun) == original_result
        assert ExUp.Map.__reject__(map, fun) == original_result
      end
    else
      def assert_map_reject(map, fun) do
        refute ExUp.Map.reject(map, fun) |> Enum.any?(fun)
      end
    end
  end

  defp random_key_value(map) when map == %{}, do: {nil, nil}

  defp random_key_value(map) do
    {
      map |> Map.keys() |> Enum.random(),
      map |> Map.values() |> Enum.random()
    }
  end
end
