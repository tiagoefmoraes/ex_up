# ExUp

ExUp allows your project to use **features of new Elixir versions**, even **when the project can't be updated** to that version (yet!). This is a form of [upward compatibility](https://en.wikipedia.org/wiki/Forward_compatibility#:~:text=upward%20compatibility).

For example, your project is using `Elixir < "1.13.0"` and needs to filter the pairs on a map. After a quick search you find out [`Map.filter/2`](https://hexdocs.pm/elixir/1.13.0/Map.html#filter/2), you use it to discover that it isn't supported in this elixir version:

> `** (UndefinedFunctionError) function Map.filter/2 is undefined or private`

Instead of implementing your own version and remembering to go back and change it after you update to `Elixir >= "1.13.0"` you can use ExUp's version:

```elixir
ExUp.Map.filter(map, fun)
```

When you update, compilation will warn that the built-in functionality can be used already and the project can drop the usage of ExUp on this case.

> `**warning**: ExUp.Map.filter/2 is deprecated. Use Map.filter/2 directly, as we're already on 1.13.0`

## Installation

Add it to your dependencies:

```elixir
# mix.exs
def deps do
  [
    {:ex_up, "~> 0.1.0"},
  ]
end
```

## Documentation

Check the [documentation](https://hexdocs.pm/ex_up) to known what is already upwards compatible.

As the documentation is generated in newer Elixir versions all functionality will be marked as deprecated.

## Caveats

- Although the implementations on ExUp will give the same results as the original version, they are not intended to be an exact copy of Elixir's code. So runtime differences may be present like performance issues.
- Some functionality are easier to replicate than other. ExUp may not be a good fit for the harder ones. Lets use this energy to really update Elixir on the projects.

## Contributing

Contributions are welcome.

Running the Elixir tests:

```bash
mix deps.get
mix test
```

The macro `ExUp.defup/5` can be used to generate code and documentation to handle Elixir versions.

```elixir
defmodule ExUp.Map do
  @moduledoc since: "0.1.0"
  import ExUp
  @doc since: "0.1.0"
  defup "1.13.0", Map, :filter, [map, fun] do
    for pair <- map, fun.(pair), into: %{}, do: pair
  end
end
```

In current Elixir versions we should test that the "upwarded" versions behaves like the original one.

```elixir
defmodule ExUp.MapTest do
  use ExUnit.Case, async: true
  describe "filter/2" do
    if Version.match?(System.version(), ">= 1.13.0") do
      test "works as Map.filter/2" do
        # ...
        assert ExUp.Map.filter(map, fun) == Map.filter(map, fun)
      end
    end
  end
end
```
