defmodule Support.Original do
  @doc since: "0.1.0"
  def foo do
    :original
  end

  @doc since: "0.1.0"
  def bar(arg) do
    {:original, arg}
  end

  def baz do
    :original
  end
end
