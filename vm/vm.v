module vm

const pos_int_limit = 8388608 * 2
const neg_int_limit = -8388607 + -8388608

[heap]
pub struct Tetrvm {
mut:
	stack       []int
	stack_size  int
	inst        int
	stopped     bool
	print_stack bool
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
fn (mut t Tetrvm) bad_inst(bad int) {
	eprintln('bad jump to $bad')
	exit(1)
}

pub fn (mut vm Tetrvm) take_args(args []string) {
	

	match args[0] {
		'-c' {
			// if args.len < 2 {}
			// tesm.compile(args[1])
		}
		'-v' { vm.print_stack = true }
		else { vm.run(args[0]) }
	}

	if args[1].ends_with('.tet') {
		vm.run(args[1])
	}

}