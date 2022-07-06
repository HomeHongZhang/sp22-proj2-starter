.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================

# int dot(int * a0, int * a1, int a2, int a3, int a4)
# {
#	int sum = 0;												// s0 -> sum
#	if (a2 < 1) exit(36);
#	if (a3 < 1 || a4 < 1) exit(37);								
#
#	for (int i = 0, j = 0; i < a2 && j < a2; i+=a3, j+=a4)		// t0 -> i, t1 -> j
#	{
#		sum += a0[i] * a1[j];									// s1 -> a0[i], s2 -> a1[j]
#	}
#
#	return sum;
# }


dot:
	li t0, 1
	blt a2, t0, exit_36
	blt a3, t0, exit_37
	blt a4, t0, exit_37

	# Prologue
	addi sp, sp, -12
	sw s0, 0(sp)						# s0 -> sum
	sw s1, 4(sp)
	sw s2, 8(sp)

	add s0, zero, zero					# sum = 0

	li t0, 0							# i = 0
	li t1, 0							# j = 0

	li t6, 4							# width of the element
	mul a3, a3, t6						# width of the every move
	mul a4, a4, t6
loop_start:

	bge t0, a2, loop_end				# if (i >= a2)
	bge t1, a2, loop_end				# if (j >= a2)

	mul t2, t0, a3						# get the offset
	mul t3, t1, a4

	add t4, a0, t2						# get the address 
	add t5, a1, t3					

	lw s1, 0(t4)						# s1 = a0[i]
	lw s2, 0(t5)						# s2 = a1[j]
	mul s1, s1, s2						# s1 *= s2
	add s0, s0, s1						# sum += s1

	addi t0, t0, 1
	addi t1, t1, 1
	j loop_start

loop_end:
	mv a0, s0

	# Epilogue
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	addi sp, sp, 12	

	ret

exit_36:
	mv a1, a0
	li a0, 36
	ecall
	j exit

exit_37:
	mv a1, a0
	li a0, 37
	ecall
	j exit

exit:
