a = 2
[a, b, a] = [1, 2, 3]
#=> ** (MatchError) no match of right hand side value: [1, 2, 3]

a = 2
[a, b, a] = [1, 1, 2]
#=> ** (MatchError) no match of right hand side value: [1, 1, 2]

a = 2
a = 1
a
#=> 1

a = 2
^a = 2
#=> 2

a = 2
^a = 1
#=> ** (MatchError) no match of right hand side value: 1

a = 2
^a = 2 - a
#=> ** (MatchError) no match of right hand side value: 0