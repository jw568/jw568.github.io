.globl main
.text

main:

	addi $sp, $sp, -24 	#makes space for 24 bytes in the stack
	sw $ra, 0($sp)		#stores the return address at the current stack pointer

	li $v0, 4
	la $a0, prompt
	syscall			#prompt user

	li $v0, 5
	syscall
	move $t0, $v0	#t0 stores user input

	li $t2, 1
	slti $t1, $t0, 0	#if user input < 0, store 1 into $t1
	beq $t1, $t2, errorexit	#if $t1=1, then return with exit 

	beq $t0, 0, exit1	#if input = 0, return 2
	beq $t0, 1, exit2	#if input = 1, return 5

	sw $s0, 4($sp)		
	sw $s1, 8($sp)		#stores values of $s0-$s5
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)

	li $s0, 1
	li $s1, 2		#load values 1,2,3,5
	li $s2, 3
	li $s3, 5

	li $s4, 5		#used to store rec(n-1)
	li $s5, 2		#used to store rec(n-2)

	move $a1, $t0	#moves user input into argument register 1, $t0 is now used as a counter
loop:	
	sub $t0, $t0, $s0	#subtracts t0(counter) by 1
	beq $t0, 1, recurse #when t0 = 1, enter recurse
	j loop	
recurse:		
	li $t3, 0			#t5 holds temporary sum		
	mult $s4, $s2		#mults $s4 by 3
	mflo $t1			#stores in t1
	mult $s5, $s1		#mults $s5 by 2
	mflo $t2			#stores in t2
	move $s5, $s4		#makes $s5=$s4
	add $t3, $t3, $t1	
	add $t3, $t3, $t2	
	addi $t3, $t3, 1	#adds 1 to result
	move $s4, $t3		#makes $s4=$t5 (new recurse total)
	addi $t0, $t0, 1	#increment counter by 1
	beq $t0, $a1, done	#when counter = user argument, done
	j recurse
done: 
	li $v0, 1
	move $a0, $s4
	syscall
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)		#loads $s0-$s5 back before we return
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 24
	jr $ra
exit1: 			#if original input is 0
	li $t0, 2

	li $v0, 1
	move $a0, $t0
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 24
	jr $ra
exit2:			#if original input is 1
	li $t0, 5

	li $v0, 1
	move $a0, $t0
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 24
	jr $ra
errorexit:
	li $v0, 4
	la $a0, error
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 24
	jr $ra


.data
error: .asciiz "Number is less than 0."
prompt: .asciiz "Enter a number greater than 0:"