# caesar(list, n)
defmodule MyList do
  def caesar([], _), do: []
  def caesar([ head | tail ], n), do: [_encrypt(head, n) | caesar(tail, n)]
  
  # A: 65 Z: 90 a: 97 z: 122
  def _encrypt(char, n) when (char >= 65) and (char <= 90), do: rem(char + n - 65, 26) + 65
  def _encrypt(char, n) when (char >= 97) and (char <= 122), do: rem(char + n - 97, 26) + 97
end