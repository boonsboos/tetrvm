# tet

the tetrvm bytecode format

## opcodes
- 0o00: [push](#push)
- 0o01: pop
- 0o02: peek
- 0o03: dup
- 0o04: swap
- 0o05: jump
- 0o06: stop
- 0o07: put
- 0o10: puts
- 0o11: mul
- 0o12: div
- 0o13: neg
- 0o14: add
- 0o15: sub

all programs compiling to tet have to end with `stop` (0o06) (otherwise tetrvm segfaults)

### push
pushes a number to the top of the stack