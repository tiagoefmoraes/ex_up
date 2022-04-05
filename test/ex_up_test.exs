defmodule ExUpTest do
  use ExUnit.Case, async: true
  doctest ExUp

  test "defup defines `fun` delegating to original and `__fun__` executing the block, for testing purposes" do
    defmodule Test2 do
      ExUp.defup("0.1.0", Support.Original, :foo, do: :defup)
    end

    assert Test2.foo() == :original
    assert Test2.__foo__() == :defup
  end

  test "defup with args" do
    defmodule Test3 do
      ExUp.defup("0.1.0", Support.Original, :bar, [arg], do: {:defup, arg})
    end

    assert Test3.bar(123) == {:original, 123}
    assert Test3.__bar__(123) == {:defup, 123}
  end

  test "defup without since" do
    defmodule Test4 do
      ExUp.defup("0.1.0", Support.Original, :baz, [], do: :defup)
    end

    assert Test4.baz() == :original
    assert Test4.__baz__() == :defup
  end

  test "defup on future elixir version with non existing function defines only `fun` executing the block" do
    defmodule Test5 do
      ExUp.defup("999.0.0", Support.Original, :go, do: :defup)
    end

    assert Test5.go() == :defup
    refute Keyword.has_key?(Test5.__info__(:functions), :__go__)
  end

  test "defup on wrong elixir since raises error" do
    assert_raise CompileError,
                 ~r"function Support.Original.foo/0 is defined since '0.1.0' not '0.1.1'",
                 fn ->
                   defmodule Test do
                     ExUp.defup("0.1.1", Support.Original, :foo, do: nil)
                   end
                 end
  end

  test "defup on past elixir version with non existing function raises error" do
    assert_raise CompileError,
                 ~r"function Support.Original.non_existing/0 is undefined or private",
                 fn ->
                   defmodule Test do
                     ExUp.defup("0.1.0", Support.Original, :non_existing, do: nil)
                   end
                 end
  end

  test "defup on past elixir version with wrong arities raises errors" do
    assert_raise CompileError,
                 ~r"function Support.Original.foo/1 is undefined or private. Did you mean.*:\n\n      \* foo/0",
                 fn ->
                   defmodule Test do
                     ExUp.defup("0.1.0", Support.Original, :foo, [arg], do: nil)
                   end
                 end

    assert_raise CompileError,
                 ~r"function Support.Original.bar/0 is undefined or private. Did you mean.*:\n\n      \* bar/1",
                 fn ->
                   defmodule Test do
                     ExUp.defup("0.1.0", Support.Original, :bar, do: nil)
                   end
                 end
  end
end
