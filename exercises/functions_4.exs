prefix = fn (pre) -> fn (name) -> "#{pre} #{name}" end end

mrs = prefix.("Mrs")
mrs.("Ravi")
#=> "Mrs Ravi"

prefix.("Elixir").("Rocks")
#=> "Elixir Rocks"