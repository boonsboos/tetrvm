module tvsm

import os
import regex

pub fn compile(filename string) {

	if !filename.ends_with('.tvsm') {
		eprintln('tetrvm can only compile .tvsm files.')
		exit(1)
	}

	file := os.read_file(filename) or {
		eprintln('failed to open `$filename`.')
		exit(1)
	}.replace('\r\n', '\n')

	tokenise(file)

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

fn tokenise(file_content string) {
	mut tok := Tokeniser{}
	mut file := file_content
	for tok.idx < file.len {

		file = file[tok.idx..]

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
			else {	
				mut re := regex.regex_opt('(-)?(\d)+') or {
					eprintln('internal compiler error, please report this on github!')
					exit(1)
				}
				re.flag = regex.f_nl
				
				start, end := re.find(file)
				println('else $start | $end')
				if start != -1 {
					tok.tokens << Token{.value, tok.row, tok.col, file[start..end].int()}
					tok.idx += end - 1
					tok.col += end - 1
				}
				println('did not find an int at ${file.all_before('\n')}')
				
			}
		}

	}

	println(tok.tokens)
}