module vm

import os

const (
	pow_7 = 2097152
	pow_6 = 262144
	pow_5 = 32768
	pow_4 = 4096
	pow_3 = 512
	pow_2 = 64
	pow_1 = 8
	pow_0 = 1
)

const opcodes = [u8(push), pop, peek, dup, swap, add, sub, put, puts, mul, div, neg]

// values are in octal because it's easier
const (
	push = 0o00
	pop  = 0o01
	peek = 0o02
	dup  = 0o03
	swap = 0o04
	add  = 0o05
	sub  = 0o06
	put  = 0o07
	puts = 0o10
	mul  = 0o11
	div  = 0o12
	neg  = 0o13
)

pub fn (mut t Tetrvm) run(filename string) {

	if !filename.ends_with('.tet') {
		eprintln('tetrvm can only run .tet files.')
		exit(1)
	}

	file := os.read_bytes(filename) or {
		eprintln('failed to open `$filename`.')
		exit(1)
	}
	
	mut instructions := [][]u8{cap: 1, init: []u8{len: 10}}

	for idx, _ in file {
		if idx % 10 == 0 {
			instructions << file[idx..idx+10]
		}
	}

	unsafe { free(file) }

	for idx, i in instructions.reverse() {
		if i.len != 10 {
			eprintln('your program is incomplete!')
			eprintln('errored at ${instructions.len-idx}th set of 10 in $filename')
			exit(1)
		}
	}

	t.run_bytecode(instructions)

}

[inline; direct_array_access]
fn (mut t Tetrvm) run_bytecode(instructions [][]u8) {
	for i in instructions {
		opcode := (i[0] * 8) + i[1]
		value := u8_arr_to_int(i[2..10])
		
		match opcode {
			push { t.push(value) }
			pop  { t.pop() }
			peek { t.peek() }
			dup  { t.dup() }
			swap { t.swap() }
			add  { t.add() }
			sub  { t.sub() }
			put  { t.put() }
			puts { t.puts() }
			mul  { t.mul() }
			div  { t.div() }
			neg  { t.neg() }
			else {
				eprintln('bad opcode: 0o${i[0]}${i[1]}')
			}
		}
	}
}

[direct_array_access]
fn u8_arr_to_int(arr []u8) int {
	mut numr := arr[7] * pow_0 +
				arr[6] * pow_1 +
				arr[5] * pow_2 +
				arr[4] * pow_3 +
				arr[3] * pow_4 +
				arr[2] * pow_5 +
				arr[1] * pow_6 +
				arr[0] * pow_7
	if numr > pos_int_limit || numr < neg_int_limit { int_size_error() }
	return numr
}