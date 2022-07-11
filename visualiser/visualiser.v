module visualiser

import os
import strings
import term

pub fn visualise(filename string) {

	file := os.read_bytes(filename) or {
		eprintln('failed to open `$filename`')
		exit(1)
	}

	mut buf := strings.new_builder(20)

	for i, b in file {

		if i % 10 == 0 {
			buf.write_string('\n')
		}

		match b {
			0o00 { buf.write_string('  ') }
			0o01 { buf.write_string(term.bright_bg_blue('  ')) }
			0o02 { buf.write_string(term.bg_yellow('  ')) }
			0o03 { buf.write_string(term.bg_magenta('  ')) }
			0o04 { buf.write_string(term.bg_blue('  ')) }
			0o05 { buf.write_string(term.bg_rgb(201, 107, 12, '  ')) }
			0o06 { buf.write_string(term.bg_green('  ')) }
			0o07 { buf.write_string(term.bright_bg_red('  ')) }
			else {
				eprintln('your bytecode has an unsupported value. please check if it compiled correctly.')
				exit(1)
			}
		}
		
		buf.write_string(term.reset(''))

		
	}

	print(buf.str())

	buf.clear()
}