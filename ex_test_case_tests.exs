defmodule ExTestCaseTests do
  use ExUnit.Case
  use ExTestCase

  @data_provider [
    [true, true],
    [30, 12]
  ]
  test "data provider using static data", input, expected do
    assert input == expected
  end

  @data_provider get_data_provider(30)
  test "data provider using a function", input, expected do
    assert input == expected
  end

  def get_data_provider(value) do
    [
      [true, true],
      [20, value],
      [1, 1]
    ]
  end
end
