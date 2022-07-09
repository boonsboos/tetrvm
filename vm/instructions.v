module vm

// pushes a 24bit int to the stack
[inline; direct_array_access]
fn (mut t Tetrvm) push(i int) {
	if i > pos_int_limit || i < neg_int_limit { int_size_error() }
	t.stack << i
	t.stack_size++
}

// gets and removes the top value of the stack
[inline; direct_array_access]
fn (mut t Tetrvm) pop() int {
	if t.stack_size == 0 { t.stack_underflow() }
	t.stack_size--
	return t.stack.pop()
}

// returns the top element on the stack
[inline; direct_array_access]
fn (mut t Tetrvm) peek() int {
	if t.stack_size == 0 { t.stack_underflow() }
	return t.stack[t.stack_size]
}

[inline]
fn (mut t Tetrvm) dup() {
	t.push(t.peek())
}

// swaps the top two values on top of the stack
// a b -- b a
[inline]
fn (mut t Tetrvm) swap() {
	a := t.pop()
	b := t.pop()
	t.push(a)
	t.push(b)
}

// pushes the sum of the top two values to the top of the stack, replacing both
// a b -- (a + b)
[inline]
fn (mut t Tetrvm) add() {
	if t.stack_size == 1 { t.stack_underflow() }
	t.push(t.pop() + t.pop())
}

// pushes the subtraction of the top two values to the top of the stack, replacing both
// a b -- (a - b)
[inline]
fn (mut t Tetrvm) sub() {
	if t.stack_size == 1 { t.stack_underflow() }
	t.push(t.pop() - t.pop())
}

// prints the value of the top of the stack
[inline]
fn (mut t Tetrvm) put() {
	print(t.pop())
}

// prints the top of the stack's value in ASCII
[inline]
fn (mut t Tetrvm) puts() {
	if t.stack_size == 0 { t.stack_underflow() }
	print(u8(t.pop() % 256).ascii_str())
}

// pushes the product of the top two values to the top of the stack, replacing both
// a b -- (a * b)
[inline]
fn (mut t Tetrvm) mul() {
	if t.stack_size == 1 { t.stack_underflow() }
	t.push(t.pop() * t.pop())
}

// pushes the result of dividing the two values at the top of the stack, replacing both
// a b -- (a / b)
[inline]
fn (mut t Tetrvm) div() {
	if t.stack_size == 1 { t.stack_underflow() }
	t.push(t.pop() / t.pop())
}

// negates the value on top of the stack
[inline]
fn (mut t Tetrvm) neg() {
	if t.stack_size == 0 { t.stack_underflow() }
	t.push(-t.pop())
}

[inline]
fn (mut t Tetrvm) jump(inst int) {
	if inst < 0 {  }
	t.inst = inst
}

[inline]
fn (mut t Tetrvm) stop() {
	t.stopped = true
}