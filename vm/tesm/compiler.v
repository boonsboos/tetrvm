module tesm

import ops

import os
import strings
import time

pub fn compile(filename string, outfile string, show_timings bool) {

	mut sw := time.new_stopwatch()

	mut durations := []time.Duration{len: 3}

	if !filename.ends_with('.tesm') {
		eprintln('tetrvm can only compile .tesm files.')
		exit(1)
	}

	file := os.read_file(filename) or {
		eprintln('failed to open `$filename`.')
		exit(1)
	}.replace('\r\n', '\n')

	sw.start()
	tokens := tokenise(file) // get all instructions and operands
	sw.pause()
	durations[0] = sw.elapsed()

	sw.restart()
	verify(tokens) // verify that all instructions that should have an operand have one
	sw.pause()
	durations[1] = sw.elapsed()

	sw.restart()
	output(tokens, outfile) // generate the bytecode
	sw.pause()
	durations[2] = sw.elapsed()

	if show_timings {
		print_timings(durations)
	}
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
	read
}

// match all different instructions
fn tokenise(file_content string) []Token {
	mut tok := Tokeniser{}
	mut file := file_content
	mut tok_errs := 0
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
			// comments
			file.starts_with(';') {
				com_len := file.all_before('\n').len
				tok.idx += com_len
				tok.col += com_len
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
			file.starts_with('read') {
				tok.idx += 4
				tok.tokens << Token{.read, tok.row, tok.col, 0}
				tok.col += 4
			}
			else {
				// look for number
				nr := file.all_before('\n')
				if nr.int() == 0 && nr.replace(' ', '') != '0' && !nr.contains(';') {
					eprintln('$tok.row:$tok.col| unrecognized instruction `${nr}`')
					tok_errs++
				}

				tok.tokens << Token{.value, tok.row, tok.col, nr.replace(' ', '').int()}
				tok.idx += nr.len
				tok.col += nr.len
			}
		}

	}

	if tok_errs > 0 {
		exit(1)
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
					eprintln('${token.row}:${token.col}| lab does not need an argument, but for readability\'s sake please give one')
					errs++
				}
				if tokens[i+1].value < 0 {
					eprintln('${token.row}:${token.col}| the first lab is always 0.')
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
fn output(tokens []Token, outfile string) {
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
			.read {
				buf.write_u8(0o02)
				buf.write_u8(0o04)
				fill_inst(mut buf)
			}
			.value { buf.write(ops.int_to_u8_arr(token.value)) or { continue } }
			// else {
			// 	eprintln('unsupported operation: `$token.kind`. please report this on github')
			// 	exit(1)
			// }
		}

	}	

	os.write_file(outfile + '.tet', buf.str()) or {
		eprintln('failed to output your binary')
		exit(1)
	}

	buf.clear()
}

fn fill_inst(mut buf strings.Builder) {
	buf.write([]u8{len:8}) or {}
}

fn print_timings(durations []time.Duration) {
	tokenisation := durations[0].microseconds()
	verification := durations[1].microseconds()
	generation   := durations[2].microseconds()
	println('timings:\n\tTokenisation: ${tokenisation}us\n\tVerification: ${verification}us\n\tGeneration:   ${generation}us')
}