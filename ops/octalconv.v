module ops

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


// converts a number from split up octal to an int
[direct_array_access]
pub fn u8_arr_to_int(arr []u8) int {
	return  arr[0] * pow_0 +
			arr[1] * pow_1 +
			arr[2] * pow_2 +
			arr[3] * pow_3 +
			arr[4] * pow_4 +
			arr[5] * pow_5 +
			arr[6] * pow_6 +
			arr[7] * pow_7
}

// converts a number from int to split up octal
[direct_array_access]
pub fn int_to_u8_arr(n int) []u8 {
	mut nr := n
	mut arr := []u8{len: 8}
	
	for i, _ in arr {
		di := nr / 8
		mo := nr % 8
		arr[7-i] = u8(mo)
		nr = di
	}

	return arr.reverse()
}