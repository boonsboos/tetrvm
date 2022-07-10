# Docs

- [bytecode](#tet)
- [assembly](#tesm)


## tet

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
- 0o21: [lab](#lab)
- 0o22: [get](#get)
- 0o23: [set](#set)

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
jumps to the specified label. eg: `jump 0o01` jumps to label 1.

does not modify the stack

### stop
stops the current execution

### put
writes the top of the stack to the console

`a -- -`

### puts
writes the top of the stack's value in ascii to the console

`a -- -`

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

### lab
introduces a label. the value/name should be a number.

does not modify the stack.

### get
duplicates the `top - n`th element of the stack to the top

> warning: this instruction is unsafe. you can very easily crash tetrvm with it

`a b c d e -- e a b c d e`

### set
set `top - n`th element of the stack to value on top

> warning: this instruction is unsafe. you can very easily crash tetrvm with it

`a b c d e -- b c d a`

## tesm

tesm is a simple assembly dialect. it is so simple in fact, that everything is an instruction, and each instruction is a keyword.

all instructions are listed above.

an example program that prints the result of 1 + 1 to the console, would be
```
push 1
push 1
add
put
stop
```

to do labels, use the `lab` instruction, and jump to the label's value:

labels start from 0, and increment by 1 for each new label.
```
lab 0
push 1
push 1
add
put
jump 0
stop
```