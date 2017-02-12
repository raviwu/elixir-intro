defmodule MyList do
  def span(from, to) when from == to, do: [from]
  def span(from, to) when from < to, do: [from | span(from + 1, to)]
  def span(from, to) when from > to, do: [from | span(from - 1, to)]

  def prime_to(n), do: for x <- span(1, n), is_prime?(x), do: x

  def is_prime?(1), do: true
  def is_prime?(2), do: true
  def is_prime?(n) do
    factors = for x <- span(2, n-1), rem(n, x) == 0, do: x
    Enum.empty? factors
  end
end
