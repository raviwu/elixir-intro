# Chapter 2 - Pattern Matching

## Simple Match operator `=`

In Elixir, the equals sign `=` is not an assignment, instead i's like an assertion. It succeeds if Elixir can find a way of making the left-hand side equal the right-hand side. Elixir calls `=` a *match* operator.

```elixir
a = 1
=> 1

1 = a
=> 1

2 = a
=> ** (MatchError) not match of right hand side value: 1
```

## Complex Matches

Elixir lists can be created using square brackets containing a comma-separated values.

```elixir
[ "Apple", "Banana", "Orange" ]
[ "milk", "soda", [ "test", 123 ] ]
```

Elixir's *pattern matching*: A pattern (left-side) is matched if the values (right-side) have the same structure and if each term in the pattern can be matched to the corresponding term in the values. A literal value in the pattern matches that exact value, and a variable in the pattern matches by taking on the corresponding value.

Values needs to be at the right side that being assigned. Variable that to-be-assigned only be on left-side.

```elixir
list = [1, 2, 3]
=> [1, 2, 3]

[a, b, c] = list
=> [1, 2, 3]

a
=> 1

b
=> 2

c
=> 3
```

## Ignoring value with `_`

Using `_` is like issuing a variable being disposal right after the matching process.

```elixir
[1, _, _] = [1, 2, 3]
=> [1, 2, 3]
```

## Variable Bind Once per Match

```elixir
[a, a] = [1, 1]
=> [1, 1]
a
=> 1

[b, b] = [1, 2]
=> ** (MatchError) no match of right hand side value: [1, 2]
```

Using `^` symbol can force Elixir to use existing value of the variable, which also works when the variable is component of the pattern.

```elixir
a = 1
=> 1

a = 2
=> 2

^a = 1
=> ** (MatchError) no match of right hand side value: 1
```

> When you write the equation x = a + 1, you are not assigning the value of a + 1 to x. Instead you’re simply asserting that the expressions x and a + 1 have the same value. If you know the value of x, you can work out the value of a, and vice versa.

# Chapter 3 - Immutability

> In Elixir, all values are immutable. The most complex nested list, the database record—these things behave just like the simplest integer. Their values are all immutable. This makes concurrency a lot less frightening.

> But what if you need to add 100 to each element in `[1,2,3]`? Elixir does it by producing a copy of the original, containing the new values. The original remains unchanged, and your operation will not affect any other code holding a reference to that original.

> This fits in nicely with the idea that programming is about transforming data. When we update `[1,2,3]`, we don’t hack it in place. Instead we transform it into something new.

## Garbage Collection in Elixir

> Most modern languages have a garbage collector, and developers have grown to be suspicious of them—they can impact performance quite badly.

> But the cool thing about Elixir is that you write your code using lots and lots of processes, and each process has its own heap. The data in your application is divvied up between these processes, so each individual heap is much, much smaller than would have been the case if all the data had been in a single heap. As a result, garbage collection runs faster. If a process terminates before its heap becomes full, all its data is discarded—no garbage collection is required.

```elixir
name = "elixir"
=> "elixir"
cap_name = String.capitalize name
=> "Elixir"
name
=> "elixir
```

The syntax of `String.capitalize(name)` helps us to remind that the return value is a new copy of string `"Elixir"` instead of the original `name` string `"elixir"`.

# Chapter 4 - Elixir Basics

## Built-in Types

