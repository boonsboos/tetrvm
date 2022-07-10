# tet

the tetrvm bytecode format
***

tetrvm bytecode instructions are 10 bytes long. the maximum value this can have is 7.

the first two bytes are reserved for opcodes, the rest is for input.

if an opcode does not take input but one is given, it is ignored.

## opcodes
- 0o00: [push](#push)
- 0o01: [pop](#pop)
- 0o02: [peek](#peek)
- 0o03: [dup](#dup)
- 0o04: [swap](#swap)
- 0o05: [jump](#jump)
- 0o06: [stop](#stop)
- 0o07: [put](#put)
- 0o10: [puts](#puts)
- 0o11: [mul](#mul)
- 0o12: [div](#div)
- 0o13: [neg](#neg)
- 0o14: [add](#add)
- 0o15: [sub](#sub)
- 0o16: [jnz](#jnz)
- 0o17: [eq](#eq)
- 0o20: [eqi](#eqi)

all programs compiling to tet have to end with `stop` (0o06), otherwise tetrvm segfaults.

that is not a bug, just imperfect design.
***
### push
pushes to the top of the stack

`- -- a`

### pop
pops the top of the stack, removing it

`a -- -`

### peek
gets the top value on the stack, not useful except internally

`a -- a`

### dup
duplicates the top of the stack

`a -- a a`

### swap
swaps the top two values on the stack

`a b -- b a`

### jump
jumps to the specified instruction (not label yet)

### stop
stops the current execution

### put
writes the top of the stack to the console

`a -- -`

### puts
writes the top of the stack's value in ascii to the console

### mul
multiplies the top two values on the stack

`a b -- (b * a)`

### div
divides the top two values on the stack

`a b -- (b / a)`

### neg
makes the top of the stack negative
> note: does not act like a NOT

`a -- (-a)`

### add
adds the top two values on the stack

`a b -- (b + a)`

### sub
subtracts the top two values on the stack

`a b -- (b - a)`

### jnz
jumps if the top of the stack is not 0; if it is 1

`a -- -`

### eq
checks if the top two values on the stack are equal

this pushes either 0 or 1 to the stack

`a b -- (b == a)`

### eqi
eq with input, checks if the top value equals the input value

`a -- (i == a)`