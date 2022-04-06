defmodule ExUp.Map do
  @moduledoc """
  Upward compatibility to `Map`
  """
  @moduledoc since: "0.1.0"
  import ExUp

  @doc since: "0.1.0"
  defup "1.13.0", Map, :filter, [map, fun] do
    for pair <- map, fun.(pair), into: %{}, do: pair
  end

  @doc since: "0.1.0"
  defup "1.13.0", Map, :reject, [map, fun] do
    for pair <- map, !fun.(pair), into: %{} do
      pair
    end
  end
end
