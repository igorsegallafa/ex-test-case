# ExTestCase
Elixir test case extended to support data provider.

## Usage

- Add `ex_test_case.ex` file into your project (anywhere inside the `lib/` folder)
- Inside your testing module, add this code at the beginning `use ExTestCase`

### Example ###

```elixir
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
```

## Demo

![image](https://user-images.githubusercontent.com/36571229/149443492-48f5ec1a-a4c2-4d65-9816-025e0cc8db28.png)
