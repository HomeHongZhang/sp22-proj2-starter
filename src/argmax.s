.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================

# int argmax(int *a0, int a1)
# {
#	if (a1 < 1) return 36;
#	int max = a0[0];					//max -> s0
#
#	int idx = 0;						// idx ->t0
#	for (int i = 1; i < a1; i++)		// i -> t1
#	{
#		if (max < a0[i])
#		{
#			max = a0[i];
#			idx = i;
#		}
#	}
#
#	return idx;
# }


argmax:
	ebreak
	# Prologue
	li t0, 1
	blt a1, t0, exit			# if (a1 < 1)

	addi sp, sp, -12
	sw s0, 0(sp)				# s0 -> max
	sw s1, 4(sp)				# s1 -> a0[i]
	sw ra, 8(sp)

	add t0, zero, zero			# idx = 0
    lw s0, 0(a0)				# s0 = a0[0]
	addi t1, zero, 1			# i = 1


loop_start:
	bge t1, a1, loop_end		# if (i >= a1)
	slli t2, t1, 2				# get the offset 	

	add t3, a0, t2				# get the address of a0[i]
	lw s1, 0(t3)				# s1 = a0[i]
	blt s0, s1, loop_continue

	addi t1, t1, 1				# i++
	
	j loop_start


loop_continue:
	mv s0, s1					# max = a0[i]
	mv t0, t1 					# idx = i
	j loop_start


loop_end:
	# Epilogue
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw ra, 8(sp)
	addi sp, sp, 12

	mv a0, t0					# return idx
	ret

exit:
	mv a1, a0					# exit(36)
	li a0, 36
	ecall