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

Enum.map([1, 2, 3, 4], &(&1 + 2)) #=> [3, 4, 5, 6]
Enum.map([1, 2, 3, 4], &(IO.inspect(&1)))
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

```elixir
defmodule Times do
  def double(n), do: n * 2
  
  def triple(n), do: n * 3

  def quadruple(n), do: double(n * 2)
end
```

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
# mm/broken-factorial.exs
defmodule Factorial do
  def of(n), do: n * of(n - 1)
  def of(0), do: 1
end
```

> One more thing: when you have multiple implementations of the same function, they should be adjacent in the source file.

Other examples for the simple recursion implementation:

```
# mm/sum.exs
defmodule Sum do
  def from(1), do: 1
  def from(n), do: n + from(n - 1)
end
```

```
# mm/greatest_common_divisor.exs
defmodule GeatestCommonDivisor do
  def gcd(x, 0), do: x
  def gcd(x, y), do: gcd(y, rem(x, y))
end
```

## Guard Clauses

If we need to dintinguish based on parameter's types or on some test involving their values, use *guard clauses* by using `when` keyword that attaching predicates to a function. Elixir first check the conventional parameter-based matching and evaluates any `when` predicates, the block only executed when at least one predicate is true.

```
# mm/guard.exs
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

```elixir
# mm/chop.exs
defmodule Chop do
  def guess(number, first..last), do: guess_number(number, first..last, get_current_number(first..last))

  def guess_number(number, _, current_number) when current_number == number do
    IO.puts "#{number}"
  end

  def guess_number(number, first..last, current_number) when current_number > number do
    IO.puts "It is #{current_number}"
    guess_number(number, first..current_number, get_current_number(first..current_number))
  end

  def guess_number(number, first..last, current_number) when current_number < number do
    IO.puts "It is #{current_number}"
    guess_number(number, current_number..last, get_current_number(current_number..last))
  end

  def get_current_number(first..last) do: div(last - first, 2) + first
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
# mm/import.exs
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

```elixir
# sum without an accumulator
defmodule MyList do
  def sum([]), do: 0
  def sum([ head | tail ]), do: head + sum(tail)
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

### Exercises

```elixir
# mapsum(list, func)
defmodule MyList do
  def mapsum([], _), do: 0
  def mapsum([ head | tail ], func), do: func.(head) + mapsum(tail, func)
end
```

```elixir
# max(list)
defmodule MyList do
  def max([ head | [] ]), do: head
  def max([ head | tail ]) do
    [second | remain_tail] = tail
    max([_max(head, second) | remain_tail])
  end
  
  defp _max(a, b) when a >= b, do: a
  defp _max(a, b) when a < b, do: b
end
```

```elixir
# caesar(list, n)
defmodule MyList do
  def caesar([], _), do: []
  def caesar([ head | tail ], n), do: [_encrypt(head, n) | caesar(tail, n)]
  
  # A: 65 Z: 90 a: 97 z: 122
  def _encrypt(char, n) when (char >= 65) and (char <= 90), do: rem(char + n - 65, 26) + 65
  def _encrypt(char, n) when (char >= 97) and (char <= 122), do: rem(char + n - 97, 26) + 97
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

```elixir
defmodule MyList do
  def span(from, to) when from == to, do: [from]
  def span(from, to) when from < to, do: [from | span(from + 1, to)]
  def span(from, to) when from > to, do: [from | span(from - 1, to)]
end
```
