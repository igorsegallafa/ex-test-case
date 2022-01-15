defmodule ExTestCase do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      Module.register_attribute(__MODULE__, :data_provider, accumulate: false)

      import Kernel, except: [@: 1]
      import unquote(__MODULE__)
    end
  end

  defmacro @({attr_name = :data_provider, _, [{fun, _, args}]}) do
    Module.put_attribute(__CALLER__.module, attr_name, [{__CALLER__.module, fun, args}])
  end
  defmacro @({attr_name = :data_provider, _, attr_value}) do
    Module.put_attribute(__CALLER__.module, attr_name, attr_value)
  end
  defmacro @value do
    quote do
      @unquote(value)
    end
  end

  defmacro test(description, _input, _expected, do: block) do
    data_provider = Module.get_attribute(__CALLER__.module, :data_provider) |> hd()
    is_function? = !is_list(data_provider)

    if is_function? do
      # Generate tests when data provider is a function in run-time
      {module, fun, args} = data_provider
      quote do
        test "#{unquote(description)} - #{unquote(fun)}(#{unquote(args) |> Enum.map(&inspect/1) |> Enum.join(", ")})" do
          data_provider = apply(unquote(module), unquote(fun), unquote(args))

          for {[input_data_provider, expected_data_provider], index} <- Enum.with_index(data_provider) do
            var!(input) = input_data_provider
            var!(expected) = expected_data_provider

            try do
              unquote(block)
            rescue
              e in ExUnit.AssertionError ->
                e = %{e | message: "#{e.message}, with data set ##{index}"}
                reraise e, __STACKTRACE__
            end
          end
        end
      end
    else
      # Generate tests when data provider is a static data in compile time
      for {[input_data_provider, expected_data_provider], index} <- Enum.with_index(data_provider) do
        quote do
          test "#{unquote(description)} - with data set ##{unquote(index)}" do
            var!(input) = unquote(input_data_provider)
            var!(expected) = unquote(expected_data_provider)

            unquote(block)
          end
        end
      end
    end
  end
end
