module vm

import ops

import os

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

	// pre-run through the program to resolve labels
	// if they're not resolved before runtime, you can't jump to labels defined after a jump
	for i in instructions {
		t.inst++ // so we use the instruction pointer
		// what it does, is add its current value to the array of label locations
		// the interpreter then changes the instruction pointer to jump

		if (i[0] * 8) + i[1] != ops.lab { continue } // gets the opcode
		t.lab()
	}

	// reset instruction pointer
	t.inst = 0

	t.run_bytecode(instructions)

}

[inline; direct_array_access]
fn (mut t Tetrvm) run_bytecode(instructions [][]u8) {
	for t.inst < instructions.len {
		i := instructions[t.inst]
		opcode := (i[0] * 8) + i[1]
		value := ops.u8_arr_to_int(i[2..10])
		
		t.inst++ // incrementing after jumping means the jumps are off by one

		match opcode {
			ops.push { t.push(value) }
			ops.pop  { t.pop() }
			ops.peek { t.peek() }
			ops.dup  { t.dup() }
			ops.swap { t.swap() }
			ops.add  { t.add() }
			ops.sub  { t.sub() }
			ops.put  { t.put() }
			ops.puts { t.puts() }
			ops.mul  { t.mul() }
			ops.div  { t.div() }
			ops.neg  { t.neg() }
			ops.jump { t.jump(value) }
			ops.stop { return }
			ops.jit  { t.jit(value) }
			ops.eq   { t.eq() }
			ops.eqi  { t.eqi(value) }
			ops.lab  { continue } // lab instructions can be ignored, we already took care
			ops.get  { t.get(value) }
			ops.set  { t.set(value) }
			ops.read { t.read() }
			ops.jgz  { t.jgz(value) }
			else {
				eprintln('bad opcode: 0o${i[0]}${i[1]} at instruction $t.inst')
				return
			}
		}
		// if t.print_stack { println(t.stack) } // only uncomment while debugging
	}	
}