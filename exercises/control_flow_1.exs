defmodule FizzBuzz do
  def upto(n) when n > 0 do
    1..n |> Enum.map(&fizzbuzz/1)
  end

  defp fizzbuzz(n) do
    case {n, rem(n, 3), rem(n, 5)} do
      {_, 0, 0} -> "FizzBuzz"
      {_, 0, _} -> "Fizz"
      {_, _, 0} -> "Buzz"
      {_, _, _} -> n
    end
  end
end
