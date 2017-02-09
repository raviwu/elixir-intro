prefix = fn origin_str -> fn second_str -> "#{origin_str} #{second_str}" end end

prefix_mrs = prefix.("Mrs")

IO.puts prefix_mrs.("Smith")
IO.puts prefix.("Elixir").("Rocks")