## tetrvm
pronounced tetrum

*** 
> tetris has 7 colours and empty squares. if we assign a one digit value (0-7) to these and give up 2 of our 10 squares for instructions, we get 8^2 or 64 different possibilities. this leaves us with 8^8 different inputs so technically tetris is capable of being a 30bit computer and thus also has the potential to be turing-complete

this is why this exists. i had this idea when i woke up this morning.

tetrvm is a stack-based virtual machine capable of running tetris playfields. yes. playfields.

the maximum int size you can put in is 2^24.

the opcodes are in tet.md.

0 = empty
1 = I piece (light blue)
2 = square (yellow)
3 = T (purple)
4 = J (dark blue)
5 = L (orange)
6 = S (green)
7 = Z (red)