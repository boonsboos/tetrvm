module main

import vm

import os

fn main() {
	mut vm := vm.Tetrvm{}
	// vm.push(69)
	// vm.dup()
	// vm.add()
	// println(vm.pop())
	// vm.push(69)
	// vm.push(42)
	// vm.sub()
	// println(vm.pop())

	vm.run(os.args[1])
}