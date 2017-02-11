defmodule MyEnum do
  def all?(list, func), do: length(list) == length(filter(each(list, func), &(&1 == true)))

  def each([], _func), do: []
  def each([head | tail], func), do: [func.(head)|each(tail, func)]

  def filter([], _func), do: []
  def filter([head | tail], func) do
    if func.(head) do
      [head | filter(tail, func)]
    else
      filter(tail, func)
    end
  end

  def split([], _qty), do: {[], []}
  def split(list, qty) when qty == 0, do: {[], list}
  def split(list, qty) when qty >= length(list), do: {list, []}
  def split(list, qty), do: {take(list, qty), list -- take(list, qty)}

  def take([], _qty), do: []
  def take(_list, 0), do: []
  def take(list, qty) when length(list) <= qty, do: list
  def take([head | _tail], 1), do: [head]
  def take([head | tail], qty), do: [head | take(tail, qty - 1)]
end