module vm

import ops

// pushes a 24bit int to the stack
[inline; direct_array_access]
fn (mut t Tetrvm) push(i int) {
	if i > ops.pos_int_limit || i < ops.neg_int_limit { int_size_error() }
	t.stack << i
	t.stack_size++
}

// gets and removes the top value of the stack
[inline; direct_array_access]
fn (mut t Tetrvm) pop() int {
	if t.stack_size == 0 { t.stack_underflow('pop') }
	t.stack_size--
	return t.stack.pop()
}

// returns the top element on the stack
[inline; direct_array_access]
fn (mut t Tetrvm) peek() int {
	if t.stack_size == 0 { t.stack_underflow('peek') }
	return t.stack[t.stack_size]
}

// duplicates the top value on the stack
[inline]
fn (mut t Tetrvm) dup() {
	a := t.pop()
	t.push(a)
	t.push(a)
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
	if t.stack_size == 1 { t.stack_underflow('add') }
	t.push(t.pop() + t.pop())
}

// pushes the subtraction of the top two values to the top of the stack, replacing both
// a b -- (a - b)
[inline]
fn (mut t Tetrvm) sub() {
	if t.stack_size == 1 { t.stack_underflow('sub') }
	t.push(t.pop() - t.pop())
}

// prints the value of the top of the stack
// a -- -
[inline]
fn (mut t Tetrvm) put() {
	if t.stack_size == 0 { t.stack_underflow('put') }
	print(t.pop())
}

// prints the top of the stack's value in ASCII
// a -- -
[inline]
fn (mut t Tetrvm) puts() {
	if t.stack_size == 0 { t.stack_underflow('puts') }
	print(u8(t.pop() % 256).ascii_str())
}

// pushes the product of the top two values to the top of the stack, replacing both
// a b -- (a * b)
[inline]
fn (mut t Tetrvm) mul() {
	if t.stack_size == 1 { t.stack_underflow('mul') }
	t.push(t.pop() * t.pop())
}

// pushes the result of dividing the two values at the top of the stack, replacing both
// a b -- (a / b)
[inline]
fn (mut t Tetrvm) div() {
	if t.stack_size == 1 { t.stack_underflow('div') }
	t.push(t.pop() / t.pop())
}

// negates the value on top of the stack
// a -- (-a)
[inline]
fn (mut t Tetrvm) neg() {
	if t.stack_size == 0 { t.stack_underflow('neg') }
	t.push(-t.pop())
}

// jumps to the specified label
[inline]
fn (mut t Tetrvm) jump(inst int) {
	if _ := t.labels[inst] {
		t.inst = t.labels[inst]
	} else {
		t.bad_jump(inst)
	}
}

// jumps if the value on top of the stack is 1
// a -- -
[inline]
fn (mut t Tetrvm) jnz(inst int) {
	if t.pop() == 1 { t.jump(inst) }
}

// checks if the top two values of the stack are equal
// a b -- c
[inline]
fn (mut t Tetrvm) eq() {
	t.push(int(t.pop() == t.pop()))
}

[inline]
fn (mut t Tetrvm) eqi(value int) {
	t.push(int(t.pop() == value))
}

[inline]
fn (mut t Tetrvm) lab() {
	t.labels << t.inst
}

// pushes the (top - n)th element of the stack to the top
// a b c -- c a b c
[inline; direct_array_access]
fn (mut t Tetrvm) get(value int) {
	t.push(t.stack[t.stack_size - value])
}

// sets the (top - n)th element of the stack to the value on top
// a b c -- c b
[inline; direct_array_access]
fn (mut t Tetrvm) set(value int) {
	t.stack[t.stack_size - value] = t.pop()
}

[inline]
fn (mut t Tetrvm) read() {
	t.push(utf8_getchar())
}