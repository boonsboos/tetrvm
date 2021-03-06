module vm

import tesm
import visualiser

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
fn (mut t Tetrvm) stack_underflow(inst_type string) {
	eprintln('stack underflow at $t.inst | instruction type: $inst_type')
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

	mut in_file := ''
	mut out_name := 'out'
	mut compile := false
	mut visualise := false
	mut show_timings := false

	for i, arg in args {
		match arg {
			'-c' {
				if name := args[i+1] { in_file = name }
				compile = true
			}
			'-o' {
				if name := args[i+1] { out_name = name }
			}
			'-t' { show_timings = true }
			'-v' { vm.print_stack = true }
			'-p' {
				if name := args[i+1] { in_file = name }
				visualise = true
			}
			else { }
		}
	}

	if compile {
		tesm.compile(in_file, out_name, show_timings)
	} else if visualise {
		visualiser.visualise(in_file)
	} else {
		vm.run(args[0])
	}

}