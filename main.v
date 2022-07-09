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
	-c | compiler for tesm')
	exit(0)
}