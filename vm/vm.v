module vm

const pos_int_limit = 8388608
const neg_int_limit = -8388607

[heap]
pub struct Tetrvm {
mut:
	stack      []int
	stack_size int
}

[inline]
fn stack_underflow() {
	eprintln('stack_underflow')
	exit(1)
}

[inline]
fn int_size_error() {
	eprintln('int too big!')
	exit(1)
}