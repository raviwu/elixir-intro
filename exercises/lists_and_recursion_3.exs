# caesar(list, n)
defmodule MyList do
  def caesar([], _), do: []
  def caesar([ head | tail ], n), do: [_encrypt(head, n) | caesar(tail, n)]

  def _encrypt(char, n) when (char >= ?A) and (char <= ?Z), do: rem(char + n - ?A, 26) + ?A
  def _encrypt(char, n) when (char >= ?a) and (char <= ?z), do: rem(char + n - ?a, 26) + ?a
end