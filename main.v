module main

import vm

fn main() {
	mut vm := vm.Tetrvm{}
	vm.push(69)
	vm.push(42)
	vm.add()
	println(vm.pop())
	vm.push(69)
	vm.push(42)
	vm.sub()
	println(vm.pop())
}