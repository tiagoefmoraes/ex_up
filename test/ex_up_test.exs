defmodule ExUpTest do
  use ExUnit.Case
  doctest ExUp

  test "greets the world" do
    assert ExUp.hello() == :world
  end
end
