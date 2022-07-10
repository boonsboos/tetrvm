## tetrvm
pronounced tetrum

*** 
> tetris has 7 colours and empty squares. if we assign a one digit value (0-7) to these and give up 2 of our 10 squares for instructions, we get 8^2 or 64 different possibilities. this leaves us with 8^8 different inputs so technically tetris is capable of being a 30bit computer and thus also has the potential to be turing-complete
- boonsboos, 2022-07-09

tetrvm is a stack-based virtual machine/bytecode interpreter capable of running tetris playfields. yes. playfields.

to learn how to play around with it, check the [docs](./docs.md)

### usage
`tetrvm [mode] file.(tet|tesm)`

tetrvm has 2 modes, compilation and execution. execution mode is the default, which takes `.tet` files.

compilation mode requires passing `-c` and a `.tesm` file.

### building
tetrvm is written in V, so get the V compiler.

build tetrvm by running `v -prod -skip-unused .` in the main source directory.