functions_2 = fn
  ( 0, 0, _ ) -> "FizzBuzz"
  ( 0, _, _ ) -> "Fizz"
  ( _, 0, _ ) -> "Buzz"
  ( _, _, c ) -> c
end

IO.puts "FizzBuzz: #{functions_2.(0, 0, 12)}"
IO.puts "Fizz: #{functions_2.(0, 122, 12)}"
IO.puts "Buzz: #{functions_2.(12, 0, 12)}"
IO.puts "Third Args: #{functions_2.(123, 122, 12)}"

function_3 = fn n -> functions_2.(rem(n, 3), rem(n, 5), n) end

IO.puts "Start the function_3 plays: #{function_3.(10)}, #{function_3.(11)}, #{function_3.(9)}, #{function_3.(13)}, #{function_3.(14)}, #{function_3.(15)}, #{function_3.(16)}"