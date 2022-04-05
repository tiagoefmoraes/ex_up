defmodule ExUp do
  @moduledoc """
  Documentation for `ExUp`.
  """

  @doc ~S"""
  Defines a function or a deprecated function that delegates to mod. Depending on the Elixir version.

  The first argument is the elixir version since this function is available.
  The `mod` argument is the original elixir module where the function is implemented.
  The `fun` argument is the original elixir function name.
  `args` is a list of arguments that the generated function will accept.
  `body` is the implementation older versions of elixir will use, it should do the same of the
  original function.

  ## Examples

      iex> defmodule Sample1 do
      ...>   import ExUp
      ...>   defup("1.0.0", List, :first, [list, default \\ nil]) do
      ...>     case list do
      ...>       [] -> default
      ...>       [first | _] -> first
      ...>     end
      ...>   end
      ...> end
      iex> Sample1.first([])
      nil
      iex> Sample1.first([1, 2])
      1
  """
  @doc since: "0.1.0"
  defmacro defup(elixir_since, mod, fun, args \\ [], do: body)
           when is_binary(elixir_since) and is_atom(fun) and is_list(args) do
    args = [args] |> List.flatten() |> Enum.map(&Macro.escape/1)
    body = Macro.escape(body, unquote: true)

    current_version_has_support? = Version.match?(System.version(), ">= #{elixir_since}")
    arity = length(args)
    module = Macro.prewalk(mod, &Macro.expand(&1, __ENV__))

    validate_function!(
      module,
      fun,
      arity,
      elixir_since,
      current_version_has_support?,
      __CALLER__.file,
      __CALLER__.line
    )

    mfa = Exception.format_mfa(module, fun, arity)
    doc = "Upwards compatibility to `#{mfa}` @ `#{elixir_since}`"
    # FIXME: auto link to correct version?
    if current_version_has_support? do
      quote bind_quoted: [
              mfa: mfa,
              doc: doc,
              fun: fun,
              args: args,
              mod: mod,
              body: body
            ] do
        if Mix.env() != :test do
          @deprecated "Use #{mfa} directly, as we're already on #{System.version()}"
        end

        @doc doc
        defdelegate unquote(fun)(unquote_splicing(args)), to: mod

        @doc false
        if Mix.env() != :test do
          @deprecated "Use #{mfa} directly, as we're already on #{System.version()}"
        end

        def unquote(String.to_atom("__#{fun}__"))(unquote_splicing(args)), do: unquote(body)
      end
    else
      quote bind_quoted: [
              doc: doc,
              fun: fun,
              args: args,
              body: body
            ] do
        @doc doc
        def unquote(fun)(unquote_splicing(args)), do: unquote(body)
      end
    end
  end

  defp validate_function!(
         module,
         fun,
         expected_arity,
         elixir_since,
         current_version_has_support?,
         caller_file,
         caller_line
       ) do
    {arity, since} = function_info(module, fun)

    if current_version_has_support? && expected_arity != arity do
      raise_undefined_function(module, fun, expected_arity, caller_file, caller_line)
    end

    if current_version_has_support? && since != nil && since != elixir_since do
      raise CompileError.exception(
              description:
                "function #{Exception.format_mfa(module, fun, arity)} is defined since '#{since}' not '#{elixir_since}'",
              file: caller_file,
              line: caller_line
            )
    end
  end

  defp function_info(module, fun) do
    case Code.fetch_docs(module) do
      {:docs_v1, _, _, _, _, _, docs} ->
        Enum.find_value(docs, nil, fn doc ->
          case doc do
            {{_, ^fun, arity}, _, _, _, docs} -> {arity, Map.get(docs, :since)}
            _ -> nil
          end
        end) || {nil, nil}
    end
  end

  defp raise_undefined_function(module, fun, expected_arity, caller_file, caller_line) do
    error = %UndefinedFunctionError{
      module: Code.ensure_loaded!(module),
      function: fun,
      arity: expected_arity
    }

    {%{message: description}, _} = UndefinedFunctionError.blame(error, nil)

    raise CompileError.exception(
            description: description,
            file: caller_file,
            line: caller_line
          )
  end
end
