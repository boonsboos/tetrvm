module ops

pub const pos_int_limit = 16777216
pub const neg_int_limit = -16777216

// the order they're in does not matter
pub const opcodes = [u8(push), pop, peek, dup, swap, add, sub, put, puts, mul, div, neg, jump, stop, jit, eq, eqi, lab, get, set, read, jgz]

// values are in octal because it's easier
pub const (
	push = 0o00
	pop  = 0o01
	peek = 0o02
	dup  = 0o03
	swap = 0o04
	jump = 0o05
	jit  = 0o06
	stop = 0o07
	put  = 0o10
	puts = 0o11
	mul  = 0o12
	div  = 0o13
	neg  = 0o14
	add  = 0o15
	sub  = 0o16
	eq   = 0o17
	eqi  = 0o20
	lab  = 0o21
	get  = 0o22
	set  = 0o23
	read = 0o24
	jgz  = 0o25
)