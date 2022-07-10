module tesm

import ops

import os
import strings

pub fn compile(filename string) {

	if !filename.ends_with('.tesm') {
		eprintln('tetrvm can only compile .tesm files.')
		exit(1)
	}

	file := os.read_file(filename) or {
		eprintln('failed to open `$filename`.')
		exit(1)
	}.replace('\r\n', '\n')

	tokens := tokenise(file)
	verify(tokens)
	output(tokens)
}

[heap]
struct Tokeniser {
mut:
	idx int
	row int = 1
	col int = 1
	tokens []Token
}

[heap]
struct Token {
	kind Kind
	row  int
	col  int
	value int // there are no strings in tasm
}

enum Kind {
	value
	push
	pop
	peek
	dup
	swap
	add
	sub
	put
	puts
	mul
	div
	neg
	jump
	stop
	jnz
	eq
	eqi
	lab
	get
	set
}

// match all different instructions
fn tokenise(file_content string) []Token {
	mut tok := Tokeniser{}
	mut file := file_content
	for tok.idx < file_content.len {

		file = file_content[tok.idx..]

		match true {
			file.starts_with('\n') {
				tok.idx++
				tok.row++
				tok.col = 1
			}
			file.starts_with(' ') {
				tok.idx++
				tok.col++
			}
			file.starts_with('lab') {
				tok.idx += 3
				tok.tokens << Token{.lab, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('jump') {
				tok.idx += 4
				tok.tokens << Token{.jump, tok.row, tok.col, 0}
				tok.col += 4
			}
			file.starts_with('peek') {
				tok.idx += 4
				tok.tokens << Token{.peek, tok.row, tok.col, 0}
				tok.col += 4
			}
			file.starts_with('dup') {
				tok.idx += 3
				tok.tokens << Token{.dup, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('swap') {
				tok.idx += 4
				tok.tokens << Token{.swap, tok.row, tok.col, 0}
				tok.col += 4
			}
			file.starts_with('add') {
				tok.idx += 3
				tok.tokens << Token{.add, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('sub') {
				tok.idx += 3
				tok.tokens << Token{.sub, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('mul') {
				tok.idx += 3
				tok.tokens << Token{.mul, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('div') {
				tok.idx += 3
				tok.tokens << Token{.div, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('neg') {
				tok.idx += 3
				tok.tokens << Token{.neg, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('jnz') {
				tok.idx += 3
				tok.tokens << Token{.jnz, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('eqi') {
				tok.idx += 3
				tok.tokens << Token{.eqi, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('eq') {
				tok.idx += 3
				tok.tokens << Token{.eq, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('push') {
				tok.idx += 4
				tok.tokens << Token{.push, tok.row, tok.col, 0}
				tok.col += 4
			}
			file.starts_with('pop') {
				tok.idx += 3
				tok.tokens << Token{.pop, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('stop') {
				tok.idx += 4
				tok.tokens << Token{.stop, tok.row, tok.col, 0}
				tok.col += 4
			}
			file.starts_with('puts') {
				tok.idx += 4
				tok.tokens << Token{.puts, tok.row, tok.col, 0}
				tok.col += 4
			}
			file.starts_with('put') {
				tok.idx += 3
				tok.tokens << Token{.put, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('get') {
				tok.idx += 3
				tok.tokens << Token{.get, tok.row, tok.col, 0}
				tok.col += 3
			}
			file.starts_with('set') {
				tok.idx += 3
				tok.tokens << Token{.set, tok.row, tok.col, 0}
				tok.col += 3
			}
			else {
				// look for number
				nr := file.all_before('\n')
				tok.tokens << Token{.value, tok.row, tok.col, nr.strip_margin().int()}
				tok.idx += nr.len
				tok.col += nr.len
			}
		}

	}

	return tok.tokens
}

// checks that all instructions that take an operand actually do
fn verify(tokens []Token) {

	mut errs := 0

	for i, token in tokens {
		match token.kind {
			.push {
				if tokens[i+1].kind != .value {
					eprintln('${token.row}:${token.col}| push takes 1 argument but got 0')
					errs++
				}
			}
			.jump {
				if tokens[i+1].kind != .value {
					eprintln('${token.row}:${token.col}| jump takes 1 argument but got 0')
					errs++
				}
			}
			.jnz {
				if tokens[i+1].kind != .value {
					eprintln('${token.row}:${token.col}| jnz takes 1 argument but none found')
					errs++
				}
			}
			.lab {
				if tokens[i+1].kind != .value {
					eprintln('${token.row}:${token.col}| lab takes 1 argument but none found')
					errs++
				}
				if tokens[i+1].value < 0 {
					eprintln('${token.row}:${token.col}| lab does not support negative labels')
					errs++
				}
			}
			.eqi {
				if tokens[i+1].kind != .value {
					eprintln('${token.row}:${token.col}| eqi takes 1 argument but none found')
					errs++
				}
			}
			.get {
				if tokens[i+1].kind != .value {
					eprintln('${token.row}:${token.col}| get takes 1 argument but none found')
					errs++
				}
			}
			.set {
				if tokens[i+1].kind != .value {
					eprintln('${token.row}:${token.col}| set takes 1 argument but none found')
					errs++
				}
			}
			else {}
		}
	}

	if tokens.last().kind != .stop {
		eprintln('${tokens.last().row}:${tokens.last().col}| program has to end with a stop statement')
		errs++
	}

	if errs > 0 {
		exit(1)
	}
}

// writes the bytes to the bytecode file
fn output(tokens []Token) {
	mut buf := strings.new_builder(10)

	for token in tokens {

		match token.kind {
			.push {
				buf.write_u8(0o00)
				buf.write_u8(0o00)
			}
			.pop {
				buf.write_u8(0o00)
				buf.write_u8(0o01)
				fill_inst(mut buf)
			}
			.peek {
				buf.write_u8(0o00)
				buf.write_u8(0o02)
				fill_inst(mut buf)
			}
			.dup {
				buf.write_u8(0o00)
				buf.write_u8(0o03)
				fill_inst(mut buf)
			}
			.swap {
				buf.write_u8(0o00)
				buf.write_u8(0o04)
				fill_inst(mut buf)
			}
			.jump {
				buf.write_u8(0o00)
				buf.write_u8(0o05)
			}
			.jnz {
				buf.write_u8(0o00)
				buf.write_u8(0o06)
			}
			.stop {
				buf.write_u8(0o00)
				buf.write_u8(0o07)
				fill_inst(mut buf)
			}
			.put {
				buf.write_u8(0o01)
				buf.write_u8(0o00)
				fill_inst(mut buf)
			}
			.puts {
				buf.write_u8(0o01)
				buf.write_u8(0o01)
				fill_inst(mut buf)
			}
			.mul {
				buf.write_u8(0o01)
				buf.write_u8(0o02)
				fill_inst(mut buf)
			}
			.div {
				buf.write_u8(0o01)
				buf.write_u8(0o03)
				fill_inst(mut buf)
			}
			.neg {
				buf.write_u8(0o01)
				buf.write_u8(0o04)
				fill_inst(mut buf)
			}
			.add {
				buf.write_u8(0o01)
				buf.write_u8(0o05)
				fill_inst(mut buf)
			}
			.sub {
				buf.write_u8(0o01)
				buf.write_u8(0o06)
				fill_inst(mut buf)
			}
			.eq {
				buf.write_u8(0o01)
				buf.write_u8(0o07)
				fill_inst(mut buf)
			}
			.eqi {
				buf.write_u8(0o02)
				buf.write_u8(0o00)
			}
			.lab {
				buf.write_u8(0o02)
				buf.write_u8(0o01)
			}
			.get {
				buf.write_u8(0o02)
				buf.write_u8(0o02)
			}
			.set {
				buf.write_u8(0o02)
				buf.write_u8(0o03)
			}
			.value { buf.write(ops.int_to_u8_arr(token.value)) or { continue } }
			// else {
			// 	eprintln('unsupported operation: `$token.kind`. please report this on github')
			// 	exit(1)
			// }
		}

	}	

	os.write_file('out.tet', buf.str()) or {
		eprintln('failed to output your binary')
		exit(1)
	}

	buf.clear()
}

fn fill_inst(mut buf strings.Builder) {
	buf.write([]u8{len:8}) or {}
}