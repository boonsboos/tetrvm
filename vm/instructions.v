module vm

// pushes a 24bit int to the stack
[inline]
pub fn (mut t Tetrvm) push(i int) {
	if i > pos_int_limit || i < neg_int_limit { int_size_error() }
	t.stack << i
	t.stack_size++
}

// gets the top value of the stack
[inline]
pub fn (mut t Tetrvm) pop() int {
	if t.stack_size == 0 { stack_underflow() }
	t.stack_size--
	return t.stack.pop()
}

[inline]
pub fn (mut t Tetrvm) dup() {
	a := t.pop()
	t.push(a)
	t.push(a)
}

// a b -- b a
[inline]
pub fn (mut t Tetrvm) swap() {
	a := t.pop()
	b := t.pop()
	t.push(a)
	t.push(b)
}

// pushes the sum of the top two values to the top of the stack, replacing both
[inline]
pub fn (mut t Tetrvm) add() {
	if t.stack_size == 1 { stack_underflow() }
	t.push(t.pop() + t.pop())
}

// pushes the subtraction of the top two values to the top of the stack, replacing both
[inline]
pub fn (mut t Tetrvm) sub() {
	if t.stack_size == 1 { stack_underflow() }
	t.push(t.pop() - t.pop())
}