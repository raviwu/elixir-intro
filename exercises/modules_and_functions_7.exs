# Convert a float to string with 2 decimal digits
:erlang.float_to_binary(1200.001, decimals: 2)

# Get value of OS ENVs
System.get_env

# Return the extension component of a file name
Path.extname("dave/test.exs")

# Return process's current working directory
System.cwd

# Convert a string containing JSON into Elixir data
# https://github.com/cblage/elixir-json

# Execute command in os shell
System.cmd "echo", ["hello"]