nested = %{
  buttercup: %{
    actor: %{
      first: "Robin",
      last: "Wright"
    },
    role: "princess"
  },
  westley: %{
    actor: %{
      first: "Cary",
      last: "Ewles" # typo!
    },
    role: "farm boy"
  }
}

IO.inspect get_in(nested, [:butturcup])
#=> %{actor: %{first: "Robin", last: "Wright"}, role: "princess"}

IO.inspect get_in(nested, [:butturcup, :actor])
#=> %{first: "Robin", last: "Wright"}

IO.inspect get_in(nested, [:butturcup, :actor, :first])
#=> "Robin"

IO.inspect put_in(nested, [:westley, :actor, :last], "Elwes")
#=> %{buttercup: %{actor: %{first: "Robin", last: "Wright"}, role: "princess"}, westly: %{actor: %{first: "Cary", last: "Elwes"}, role: "farm boy"}}

# If you pass function as key, that function is invoded to return the corresponded values

programmers = [
  %{ name: "DHH", language: "Rails" },
  %{ name: "Matz", language: "Ruby" },
  %{ name: "Larry", language: "Perl" }
]

languages_within_an_r = fn (:get, collection, next_fn) ->
  for row <- collection do
    if String.contains?(row.language, "r") do
      next_fn.(row) # pickup the matched row and call 'next_fu' to that row
    end
  end
end

IO.inspect get_in(programmers, [languages_within_an_r, :name])
#=> [nil, nil, "Larry"]

IO.inspect get_in(programmers, [languages_within_an_r, :language])
#=> [nil, nil, "Perl"]