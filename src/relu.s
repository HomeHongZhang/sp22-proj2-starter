.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================

# void relu(int * a0, int a1)
# {
# 	if (a1 < 1) exit(36);
# 	for (int i = 0; i < a1; i++)
# 	{
# 		//a0[i] = max(a0[i], 0);
# 		if (a0[i] < 0) a0[i] = 0;
# 	}
# }

relu:
	ebreak
	addi t0, zero, 1
	blt a1, t0, exit		# if (a1 < 1) 
	add t1, zero, zero		# i = 0

	# Prologue
	addi sp, sp, -8
	sw ra, 0(sp)
	sw s0, 4(sp)

	
loop_start:
	slli t2, t1, 2			# idx of the array
	bge t1, a1, loop_end	# if (i >= a1)
	addi t1, t1, 1			# i++

	add t3, a0, t2			# address of a0[i]
	lw s0, 0(t3)			# s0 = a0[i]
	blt s0, zero, loop_continue	
	j loop_start

loop_continue:
	sw, zero, 0(t3)			# a0[i] = 0
	j loop_start

loop_end:
	# Epilogue	
	lw ra, 0(sp)
	lw s0, 4(sp)
	addi sp, sp, 8

	ret

exit:
	mv a1, a0
	li a0, 36
	ecall
