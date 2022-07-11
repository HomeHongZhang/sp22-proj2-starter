.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================

#// a0 -> base address of the first array 
#// a1 -> base address of the second array
#// a2 -> the length of the two array
#// a3 -> stride of the first array
#// a4 -> stride of the second array
#int dot(int * a0, int * a1, int a2, int a3, int a4);
#
#// a0 -> base address of the first matrix
#// a1 -> the row length of the first matrix
#// a2 -> the cloumn length of the first matrix
#// a3 -> base address of the second matrix
#// a4 -> the row length of the second matrix
#// a5 -> the cloumn length of the second matrix
#// a6 -> base address of the  result matrix
#void matmul(int * a0, int a1, int a2, int * a3, int a4, int a5, int * a6)
#{
#	if (a1 < 1 || a2 < 1 || a4 < 1 || a5 < 1) exit(38);
#	if (a2 != a4) exit(38);
#	for (int i = 0; i < a1; i++)									// i -> t0
#	{
#		for (int j = 0; j < a5; j++)								// j -> t1
#		{
#			//a6[i][j] = dot(a0 + i, a3 + j, a2, 1, a2);
#			//a6  +(i*a2) + j = dot(a0 + i, a3 + j, a1, 1, a5);
#			*(a6  +(i*a2) + j) = dot(a0 + i*a2, a3 + j, a2, 1, a5);
#		}
#	}
#}


matmul:

	# Error checks
	li t0, 1
	blt a1, t0, exit
	blt a2, t0, exit
	blt a4, t0, exit
	blt a5, t0, exit
	bne a2, a4, exit

	# Prologue

	add t0, zero, zero						# i = 0
	li t4, 4
outer_loop_start:
	
	bge t0, a1, outer_loop_end				# if (i >= a1)
	
	add t1, zero, zero						# j = 0
inner_loop_start:
	
	bge t1, a5, inner_loop_end				# if (j >= a5)

	# save argument registers
	addi sp, sp, -24
	sw, ra, 0(sp)		
	sw, a0, 4(sp)			
	sw, a1, 8(sp)
	sw, a2, 12(sp)
	sw, a3, 16(sp)
	sw, a4, 20(sp)

	## set up the new argument registers
	li s0, 4
	mul s0, s0, t0
	mul s0, s0, a2 							# i * a2
	add a0, a0, s0 							# a0 + (i*a2)
	
	li s1, 4
	mul s1, s1, t1
	add a1, a3, t1							# a3 + j
	add a2, a2, zero						# a2
	li a3, 1								# 1
	add a4, a5, zero						# a5

	call dot

	add t2, s0, s1							# (a2 * i) + j
	add t3, a6, t2							# a6 + (a2 * i) + j
	sw a0, 0(t3)							# a6 + (a2 * i) + j = dot()

	# restore argument registers
	
	lw ra, 0(sp)
	lw, a0, 4(sp)
	lw, a1, 8(sp)
	lw, a2, 12(sp)
	lw, a3, 16(sp)
	lw, a4, 20(sp)
	addi sp, sp, 24	

	addi t1, t1, 1							# j++
	j inner_loop_start

inner_loop_end:

	addi t0, t0, 1							# i++
	j outer_loop_start

outer_loop_end:


	# Epilogue


	ret

exit:
	mv a1, a0
	li a0, 38
	ecall