- Value types:
    - Arbitrary-sized integers: can be written as decimal `1234`, hexa-decimal `0xcafe`, octal `0o765`, and binary `0b1010`, decimal numbers may contain underscores that often used to separate groups of three digits when writing large number like `1_000_000`. There's no limit on the size of integers.
    - Floating-point numbers: writtien using a decinal point, must be at least one digit before and after the decimal point.
    - Atoms: constants that represent something's name, very much like Ruby's symbol. `:"long name atom"` is a atom that has value `"long name atom"`, two atoms with same name will always compare as being equal.
    - Ranges: represented as `start..end` with integers.
    - Regular expressions: written as `~r{regexp}opts`, Elixir regular expression support is provided by PCRE which basically provides a [Perl 5-compatible](https://perlmaven.com/introduction-to-regexes-in-perl) syntax for patterns. Regular expressions is manipulated by `Regex` module like: `Regex.run ~r{[aeiou]}, "caterpillar"` => `["a"]` / `Regex.scan ~r{[aeiou]}, "caterpillar"` => `[["a"], ["e"], ["i"], ["a"]]` / `Regex.split ~r{[aeiou]}, "caterpillar"` => `["c", "t", "rp", "ll", "r"]` / `Regex.replace ~r{[aeiou]}, "caterpillar", "*"` => `"c*t*rp*ll*r"`
- System types:
    - PIDs and ports: PID is reference to local or remote process, port is reference to a resource that you'll be reading or writing. A new PID is created when spawn a new process. PID of current process is available by calling `self`.
    - References: `make_ref` function creates a globally unique reference; no other reference will be equal to it. (this book does not use references)
- Collection types: Elixir collections can hold values of any type, including other collections.
    - Tuples: A tuple is an immutable ordered collection of values, written with curly bracket like `{ 1, 2 }`. Typical tuple has 2~4 elements, more than 4 elements you need then you'll probably want to use `maps` or `structs`. It is common for functions to return a tuple where the first element is the atom `:ok` if there were no errors like `{status, file} = File.open("mix.exs")` => `{:ok, #PID<0.39.0>}`, and common idiom to use tuple match assumed success operation.
    - Lists: Although the syntax `[1, 2, 3]` looks like Array, it is not. Tuples is the closest type compares to Ruby Array in Elixir. A list is effectively a linked data structure, either be empty or consisit of a head and a tail. The head contains a value and the tail is itself a list. List are easy to traverse linearly, and expensive to access in random order. List has some operators like: `++` (concatenation), `--` (difference), `in` (membership).
        - Keyword List: Writing `[name: "Ravi", city: "Taipei", likes: "Ruby"]` will converts into a list `[{:name, "Ravi"}, {:city, "Taipei"}, {:likes, "Ruby"}]`. Elixir allows to leave off the `[]` if keyword list is the last argument in a function call. And can also leave off the brackets if keyword list appears as the last item in any context where a list of values is expected. `[1, name: 1, key: 2]` => `[1, {:name, 1}, {:key, 2}]` / `{1, name: 1, key: 2}` => `{1, [name: 1, key: 2]}`
    - Maps: a collection of key/value pairs, written like `%{ key => value, key => value }`. Key can be strings, tuples, atoms, expressions, etc. Although typically the keys in a map are same type, that isn't required to be so. If the key is an atom, can use same shortcut in keyword list. Maps allows only one entry for a particular key, whereas keyword lists allow the key to be repeated. Maps are efficient and can be used in patten matching. In general, use keyword lists for things as command-line parameters and for passing around options, and use maps when you want an associative array. Accessing the value in maps with `[]` like `a_map["key"]`, if the key is a atom, can use `a_map[:atom_key]` and `a_map.atom_key`, if there's no matching key when use dot notation will raise `KeyError`.
    - Binaries: binary literals are enclosed between `<<` and `>>`. Binaries are both important and arcane. They’re important because Elixir uses them to represent UTF strings. They’re arcane because, at least initially, you’re unlikely to use them directly.
- Dates and Times: There are two date/time types `DateTime` and `NaiveDateTime`, the naive version contains just a date and a time, `DateTime` adds the ability to associate a timezone. `~N[...]` sigil constructs `NaiveDateTime` structs. If you are using dates and times in your code, you'll want to augment these build-in types with 3rd party library like *Lau Taarnskov’s Calendar library*
    - Date type: holds a year, month, day, and a reference to the ruling calandar. `Date.new(2017, 2, 5)` => `{:ok, ~D[2017-2-5]}`
    - Time type: contains an hour, minute, second, and fractions of a second. The fraction is stored as a tuple containing microseconds and the number of significant digits. `t = Time.new(12, 34, 56)` => `{:ok, ~T[12:34:56]}`, `inpect t, structs: false` => `"{:ok, %{__struct__: Time, hour: 12, microsecond: {780000, 2}, minute: 34, second: 56}}"`
- Function types:
    - talk in next chapters

## Conventions

Elixir identifiers consist of upper- and lowercase ASCII characters, digits, and underscores. They may end with a question or an exclamation mark.

Module, record, protocol, and behavior names use CamelCase. All other identifiers use snake_case. If the first character is an underscore, Elixir doesn't report warning if the variable is unused.

Source files are written in UTF-8, but identifiers use only ASCII.

By convention, source file use two space for nesting just like Ruby. Single line comment start with `#` like Ruby as well.

## Boolean values

Very much like Ruby, Elixir has `true`, `false`, and `nil` values related to boolean operations. All three values are alias for atoms of the same name. In most contexts, any value other than `false` or `nil` is treated as `true`.

## Operators

### Comparison

```elixir
a === b # strict equalty
a !== b # strict inequalty
a == b  # value equalty
a != b  # value inequalty
a > b   # normal comparison
a >= b  # normal comparison
a < b   # normal comparison
a <= b  # normal comparison
```

The ordering comparisons in Elixir are less strict than in many languages, as you can compare values of different types. If the types are the same or are compatible (for example, `3 > 2` or `3.0 < 5`), the comparison uses natural ordering. Otherwise comparison is based on type according to this rule:

number < atom < reference < function < port < pid < tuple < map < list < binary

### Boolean

```elixir
# strict operators: expects true or false as their first argument.
a or b
a and b
not a

# relax operators: values apart from false or nil being interpreted as true
a || b
a && b
!a
```

### Arithmetic

`+` `-` `*` `/` `div` `rem`

Integer division yields a floating-point result. Use `div(a,b)` to get an integer.

`rem` is the remainder operator. It is called as a function `rem(11, 3)` => `2`. It differs from normal modulo operations in that the result will have the same sign as the function’s first argument.

### Join

```elixir
binary1 <> binary2 # concatenates two binaries
list1 ++ list2     # concatenates two lists
list1 -- list2     # removes elements of list2 from a copy of list1
```

### Inclusion

`a in enum` tests if `a` is included in enum like list, range, or map (for map, a should be a {key, value} tuple), returning boolean as result.

## Variable Scope

> Elixir is lexically scoped. The basic unit of scoping is the function body. Variables defined in a function (including its parameters) are local to that function. In addition, modules define a scope for local variables, but these are only accessible at the top level of that module, and not in functions defined in the module.

Several Elixir structures also define their own scope, like `for` and `with`.

### with Expression

> The `with` expression serves double duty. First, it allows you to define a local scope for variables: if you need a couple of temporary variables when calculating something, and don’t want those variables to leak out into the wider scope, use with. Second, it gives you some control over pattern matching failures.

```
# /etc/passwd
_installassistant:*:25:25:Install Assistant:/var/empty:/usr/bin/false
_lp:*:26:26:Printing Services:/var/spool/cups:/usr/bin/false
_postfix:*:27:27:Postfix Mail Server:/var/spool/postfix:/usr/bin/false
```

```elixir
# basic-types/with-scope.exs
content = "Now is the time"

lp = with {:ok, file}   = File.open("/etc/passwd"),
          content       = IO.read(file, :all),
          :ok           = File.close(file),
          [_, uid, gid] = Regex.run(~r{_lp:.*?:(\d+):(\d+)}, content)
     do
       "Group: #{gid}, User: #{uid}"
     end
IO.puts lp #=> Group: 26, User: 26
IO.puts content #=> Now is the time
```

The `with` expression lets us work with what are effectively temporary variables as we open the file, read its content, close it, and search for the line we want. The value of the with is the value of its `do` parameter.

The `content` within `with` scope does not affect the `content` in the outer scope.

### with and Patten Matching

`=` is simple match, if failed will raise `MatchError`. When use `<-` instead of `=` in a `with` expression, it performs a match, but returns the value that couldn't be matched.

```elixir
with [a|_] <- [1, 2, 3], do: a
=> 1

with [a|_] <- nil, do: a
=> nil
```

```elixir
# basic-types/use-nonmatch-handle.exs

result = with {:ok, file}   = File.open("/etc/passwd"),
              content       = IO.read(file, :all),
              :ok           = File.close(file),
              [_, uid, gid] <- Regex.run(~r{xxx:.*?:(\d+):(\d+)}, content)
         do
           "Group: #{gid}, User: #{uid}"
         end
IO.puts inspect(result) #=> nil
```

When we try to match the user `xxx`, `Regex.run` returns `nil`. This causes the match to fail, and the `nil` becomes the value of the `with`.

`with` is treated by Elixir as if it were a call to a function or macro, correct syntax for `with` could be written as:

```elixir
# put first argument in same line
mean = with count = Enum.count(values),
            sum   = Enum.cum(values)
       do
         sum/count
       end

# use parentheses
mean = with(
         count = Enum.count(values),
         sum   = Enum.sum(values)
       do
         sum/count
       end)

# do can use shortcut like
mean = with count = Enum.count(values),
            sum   = Enum.cum(values)
       do:  sum/count
```

# Chapter 5 - Anonymous Functions

> The basis of programming is transforming data. Functions are the little engines that perform that transformation. They are at the very heart of Elixir.

An anonymous function is created using the fn keyword.

```elixir
fn​
  parameter-list -> body
  parameter-list -> body
end​
```

```elixir
sum = fn (a, b) -> a + b end
sum.(1, 2) #=> 3
```

`sum = fn (a, b) -> a + b end` assigns an anonymous function to `sum` variable, and `sum.(1, 2)` invoke the function with argument `1` and `2`. Noted that we don't use a dot for named function calls.

If functions takes no arguments, still need parentheses to call it

```elixir
greet = fn -> IO.puts "Hello" end
greet.() #=> Hello
```

Parentheses can be omitted in function definition

```elixir
multiple = fn a, b -> a * b end
miltiple.(4, 5) #=> 20

nintynine = fn -> 99 end
nintynine.() #=> 99
```

## One Function, Multiple Bodies

A single function definition lets you define different implementations depending on the type and contents of the arguments passed by pattern matching.

```elixir
handle_open = fn
  {:ok, file} -> "Read data: #{IO.read(file, :line)}"
  {_, error}  -> "Error: #{:file.format_error(error)}"
  end

handle_open.(File.open("nonexistent")) #=> "Error: no such file or directory"
```

We can use `elixir handle_open.exs` to run the source file. For files we want to compile and use later, will employ the `.ex` extension.

### Functions that returns function

```elixir
fun1 = fn -> fn -> "Hello" end end

fun2 = fn ->
  fn ->
    "Hello"
  end
end

fun1.().() #=> "Hello"
fun2.().() #=> "Hello"
```

### Functions remember their original environment

```elixir
greeter = fn name -> (fn -> "Hello, #{name}" end) end
greeter.("Joe").() #=> "Hello, Joe"

ravi_greeter = greeter.("Ravi")
ravi_greeter.() #=> "Hello, Ravi"
```

> Elixir automatically carry with them the bindings of variables in the scope in which they are defined. In our example, the variable `name` is bound in the scope of the outer function. When the inner function is defined, it inherits this scope and carries the binding of `name` around with it. This is a *closure* - the scope encloses the bindings of its variables, packaging them into something that can be saved and used later.

```elixir
add_n = fn n -> fn other -> n + other end end
add_two = add_n.(2)
add_five = add_n.(5)

add_two.(3) #=> 5
add_five.(7) #=> 12
```

### Passing function as argument

```elixir
times_2 = fn n -> n * 2 end

apply = fn (function, value) -> function.(value) end

apply.(times_2, 23) #=> 46
```

> The build-in `Enum` module has a function called `map`. It takes two arguments: a collection and a function. It returns a list that is the result of applying that function to each element of the collection.

```elixir
list = [1, 3, 5, 7, 9]

Enum.map(list, fn ele -> ele * 2 end) #=> [2, 6, 10, 14, 18]
Enum.map(list, fn ele -> ele * ele end) #=> [1, 9, 25, 49, 81]

Enum.map(list, fn ele -> rem(ele, 2) == 0) #=> [false, false, false, false, false]

is_odd? = fn ele -> rem(ele, 2) === 0 end
Enum.map(list, fn ele -> is_odd?.(ele) end) #=> [false, false, false, false, false]
```

### Pinned values and function parameters

The pin operator `^` allows us to use the current value of a variable in a pattern.

In below example, `Greeter.for` function returns a function with two heads. The first head matches when its first parameter is the value of the name passed to `for`.

```elixir
defmodule Greeter do
  def for(name, greeting) do
    fn
      (^name) -> "#{greeting} #{name}"
      (_) -> "I don't know you"
    end
  end
end

ms_ravi = Greeter.for("Ravi", "Ola!")

IO.puts ms_ravi.("Ravi") #=> "Ola! Ravi"
IO.puts ms_ravi.("Liwei") #=> "I don't know you"
```

### The `&` notation for shor helper functions

> The `&` operator converts the expression that follows into a function. Inside that expression, the placeholders `&1`, `&2`, and so on correspond to the first, second, and subsequent parameters of the function.

```elixir
add_one = &(&1 + 1) # same as add_one = fn n -> n + 1 end

square = &(&1 * &1) # same as square = fn n -> n * n end
```

> Because `[]` and `{}` are operators in Elixir, literal lists and tuples can also be turned into functions.

```elixir
divrem = &{ div(&1, &2), rem(&1, &2) }

divrem.(13, 5) #=> {2, 3}
```

> There’s a second form of the `&` function capture operator. You can give it the name and arity (number of parameters) of an existing function, and it will return an anonymous function that calls it. The arguments you pass to the anonymous function will in turn be passed to the named function.

```elixir
l = &length/1

l.([1, 2, 3, 4]) #=> 4

p = &IO.puts/1
p.("Hello, world") #=> "Hello, world"

m = &Kernel.min/2
m.(101, 99) #=> 99
```

Use `&` to shorcut passing function to other functions:

```elixir
Enum.map([1, 2, 3, 4, 5], &(&1 + 1)) #=> [2, 3, 4, 5, 6]
Enum.map([1, 2, 3, 4, 5], &(&1 * &1)) #=> [1, 4, 9, 16, 25] 
Enum.map([1, 2, 3, 4, 5], &(&1 < 3)) #=> [true, true, false, false, false]
```

# Chapter 6 - Modules and Named Functions

When the project goes bigger, you can organize the code by breaking lines into named functions and organize these functions into modules.

```elixir
# mm/times.exs
defmodule Times do
  def double(n) do
    n * 2
  end
end
```

You can then compile the `mm/times.exs` within *iex* with `c "mm/times.exs"`:

```elixir
c "mm/times.exs"
=> [Times]

Times.double(6)
=> 12

Times.double("dog")
=> ** (ArithmeticError) bad argument in arithmetic expression
=> mm/times.exs:3: Times.double/1
```

> In Elixir a named function is identified by both its name and its number of parameters (its arity). Our `double` function takes one parameter, so Elixir knows it as `double/1`. If we had another version of `double` that took three parameters, it would be known as `double/3`. These two functions are totally separate as far as Elixir is concerned. But from a human perspective, you’d imagine that if two functions have the same name they are somehow related, even if they have a different number of parameters. For that reason, don’t use the same name for two functions that do unrelated things.

## The function's Body is a Block

The `do..end` block is one way of grouping expressions and passing them to other code, however, `do..end` is just syntax sugar. The actual syntax looks like this: `def double(n), do: n * 2`

You can passing multiple lines to `do:` by grouping them with parenthesis:

```elixir
def greet(greeting, name), do: (
  IO.puts greeting
  IO.puts "How are you doing, #{name}?"
)
```

Typically people use `do..end` for multiple lines, `do: ..` for single line block.

## Function Calls and Pattern Matching

In anonymous function we write the pattern by clause, in named functions, we write the function multiple times, each time with its own parameter list and body. When calling a named function, Elixir tries to match the arguments with the parameter list of the first definition, if it is not matched, Elixir tries the next definition of same function, it continues until it runs out of candidates.

```elixir
defmodule Factorial do
  def of(0), do: 1
  def of(n), do: n * of(n - 1)
end
```

Above implementation is a simple recursion version of `n!`, the desired result is like `3! = 3 * 2 * 1`.

And the function works like this:

```elixir
Factorial.of(3)
# keep recursing with the second matched clause
=> (3 * Factorial.of(2))
=> (3 * (2 * Factorial.of(1)))
=> (3 * (2 * (1 * Factorial.of(0))))
# until the Factorial.of(0) match the first pattern
=> (3 * (2 * (1 * 1)))
```

The order of pattern is important, Elixir match the pattern from top to down, so below order won't work:

```elixir
defmodule Factorial do
  def of(n), do: n * of(n - 1)
  def of(0), do: 1
end
```

> One more thing: when you have multiple implementations of the same function, they should be adjacent in the source file.

## Guard Clauses

If we need to dintinguish based on parameter's types or on some test involving their values, use *guard clauses* by using `when` keyword that attaching predicates to a function. Elixir first check the conventional parameter-based matching and evaluates any `when` predicates, the block only executed when at least one predicate is true.

```
# examples/guard.exs
defmodule Guard do
  def what_is(x) when is_number(x), do: IO.puts "#{x} is a number"
  def what_is(x) when is_list(x), do: IO.puts "#{inspect(x)} is a list"
  def what_is(x) when is_atom(x), do: IO.puts "#{x} is an atom"
end
```

### Guard-Clause Limitations

- Comparison operators: `==`, `!=`, `===`, `!==`, `<`, `>`, `<=`, `>=`
- Boolean and hegation operators: `or`, `and`, `not`, `!` (Note that `||` and `&&` is not allowed!)
- Arithmetic operators: `+`, `-`, `*`, `/`
- Join operators: `<>`, `++` as long as the left side is a literal
- The `in` operator
- Type-check functions: `is_atom`, `is_binary`, `is_bitstring`, `is_boolean`, `is_exception`, `is_float`, `is_function`, `is_integer`, `is_list`, `is_map`, `is_number`, `is_pid`, `is_port`, `is_record`, `is_reference`, `is_tuple`
- Other functions: `abs(number)`, `bit_size(bitstring)`, `byte_size(bitstring)`, `div(number, number)`, `elem(tuple, n)`, `float(term)`, `hd(list)`, `length(list)`, `node()`, `node(pid|ref|port)`, `rem(number, number)`, `round(number)`, `self()`, `tl(list)`, `trunc(number)`, `tuple_size(tuple)`

More functions, check out [docs](http://erlang.org/doc/man/erlang.html#is_atom-1)

## Default parameters

Similar to the Ruby `def function_name(argument = "default_value"); end` feature, Elixit use `param \\ value` syntax like `def func(arg1, arg2 \\ "default_value"), do: IO.inspect [arg1, arg2]`.

### Common default parameters mis-usages

```elixir
defmodule DefaultParams1 do
  def func(p1, p2 \\ 2, p3 \\ 3), do: IO.inspect [p1, p2, p3]
  def func(p1, p2), do: IO.inspect [p1, p2]
end

# Will get compile Error:
# => ** (CompileError) default_params.exs:7: def func/2 conflicts with
#    defaults from def func/4
```

```elixir
# Need to add a function head with no body that contains the
# default paramters if you have multiple clause for same function
defmodule DefaultParams2 do
  def func(p1, p2 \\ 2)
  def func(p1, p2) when is_list(p1), do: "You said #{p2} with a list"
  def func(p1, p2), do: "You passed in #{p1} and #{p2}"
end
```

## Private Functions

The `defp` defines a private function, which can only be called within the module that declares it.

Definition of multiple head should be same, they should all be public or private functio. Below code is not valid:

```elixir
def fun(a) when is_list(a), do: true
defp fun(a), do: false
```

## The Pipe Operator: `|>`

```elixir
# Although we can write
people = DB.find_customers
orders = Orders.for_customers(people)
tax    = sales_tax(orders, 2016)
filing = prepare_filing(tax)

# Elixir has better way with |>
filing = DB.find_customers
           |> Orders.for_customers
           |> sales_tax(2016)
           |> prepare_filing
```

The `|>` takes the result of the expression to its left and inserts it as the first parameter of the function invocation to its right.

`val |> f(a, b)` is basically the same as calling `f(val, a, b)`.

> Let me repeat that—you should always use parentheses around function parameters in pipelines.

## Modules

Modules provide namespaces for things you define. If you want to reference a function defined in a module from outside that module, will need to prefix the reference with the module's name. Don't need to prefix module name if code references something inside the same module as itself.

Elixir programmeers use nested modules to impose structure for readability and reuse. To access a function in a nested module from the outside scope, prefix it with all the module names. To access it within the containing module, use either the fully qualified name or just the inner module name as a prefix.

```elixir
defmodule Outer do
  defmodule Inner do
    def inner_func do
    end
  end

  def outer_func do
    Inner.inner_func
  end
end

Outer.outer_func
Outer.Inner.inner_func
```

> Module nesting in Elixir is an illusion - all modules are defined at the top level. Elixir simply prepends the outer module name to the inner module name, putting a dot between the two, we can directly define a nested module.

```elixir
defmodule Mix.Tasks.Doctest do
  def run do
  end
end
```

There's no particular relationship between the modules `Mix` and `Mix.Tasks.Doctest`.

### Directives for Modules

> Elixir has three directievs working with modules, they all executed as the programe runs, the effect of all three directives is *lexically scoped*, it starts at the point the directive is encountered, and stops at the end of the enclosing scope. That means the directive in a module definition takes effect from the place you wrote it until the end of the module; a directive in a function definition runs to the end of that function.

#### `import`

`import` brings a module's functions and/or macros into current scope. For example, if you import the `flatten` function from the `List` module, you'd be able to call it in your code without having to specify the module name.

```elixir
defmodule Example do
  def func1 do
    List.flatten [1, [2, 3], 4]
  end

  def func2 do
    import List, only: [flatten: 1]
    flatten [5, [6, 7], 8]
  end
end
```

Full syntax of `import` is: `import Module [, only:|except: ]`

The optional second parameter lets you import a subset of functions or macros from the module. Write `only:` or `except:` followed by a list of `name: arity` pairs, ex: `import List, only: [ flatten: 1, duplicate: 2 ]`

#### `alias`

`alias` creates an alias for a module, like:

```elixir
defmodule Example do
  def compile_and_go(source) do
    alias My.Other.Module.Parser, as: Parser
    alias My.Other.Module.Runner, as: Runner
    source
    |> Parser.parse()
    |> Runner.execute()
  end
end
```

The `as:` parameters default to the last part of the module name, we could also write this: `alias My.Other.Module.{Parser, Runner}`

#### `require`

You `require` a module if you want to use any macros it defines.

### Module Attributes

Elixir modules each have associated metadata, each item of metadata is called an *attribute* of the module and is identified by a name. Inside a module, you can access these attributes by prefixing the name with an `@` sign. Giving an *attribute* a value by syntax: `@name value`

Giving value to attribute only works at the top level of a module, you can't set an attribute inside a function definition, only accessing attributes is allowed.

```elixir
defmodule Example do
  @author "Ravi Wu"
  def get_author do
    @author
  end
end
```

Attribute can be set multiple times.

```elixir
defmodule Example do
  @attr "one"
  def first, do: @attr
  @attr "two"
  def second, do: @attr
end

IO.puts "#{Example.second} #{Example.first}" #=> two one
```

> Module attributes are not variables in the conventional sense, use them only for configuration and metadata. (Many Elixir programmers employ them where Java or Ruby programmers might use as constants.)

### Module names in Elixir

Module names are just atoms, when you write a name starting with an uppercase letter, such as `IO`, Elixir converts it internally into an atom called `Elixir.IO`

```elixir
is_atom IO
#=> true

to_string IO
#=> "Elixir.IO"

:"Elixir.IO" === IO
#=> true
```

Hence call to a function in a module is really an atom followed by a dot followed by the function name. We can call functions like:

```elixir
IO.puts 123
#=> 123

:"Elixir.IO".puts 123
#=> 123
```

### Calling a Function in an Erlang library

Erlang conventions for names are different, variables start with an uppercase letter and atoms are simple lowercase names. For example, the Erlang module `timer` is called just `timer`, if you want to refer the `tc` function in Erlang lib `timer` in Elixir, you'd write `:timer.tc`.

### Finding Libraries

Elixir libraries:
- [Build in Libs](http://elixir-lang.org/docs.html)
- [Hex](https://hex.pm/)
- [GitHub Repo](https://github.com/search?utf8=%E2%9C%93&q=elixir)

Erlang libraries: [http://erlang.org/doc/](http://erlang.org/doc/)

# Chapter 7 - List and recursion

## Heads and Tails

We could represent the split between the head and tail using a `|`, a list may either be empty or consist of a head and a tail, the head contains a value and the tail is itself a list, recursively.

```elixir
[ 1 | [ 2 | [ 3 | [] ] ] ]
=> [1, 2, 3]

[ head | tail ] = [1, 2, 3]
=> [1, 2, 3]
head
=> 1
tail
=> [2, 3]
```

Understanding the List's recursive structure, we can now construct our own `len()` function to count the element amount in a given List:

```elixir
defmodule MyList do
  def len([]), do: 0
  def len([_head|tail]), do: 1 + len(tail)
end
```

Building a List Iterator function is straight forward under the recursive approach:

```elixir
defmodule MyList do
  def square([]), do: []
  def square([ head | tail ]), do: [ head * head | square(tail) ]
end
```

## Creating a Map Function

```elixir
defmodule MyList do
  def map([], _func), do: []
  def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]
end

MyList.map([1, 2, 3, 4, 5], fn (n) -> n*n end)
#=> [1, 4, 9, 16, 25]

MyList.map([1, 2, 3, 4, 5], &(&1 + 1))
#=> [2, 3, 4, 5, 6]
```

## Keep track of values during recursion

If there's any value that should be tracked during recursion, it's possible to achieve by passing the state in function's parameter.

```elixir
defmodule MyList do
  def sum(list), do: _sum(list, 0)
  
  defp _sum([], total), do: total
  defp _sum([ head | tail ], total), do: _sum(tail, head + total)
end
```

## Generalize the Sum Function

```elixir
defmodule MyList do
  def reduce([], value, _func) do
    value
  end
  def reduce([ head | tail ], value, func) do
    reduce(tail, func.(head, value), func)
  end
end
```

### multiple values on the left side of `|`

```elixir
[1, 2, 3 | [4, 5, 6]]
#=> [1, 2, 3, 4, 5, 6]

# also available on pattern matching
[a, b | tail] = [1, 2, 3 | [4, 5]]
#=> [1, 2, 3, 4, 5]
a
#=> 1
b
#=> 2
tail
#=> [3, 4, 5]
```

You can even match the pattern inside the nested list.

```elixir
defmodule WeatherHistroy do
  def for_location([], _target_loc), do: []
  def for_location([ head = [_, target_loc, _, _] | tail ], target_loc) do
    # pickup the matched head and join the list with `|` symbol
    [ head | for_location(tail, target_loc) ]
  end
  def for_location([ _ | tail ], target_loc) do
    for_location(tail, target_loc)
  end
end
```

# Chapter 8 - Maps, Keyword Lists, Sets and Structs

Data structure decision questions:

- needs to pattern match against the content, like matching dictionary has a key of `:name`?
    - use a *map*
- need to have more than one entry with same key?
    - use `Keyword` module
- need to have ordered elements?
    - use `Keyword` module
- not above situation?
    - use *map*

## Keyword List

Keyword list is typically used as options passed to function.

```elixir
defmodule Canvas do
  @defaults [ fg: "black", bg: "white", font: "Driod Sans" ]
  
  def draw_text(text, options \\ []) do
    options = Keyword.merge(@defaults, options)
    # ...
  end
end
```

For simple access on Keyword List, use `keyword_listp[key]` syntax. `Keyword` and `Enum` module are avaiable for Keyword List.

## Map

Maps are widely used in elixir, they have good performance at all sizes.

```elixir
# basic Map api
map = %{ name: "Ravi", likes: "Ruby", where: "Taiwan" }

Map.keys map
#=> [:likes, :name, :where]

Map.values map
#=> ["Ruby", "Ravi", "Taiwan"]

map[:name]
#=> "Ravi"

map.name
#=> "Ravi"

map1 = Map.drop map, [:where, :likes]
#=> %{name: "Ravi"}

map2 = Map.put map, :also_likes, "Elixir"
#=> %{also_likes: "Elixir", likes: "Ruby", name: "Ravi", where: "Taiwan"}

Map.keys map2
#=> [:also_likes, :likes, :name, :where]

Map.has_key? map1, :where
#=> false

{ value, updated_map } = Map.pop map2, :also_likes
#=> {"Elixir", %{likes: "Ruby", name: "Ravi", where: "Taiwan"}}

Map.equal? map, updated_map
#=> true
```

### Pattern Matching

```elixir
people = [
  %{ name: "Grumpy", height: 1.23 },
  %{ name: "Dave", height: 1.88 },
  %{ name: "David", height: 2.13 }
]

IO.inspect(for person = %{ height: height } <- people, height > 1.5, do: person)

#=> [%{height: 1.88, name: "Dave"}, %{height: 2.13, name: "David"}]
```

Note! Pattern Matching Can't Bind Map Keys

Pattern Matching Can Match Variable Keys

```elixir
data = %{ name: "Ravi", state: "Taiwan", likes: "Ruby" }

for key <- [ :name, :likes ] do
  %{ ^key => value } = data
  value
end

#=> ["Ravi", "Ruby"]
```

### Updating Map

`|` is the simplest way to update a map, very similar as Ruby's `Hash#merge`

```elixir
new_map = %{ old_map | key => value }
```

## Structs

Struct is a typed Map, that has a fixed set of fields and default values for those fields.

The key in Struct must be atom, and don't have `Dict` capabilities.

```elixir
defmodule Subscriber do
  defstruct name: "", paid: false, over_18: true
end

s1 = %Subscriber{name: "Ravi", paid: true}
#=> %{name: "Ravi", over_18: true, paid: true}

s1.name = "Ravi"
%Subscriber{name: a_matched_name} = s1
a_matched_name
#=> "Ravi"

s2 = %Subscriber{ s1 | name: "Ron" }
#=> %Subscriber{name: "Ron", over_18: true, paid: true}
```

Struct plays a large role when implementing polyporphism.

### Nested Dictionary structure

```elixir
defmodule Customer do
  defstruct name: "", company: ""
end

defmodule BugReport do
  defstruct owner: %Customer{}, details: "", level: 1
end
```

Accessing the attributes in nested struct by `.` operator:

```elixir
report = %BugReport{owner: %Customer{name: "Ravi", company: "LW"}, details: "broken"}

report.owner.company
#=> "LW"
```

### Dynamic (Runtime) Nested Accessors

|syntax|Macro|Function|
|------|-----|--------|
|get_in|no|(dict, keys)|
|put_in|(path, value)|(dict, keys, value)|
|update_in|(path, fn)|(dict, keys, fn)|
|get_and_update_in|(path, fn)|(dict, keys, fn)

Checkout `examples/dynamic_nested.exs` for the accessors usage.

### Access Module

The `Access` module provides functions to be used as parameters for `get` and `get_and_update_in` functions, acting as filters while traversing the structures.

The `all` and `at` only work on lists, `all` returns all elements in the list, `at` returns the nth element.

```elixir
cast = [
  %{
    character: "Buttercup",
    actor: %{
      first: "Robin",
      last: "Wright"
    },
    role: "princess"
  },
  %{
    character: "Westley",
    actor: %{
      first: "Cary",
      last: "Elwes"
    },
    role: "farm boy"
  }
]

IO.inspect get_in(cast, [Access.all(), :character])
#=> ["Buttercup", "Westley"]

IO.inspect get_in(cast, [Access.at(1), :role])
#=> "farm boy"

IO.inspect get_and_update_in(cast, [Access.all(), :actor, last], fn (val) -> {val, String.upcase(val)} end)
#=> {["Wright", "Elwes"], [%{actor: %{first: "Robin", last: "WRIGHT"}, character: "Buttercup", role: "princess"}, %{actor: %{first: "Cary", last: "ELWES"}, character: "Westley", role: "farm boy"}]}
```

While `elem` works on tuples:

```elixir
cast = [
  %{
    character: "Buttercup",
    actor: {"Robin", "Wright"},
    role: "princess"
  },
  %{
    character: "Westley",
    actor: {"Carey", "Elwes"},
    role: "farm boy"
  }
]

IO.inspect get_in(cast, [Access.all(), :actor, Access.elem(1)])
#=> ["Wright", "Elwes"]

IO.inspect get_and_update_in(cast, [Access.all(), :actor, Access.elem(1)], fn (val) -> {val, String.reverse(val)} end)
#=> {["thgirW", "sewlE"], [%{actor: {"Robin", "thgirW"}, character: "Buttercup", role: "princess"}, %{actor: {"Cary", "sewlE"}, character: "Westley", role: "farm boy"}]}
```

The `key` and `key!` work on dictionary types (maps and structs):

```elixir
cast = %{
  buttercup: %{
    actor: {"Robin", "Wright"},
    role: "princess"
  },
  westley: %{
    actor: {"Carey", "Elwes"},
    role: "farm boy"
  }
}

IO.inspect get_in(cast, [Access.key(:westley), :actor, Access.elem(1)])
#=> "Elwes"

IO.inspect get_and_update_in(cast, [Access.key(:buttercup), :role], fn (val) -> {val, "Queen"} end)
#=> {"princess", %{buttercup: %{actor: {"Robin", "Wright"}, role: "Queen"}, westley: %{actor: {"Carey", "Elwes"}, role: "farm boy"}}}
```

`Access.pop` removes the entry with a given key from a map or keyword list. It returns a tuple containing the value associated with the key and the updated container. `nil` is returned if the `key` not found in container.

```elixir
Access.pop(%{name: "Elixir", creator: "Valim"}, :name)
#=> {"Elixir", %{creator: "Valim"}}

Access.pop([name: "Elixir", creator: "Valim"], :name)
#=> {"Elixir", [creator: "Valim"]}

Access.pop(%{name: "Elixir", creator: "Valim"}, :year)
#=> {nil, %{creator: "Valim", name: "Elixir"}}
```

## Sets

Sets are implemented with module `MapSet`

```elixir
set1 = 1..5 |> Enum.into(MapSet.new)
#=> #MapSet<[1, 2, 3, 4, 5]>

set2 = 3..8 |> Enum.into(MapSet.new)
#=> #MapSet<[3, 4, 5, 6, 7, 8]>

MapSet.member? set1, 3
#=> true

MapSet.union set1, set2
#=> #MapSet<[1, 2, 3, 4, 5, 6, 7, 8]>

MapSet.difference set1, set2
#=> #MapSet<[1, 2]>

MapSet.difference set2, set1
#=> #MapSet<[6, 7, 8]>

MapSet.intersection set1, set2
#=> #MapSet<[3, 4, 5]>
```

# Chapter 9 - What are Types

> The primitive data types are not necessarily the same as the types they can represent.

> There’s a difference between the primitive list and the functionality of the `List` module. The primitive list is an implementation, whereas the `List` module adds a layer of abstraction. Both implement types, but the type is different. Primitive lists, for example, don’t have a `flatten` function.

> The `Keyword` type is an Elixir module, which is implemented as a list of tuples:

```elixir
options = [{:width, 72}, {:style, "light"}, {:style, "print"}]
```

The `Keyword` is actually a list, hence gaining all functions available from `List` module, plus Elixir adds functionality to give dictionary-like behavior on the `Keyword` List.

```elixir
options = [width: 72, style: "light", style: "print"]

List.last options
#=> {:style, "print"}

Keyword.get_values options, :style
#=> ["light", "print"]
```

The `Keyword` module doesn't have underlying primitive data type.

From above explainations, the APIs for collections in Elixir are broad.

# Chapter 10 - Enum and Stream

Elixir comes with many types that act as collections. List, Map, Range, file, and even function can also act as collections. You can also define your own collection via protocols.

Collections all share the `Enumerable` behavior. Elixir provides two modules that have a bunch of iteration functions: `Enum` and `Stream`. `Enum` will be heavily used, `Stream` provides lazy iteration which is less often used compares to `Enum`.

## Enum - common used APIs

Convert collection into list:

```elixir
list = Enum.to_list 1..5
#=> [1, 2, 3, 4, 5]
```

Concatenate collections:

```elixir
Enum.concat([1, 2], [3, 4])
#=> [1, 2, 3, 4]

Enum.concat([1, 2, 3], 'abc')
#=> [1, 2, 3, 97, 98, 99]
```

Create collections mapped with original elements:

```elixir
Enum.map([1, 2, 3], &(^1 * 10))
#=> [10, 20, 30]

Enum.map([1, 2, 3], &String.duplicate("*", &1))
#=> ["*", "**", "***"]
```

Select elements by position or criteria:

```elixir
Enum.at(0..5, 3)
#=> 3

Enum.at(0..5, 10)
#=> nil

Enum.at(0..5, 10, :nothing_there)
#=> :nothing_there

Enum.filter([1, 2, 3], &(&1 > 2))
#=> [3]

require Integer

Enum.filter([1, 2, 3, 4, 5], &Integer.is_even/1)
#=> [2, 4]

Enum.reject([1, 2, 3, 4, 5], &Integer.is_even/1)
#=> [1, 3, 5]
```

Sort and compare elements:

```elixir
Enum.sort ["there", "was", "a", "small", "cat"]
#=> ["a", "cat", "small", "there", "was"]

Enum.sort ["there", "was", "a", "small", "cat"], &(String.length(&1) <= String.length(&2))
#=> ["a", "was", "cat", "there", "small"]
# important to use `<=` and not just `<` if yuo want the sort to be stable

Enum.max ["there", "was", "a", "small", "cat"]
#=> "was"

Enum.max_by ["there", "was", "a", "small", "cat"], &String.length/1
#=> "there"
```

Split a collection:

```elixir
Enum.take([1, 2, 3, 4, 5], 3)
#=> [1, 2, 3]

Enum.take_every [1, 2, 3, 4, 5], 2
#=> [1, 3, 5]

Enum.take_while([1, 2, 3, 4, 5], &(&1 < 4))
#=> [1, 2, 3]

Enum.split([0, 1, 2, 3, 4, 5], 2)
#=> {[0, 1], [2, 3, 4, 5]}

Enum.split_while([0, 1, 2, 3, 4, 5], &(&1 < 4))
#=> {[0, 1, 2, 3], [4, 5]}
```

Join collection:

```elixir
Enum.join [1, 2, 3]
#=> "123"

Enum.join [1, 2, 3], ", "
#=> "1, 2, 3"
```

Predicate operations:

```elixir
Enum.all?([1, 2, 3, 4, 5], &(&1 < 4))
#=> false

Enum.any?([1, 2, 3, 4, 5], &(&1 < 4))
#=> true

Enum.member?([1, 2, 3], 1)
#=> true

Enum.empty?([1, 2, 3])
#=> false

Enum.empty?(%{})
#=> true
```

Merge collections:

```elixir
Enum.zip([1, 2, 3, 4, 5], [:a, :b, :c])
#=> [{1, :a}, {2, :b}, {3, :c}]

Enum.with_index(["once", "upon", "a", "time"])
#=> Enum.with_index(["once", "upon", "a", "time"])
```

Fold elements into single value:

```elixir
Enum.reduce(1..100, &(&1+&2))
#=> 5050

Enum.reduce(["now", "is", "the", "time"], fn word, longest ->
  if String.length(word) > String.length(longest) do
    word
  else
    longest
  end
end)
#=> "time"

Enum.reduce(["now", "is", "the", "time"], 0, fn word, longest ->
  if String.length(word) > longest,
  do: String.length(word),
  else: longest
end)
#=> 4
```

Deal a hand of cards:

```elixir
import Enum

deck = for rank <- '23456789TJQKA', suit <- 'CDHS', do: [suit, rank]

length deck
#=> 52

deck |> shuffle |> take(13)
#=> ['D8', 'C5', 'D5', 'SK', 'D3', 'C4', 'DQ', 'S7', 'H5', 'CQ', 'DA', 'HK', 'C9']

hands = deck |> shuffle |> chunk(13)
[['HA', 'C5', 'H8', 'S3', 'C3', 'C2', 'SQ', 'C4', 'D2', 'H9', 'D9', 'DT', 'H5'],
 ['D7', 'CA', 'SJ', 'CK', 'D5', 'DK', 'CT', 'C7', 'D3', 'S6', 'H4', 'S9', 'ST'],
 ['C9', 'D8', 'D4', 'D6', 'HJ', 'S7', 'DA', 'HT', 'H3', 'SK', 'C8', 'S5', 'S8'],
 ['CQ', 'DQ', 'S4', 'DJ', 'H7', 'CJ', 'H6', 'HK', 'C6', 'HQ', 'H2', 'S2', 'SA']]
```

## Streams - Lazy Enumerables

`Enum` module is greedy, it consumes all the content of provided collection. Which means the result will typically be another collection.

```elixir
[1, 2, 3, 4, 5]
|> Enum.map(&(&1*&1))
|> Enum.with_index
|> Enum.map(fn {value, index} -> value - index end)
|> IO.inspect
#=> [1, 3, 7, 13, 21]
```

Above pipeline generates four lists on its way to outputting the final result.

But what we really want is to process the elements in the collection as we need them, don't need to store intermediate results as full collections. Stream does this by pass the current element from function to function.

```elixir
s = Stream.map [1, 3, 5, 7], &(&1 + 1)
#=> #Stream<[enum: [1, 3, 5, 7], funs: [#Function<47.36862645/1 in Stream.map/2>]]>

Enum.to_list s
#=> [2, 4, 6, 8]
```

`Stream` is enumerable, you can pass a stream to a stream function, hence streams are *composable*.

```elixir
squares = Stream.map [1, 2, 3, 4], &(&1*&1)
plus_ones = Stream.map squares, &(&1+1)
odds = Stream.map plus_ones, fn x -> rem(x, 2) == 1 end

Enum.to_list odds
#=> [5, 17]

# Rewrite this in pipeline style:
[1, 2, 3, 4]
|> Stream.map(&(&1*&1))
|> Stream.map(&(&1+1))
|> Stream.filter(fn x -> rem(x,2) == 1 end)
|> Enum.to_list
```

Streams aren't just for lists, there are more Elixir modules support streams.

```elixir
IO.puts File.open!("/usr/share/dict/words")
        |> IO.stream(:line)
        |> Enum.mas_by(&String.length/1)

# IO.stream converts an IO device (opened file) into
# a stream that serves one line at a time.

# Shortcut written with:
IO.puts File.stream!("/usr/share/dict/words")
|> Enum.max_by(&String.length/1)
```

Pro: there is no intermeiate storage.

Con: it runs about two times slower than the Enum version.

Consider that the data was read from external server or sensor, successive lines might arrive slowly, and might go on forever.

With `Enum` implementation we'd have to wait for all lines arrived before starting processing, with `Stream` we can process them as they arrive.

```elixir
Enum.map(1..10_000_000, &(&1+1))
|> Enum.take(5)
#=> [2, 3, 4, 5, 6]
# Enum will create 10_000_000 long list before
# taking 5 out from them, this tooks about 8 secs

Stream.map(1..10_000_000, &(&1+1))
|> Enum.take(5)
#=> [2, 3, 4, 5, 6]
# Stream result coms back instantaneously, the
# take call needs fine values, one the take call
# has five from Stream, there's no more processing.
```

### `Stream.cycle`

`Stream.cycle` takes an enumerable and returns an infinite stream containing that enumerable's elements. When it gets to the end, it repeats from the beginning, indefinitely.

```elixir
Stream.cycle(~w{ green white }) |>
Stream.zip(1..5) |>
Enum.map(fn {class, value} -> ~s{<tr class="#{class}"><td>#{value}</td></tr>\n} end) |>
IO.puts
```

### `Stream.repeatedly`

`Stream.repeatedly` takes a function and invokes it each time a new value is wanted.

```elixir
Stream.repeatedly(fn -> true end) |>
Enum.take(3)
#=> [true, true, true]

Stream.repeatedly(&:random.uniform/0) |>
Enum.take(3)
#=> [0.4435846174457203, 0.7230402056221108, 0.94581636451987]
```

### `Stream.iterate`

`Stream.iterate(start_value, next_fun)` generates an infinite stream. The first value is `start_value`, the next value is generated by applying `next_fun` to this value.

```elixir
Stream.iterate(0, &(&1+1)) |>
Enum.take(5)
#=> [0, 1, 2, 3, 4]

Stream.iterate(2, &(&1*&1)) |>
Enum.take(5)
#=> [2, 4, 16, 256, 65536]

Stream.iterate([], &[&1]) |>
Enum.take(5)
#=> [[], [[]], [[[]]], [[[[]]]], [[[[[]]]]]]
```

### `Stream.unfold`

`Stream.unfold` is related to `Stream.iterate`, but with ability to be more specific to the values output to the stream and the values passed to the next iteration. Provide initial value and function, function return a tuple `{returned_value, next_value_pass_to_func}`.

`unfold` is a general way of creating a potentially infinite stream of value where each value is some function of the previous state.

The key is the generating function, its general form is:

```elixir
fn state -> { stream_value, new_state } end
```

Example of Fibonacci numbers:

```elixir
Stream.unfold({0, 1}, fn {f1, f2} -> {f1, {f2, f1+f2}} end) |> Enum.take(15)
#=> [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377]
```

### `Stream.resource`

`Stream.resource` builds upon `Stream.unfold` with two changes:

1. The first argument to `unfold` is initial value, but the `resource` take a function that returns the initial value as first argument.
2. After the `resource` is done, we may need to close it, hence `resource` requires third argument. The third argument of `Stream.resource` takes the final accumulator value and does whatever is needed to deallocate the resource.

```elixir
Stream.resource(
  fn -> File.open!("sample") end,
  fn file ->
    case IO.read(file, :line) do
      data when is_binary(data) -> {[data], file}
      _ -> {:halt, file}
    end
  end,
  fn file -> File.close(file) end)
```

> Lazy streams let you deal with resources that are asynchronous to your code, and the fact that they are initialized every time they are used means they’re effectively side-effect-free. Every time we pipe our stream to an Enum function, we get a fresh set of values, computed at that time.

> Not every situation where you are iterating requires a stream. But consider using a stream when you want to defer processing until you need the data, and when you need to deal with large numbers of things without necessarily generating them all at once.

## Collectable Protocol

> The `Enumerable` protocol lets you iterate over the elements in a type—given a collection, you can get the elements. `Collectable` is in some sense the opposite—it allows you to build a collection by inserting elements into it.

> Not all collections are collectable. Ranges, for example, cannot have new entries added to them.

```elixir
Enum.into 1..5, []
#=> [1, 2, 3, 4, 5]

Enum.into 1..5, [11, 12]
#=> [11, 12, 1, 2, 3, 4, 5]

Enum.into IO.stream(:stdio, :line), IO.stream(:stdio, :line)
```

## Comprehensions

> The idea of a comprehension is fairly simple: given one or more collections, extract all combinations of values from each, optionally filter the values, and then generate a new collection using the values that remain.

General comprehensions syntax:

```elixir
result = for generator or filter...[, into: value], do: expression
```

```elixir
for x <- [1, 2, 3, 4, 5], do: x * x
#=> [1, 4, 9, 16, 25]
for x <- [1, 2, 3, 4, 5], x < 4, do: x * x
#=> [1, 4, 9]
```

A *generator* specifies how you want to extract values from collection:

```elixir
pattern <- enumerable_thing
```

Values that matched in the pattern are available in the rest of the comprehension, including the block.

If we have two generators, the operations are nested:

```elixir
for x <- [1, 2], y <- [5, 6], do: {x, y}
#=> [{1, 5}, {1, 6}, {2, 5}, {2, 6}]

min_maxes = [{1, 4}, {2, 3}, {10, 15}]
for {min, max} <- min_maxes, n <- min..max, do: n
#=> [1, 2, 3, 4, 2, 3, 10, 11, 12, 13, 14, 15]
```

A filter is a predicate, acting as a gatekeeper for the rest of the comprehension, comprehension moves on if filter return false without generate output value.

```elixir
first_8 = [1, 2, 3, 4, 5, 6, 7, 8]
for x <- first_8, y <- first_8, x >= y, rem(x*y, 10) == 0, do: {x, y}
#=> [{5, 2}, {5, 4}, {6, 5}, {8, 5}]
```

We may use the generator pattern to deconstruct data.

```elixir
reports = [dallas: :hot, minneapolis: :cold, dc: :muggy, la: :smoggy]

for { city, weather } <- reports, do { wheather, city }
#=> [hot: :dallas, cold: :minneapolis, muggy: :dc, smoggy: :la]
```

Comprehensions on bits:

```elixir
for << ch <- "hello" >>, do: ch
#=> 'hello'

for << ch <- "hello" >>, do: <<ch>>
#=> ["h", "e", "l", "l", "o"]

for << << b1::size(2), b2::size(3), b3::size(3) >> <- "hello" >>, do: "0#{b1}#{b2}#{b3}"
#=> ["0150", "0145", "0154", "0154", "0157"]
```

Scoping in comprehensions

```elixir
name = "Dave"
for name <- ["cat", "bird"], do: String.upcase(name)
#=> ["CAT", "BIRD"]
name
#=> "Dave"
```

Return type can be changed by `into:` parameter:

```elixir
for x <- ~w{ cat dog }, into: %{}, do: { x, String.upcase(x) }
#=> %{"cat" => "CAT", "dog" => "DOG"}

for x <- ~w{ cat dog }, into: Map.new, do: { x, String.upcase(x) }
#=> %{"cat" => "CAT", "dog" => "DOG"}

for x <- ~w{ cat dog }, into: %{"ant" => "ANT"}, do: { x, String.upcase(x) }
#=> %{"ant" => "ANT", "cat" => "CAT", "dog" => "DOG"}

for x <- ~w{ cat dog }, into: IO.stream(:stdio, :line), do: "<<#{x}>>\n"
```

Part of the process of learning to be effective in Elixir is working out for yourself when to use recursion and when to use enumerators. Enumerating is mostly the better choice if you can.

# Chapter 11 - String and Binaries

## Strings

Elixir has single quote and double quote string, although their internal representation is different, they share some common characteristics:

- Strings hold characters in UTF-8 encoding
- Strings may contain escape sequences like `\a` `\b` `\d` `\e` `\f` `\n` `\r` `\s` `\t` `\v` `\uhhh` `\xhhh`
- Strings allow interpolation in expressions with syntax `#{...}`
- Strings support *heredocs* (multilines) with `""` or `"""` notation

The *heredocs& notation can trim the indent that closing tag is aligning:

```elixir
iex(1)> IO.puts "start"
start
:ok
iex(2)> IO.write """
...(2)>    my
...(2)>      string
...(2)>    """
my
  string
```

## Sigils

Elixir has alternative syntax for literals like Ruby's `%w()` called *sigils*, starts with a tilde `~` and a letter, then delimeted content, with options. The delimiters can be `<...>`, `{...}`, `(...)`, `|...|`, `/.../`, `"..."`, and `'...'`.

- `~C` character list with no escaping or interpolation
- `~c` character list, escaped and interpolated like single-quote string
- `~D` *Date* in format *yyyy-mm-dd*
- `~N` native *DateTime* in format *yyyy-mm-dd hh:mm:ss[.ddd]*
- `~R` regular expression with no escaping or interpolation
- `~r` regular expression, escaped and interpolated
- `~S` string with no escaping or interpolation
- `~s` string, escaped and interpolated like double-quote string
- `~T` *Time* in format *hh:mm:ss[.ddd]*
- `~W` list of whitespace-delimited words, with no escaping or interpolation
- `~w` list of whitespace-delimited words, escaped and interpolated

The `~W` and `~w` take an optional type specifier, `a`, `c`, or `s`, which determines whether the returned element in list is *atom*, *character list*, or *string*.

! Elixir does not check the nesting of delimiters, so the sigil `~s{a{b}` returns "a{b".

## Single quote and Double quote string in Elixir

The convention name in Elixir for strings is:
- single-quote string: character list
- double-quote string: string

### character list

`'cat'` is actually `[99, 97, 116]`, iex prints out `'cat'` instead of `[99, 97, 116]` cause the element in list is printable. If you add `'cat' ++ [0]` then iex no longer treat the new list as printable and will show `[99, 97, 116, 0]` instead.

If a character list contains Erlang considers nonprintable, you'll see the list representation.

```elixir
iex> '∂x/∂y'
[8706, 120, 47, 8706, 121]
```

The notation `?c` returns the integer code for the character `c`.

## Binaries

The binary type represents a sequence of bits, its literal looks like `<<term, term, ...>>`. The simplest tem is a number from 0 to 255.

```elixir
b = <<1, 2, 3>>

byte_size b
# => 3

bit_size b
# => 34
```

Can also specify modifiers to set term's size(in bits), usually applied when working with binary formats such as media files and network packets.

```elixir
b = <<1::size(2), 1::size(3)>> # 01 001
# => <<9::size(5)>>

byte_size b
# => 1

bit_size b
# => 5
```

Terms can be integer, float, and other binary

```elixir
int = << 1 >>
# => <<1>>

float = << 2.5::float >>
# => <<64, 4, 0, 0, 0, 0, 0, 0>>

mix = << int::binary, float::binary >>
# => <<1, 64, 4, 0, 0, 0, 0, 0, 0>>
```

## Double-Quoted Strings Are Binaries

Double quoted strings are stored as a consecutive sequence of bytes in UTF-8 encoding. Two things worth of your notice:

1. UTF=8 characters can take more than a single byte to represent, the size of the binary is not necessarily the length of the string.
2. Need to learn binary syntax when dealing with double quoted strings.


The `String` module defines functions that work with double-quoted strings. Common functions you might used often:

- `at(string, offset)`: `String.at("abc", 0) #=> "a"` `String.at("abc", -1) #=> "c"`
- `capitalize(string)`: `String.capitalize("ravi") #=> "Ravi"`
- `codepoints(string)`: `String.codepoints("Ravi Wu") #=> ["R", "a", "v", "i", " ", "W", "u"]`
- `downcase(string)`: `String.downcase("RAVI") #=> "ravi"`
- `duplicate(string, n)`: `String.duplicate("Ho! ", 3) #=> "Ho! Ho! Ho! "`
- `ends_with?(string, suffix|[suffixes])`: return true if `string` ends with any of the given suffixes `String.ends_with?("string", ["elix", "stri", "ring"]) #=> true`
- `first(string)`: `String.first("abc") #=> "a"`
- `graphemes(string)`: return the graphemes in the string and is defferent from the `codepoints` function - `String.graphemes("noe\u0308l") #=> ["n", "o", "ë", "l"]` / `String.codepoints("noe\u0308l") #=> ["n", "o", "e", "̈", "l"]`
- `jaro_distance(string1, string2)`: return a float between 0 and 1 indicating the likely similarity of two strings
- `last(string)`: `String.last("abc") #=> "c"`
- `length(string)`: `String.length("abc") #=> 3`
- `myers_difference(string1, string2)`: return the list of transformations needed to covert one string to another `String.myers_difference("ravi", "island") #=> [del: "rav", eq: "i", ins: "sland"]`
- `next_codepoint(string)`: split `string` into its leading codepoint and the rest, or `nil` if `string` is empty. This may be used as the basis of an iterator.
    ```elixir
    defmodule MyString do
      def each(str, func), do: _each(String.next_codepoint(str), func)

      defp _each({codepoint, rest}, func) do
        func.(codepoint)
        _each(String.next_codepoint(rest), func)
      end
      defp _each(nil, _), do: []
    end
    ```
- `next_grapheme(string)`: same as `next_codepoint` but return graphemes (and `:no_grapheme` on completion)
- `pad_leading(string, new_length, padding \\ 32)`: return a new string, at least `new_length` long, containing `string` right-justed and padded with `padding`
- `pad_trailing(string, new_length, padding \\ " ")`: return a new string, at least `new_length` long, containing `string` left-justed and padded with `padding`
- `printable?(string)`: return true if `string` contains only printable characters
- `replace(string, pattern, replacement, options \\ [global: true, insert_replaced: nil])`: replace `pattern` with `replacement` in `string` under control of `options`. If `:global` is true, all occurrences of the pattern are replaced. If `:insert_replaced` is a number, the pattern is inserted into the replacement at that offset, if `:insert_replaced` is a list, it is inserted multiple times.
    ```elixir
    String.replace("the cat on the mat", "at", "AT")
    # => "the cAT on the mAT"
    String.replace("the cat on the mat", "at", "AT", global: false)
    # => "the cAT on the mat"
    String.replace("the cat on the mat", "at", "AT", insert_replaced: 0)
    # => "the catAT on the matAT"
    String.replace("the cat on the mat", "at", "AT", insert_replaced: [0, 2])
    # => "the catATat on the matATat"
    ```
- `reverse(string)`: `String.reverse("ravi") #=> "ivar"`
- `slice(string, offset, length)`: `String.slice("the cat on the mat", 4, 3) #=> "cat"` / `String.slice("the cat on the mat", -3, 3) #=> "mat"`
- `split(string, pattern \\ nil, options \\ [global: true])`: split `string` into substrings delimited by `pattern`. If `:global` is false, only one split is performed. `pattern` can be a string, a regex, or `nil`. If the `pattern` is nil, the string is split on whitespace.
- `starts_with(string, prefix|[prefixes])`: return true if `string` starts with any of the given prefixes
- `trim(string)`: trim leading and trailing whitespace from `string`
- `trim(string, character)`: trims leading and trailing instances of `character` from `string` - `String.trim("!!!HELP!!!", "!") #=> "HELP"`
- `trim_leading(string)`: trim leading whitespace from `string`
- `trim_leading(string, character)`: trim leading `character` from `string`
- `trim_trailing(string)`: trim trailing whitespace from `string`
- `trim_trailing(string, character)`: trim trailing `character` from `string`
- `upcaes(string)`: `String.upcase("ravi") #=> "RAVI"`
- `valid?(string)`: return true if `string` containing only valid character.

## Binaries and Pattern Matching

The parallels with list processing are clear, but the differences are using `<< head::utf8, tail::binary>>` rather than `[ head | tail ]`, and using `<<>>` rather than `[]` for terminate match.

> However, unless you’re doing a lot of work with binary file or protocol formats, the most common use of all this scary stuff is to process UTF-8 strings.

```elixir
defmodule Utf8 do
  def each(str, func) when is_binary(str), do: _each(str, func)

  defp _each(<< head::utf8, tail::binary >>, func) do
    func.(head)
    _each(tail, func)
  end
  defp _each(<<>>, _func), do: []
end

Utf8.each "dog", fn char -> IO.puts char end
#=> 100
#=> 111
#=> 103
```

# Chapter 12 - Control Flow

Elixir code tries to be declarative instead of imperative, preferring small functions and a combination of guard clauses and pattern matching of parameters replaces most of the control flows.

## `if` and `unless`

```elixir
if 1==1 do
  "true"
else
  "false"
end

unless 1==1, do: "error", else: "OK"
#=> "OK"
unless 1==2, do: "OK", else: "error"
#=> "error"
```

## `cond`

```elixir
def demo_cond(current) do
  cond do
    rem(current, 3) == 0 and rem(current, 5) == 0 -> "FizzBuzz"
    rem(current, 3) == 0 -> "Fizz"
    rem(current, 5) == 0 -> "Buzz"
    true -> current # this is a fallback default for cond
  end
end
```

## `case`

```elixir
case File.open("case.ex") do
  { :ok, file } -> IO.puts "First line: #{IO.read(file, :line)}"
  { :error, reason } -> IO.puts "Failed to open file: #{reason}"
end
```

## Raising Exception with `raise`

Elixir exceptions are intended for things that should never happen in normal operation. DB downtime or server failing to respond could be considered exceptional. Failing to open a file given from user input should not be considered exceptional.

```elixir
raise "Giving up"
#=> ** (RuntimeError) Giving up

raise RuntimeError
#=> ** (RuntimeError) runtime error

raise RuntimeError, message: "override message"
#=> ** (RuntimeError) override message
```

Elixir uses exception far less than other languages, the philosophy is that errors should propagate back up to an external supervising process.

```elixir
case File.open("config_file") do
  {:ok, file} -> process(file)
  {:error, message} -> raise "Failed to open config file: #{message}"
end

# If the exception message is not very important, can use
{:ok, file} = File.open("config_file") # will raise MatchError
process(file)
```

A better way to handle this is to use `!` version of method if available. The trailing exclamation point in the method name is Elixir convention that function will raise meaningful exception on error, something like this:

`File.open!("config_file") |> process`