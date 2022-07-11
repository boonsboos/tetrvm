module main

import vm

import os

fn main() {
	mut vm := vm.Tetrvm{}
	if os.args.len < 2 { usage() }

	vm.take_args(os.args[1..])
}

fn usage() {
	println('
tetrvm [flag] <file>
a virtual machine for tetris
-------
flags:
	-c | compiler for tesm
	-t | show compiler timing statistics
	-o | set the name of the file the compiler should output
	-p | show the .tet file as playfield')
	exit(0)
}