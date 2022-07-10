module vm

import tesm

[heap]
pub struct Tetrvm {
mut:
	stack       []int
	stack_size  int // size of the stack
	inst        int // current instruction

	labels      []int

	print_stack bool // uncomment the last statement in jit.v/run_bytecode
}

[inline]
fn (mut t Tetrvm) stack_underflow() {
	eprintln('stack underflow at $t.inst')
	exit(1)
}

[inline]
fn int_size_error() {
	eprintln('int too big!')
	exit(1)
}

[inline]
fn (mut t Tetrvm) bad_jump(bad int) {
	eprintln('bad jump to $bad')
	exit(1)
}

pub fn (mut vm Tetrvm) take_args(args []string) {
	match args[0] {
		'-c' {
			if args.len < 2 {
				eprintln('you need to supply a .tesm file for compilation')
				exit(1)
			}
			tesm.compile(args[1])
		}
		'-v' { vm.print_stack = true }
		else { vm.run(args[0]) }
	}

}