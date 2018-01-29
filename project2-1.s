#Daniel Bertak
#September 31, 2017
#Computer Organization

.data

	greatest: 	.asciiz "\nThe greatest common divisor of n1 and n2 is "
	least:		.asciiz "\nThe least common multiple of n1 and n2 is "
	newline:	.asciiz "\n"

	errorMessage: 	.asciiz "\nYour input must be between 0 and 255"
	errorMessage1: 	.asciiz "\nn1 and n2 cannot both be zero"

	enterFirst: 	.asciiz "\nEnter first integer n1: "
	enterSecond:	.asciiz "\nEnter second integer n2: "

	valueN1: 	.asciiz "\nThis is the value of n1: "
	valueN2: 	.asciiz "\nThis is the value of n2: "


.text

main:
	jal firstint			#Print prompt and take in user input for n1

	jal secondint			#print prompt and take in user input for n2

	jal chechIfBothEqualZero	#make sure n1 and n2 are not both zero

	li $v0,4
	la $a0, greatest		#print the third prompt: The greatest common divisor of n1 and n2 is
	syscall

	jal gcd				#call the gcd procedure
	add $s2, $v0, $zero 		#transfer the gcd return valuefrom $v0 to $s2

	li $v0,1
	move $a0, $s2			#print out $s2 which contains the value of the gcd
	syscall

	li $v0,4
	la $a0, least			#print the fourth prompt: The least common multiple of n1 and n2 is
	syscall

	jal lcm				#call the lcm procedure
	add $s2, $v0, $zero		#transfer the lcm return value from $v0  to $s2

	li $v0,1
	move $a0, $s2			#print out $s2 which contains the value of the lcm
	syscall

	#li $v0,4
	#la $a0, valueN1	#print the first prompt
	#syscall

	#add $t0, $s0, $zero
	
	#li $v0,1
	#move $a0, $s0
	#syscall

	#li $v0,4
	#la $a0, valueN2	#print the first prompt
	#syscall

	#add $t1, $s1, $zero
	
	#li $v0,1
	#move $a0, $s1
	#syscall

	li $v0, 10		#end the program
	syscall



gcd:
	bne $s1, $zero, gcdRecursion	#check if n2 is equal to zero, go to the recursion part of the program if n2 does not equal zero

	add $v0, $s0, $zero		#if n2 is equal to 0, return s1

	jr $ra				#return to top of main

gcdRecursion:
	addi $sp, $sp, -12		#move stack pointer down by 3 spaces
	sw   $ra, 8($sp)		#save the return address on the stack
	sw   $s0, 4($sp)		#save n1 on the stack
	sw   $s1, 0($sp)		#save n2 on the stack

	add $t0, $s0, $zero		#$t0 is now equal to n1
	add $t1, $s1, $zero		#$t1 is now equal to n2	
	
	add $s0, $t1, $zero		#n2 is now in the place of n1 
	div  $t0, $t1			#do the division operation
	mfhi $s1			#s1 now holds the remainder 
	jal gcd				#This now recursively calls the gcd procedure

	lw  $s1, 0($sp)			#load n2 back from the stack
	lw  $s0, 4($sp)			#load n1 back from the stack
	lw  $ra, 8($sp)			#load the return address to go back to main from the stack
	addi $sp, $sp, 12		#move stack pointer to top of stack

	jr $ra				#return 

lcm: 

	addi $sp, $sp, -12		#move stack pointer down by 3 spaces
	sw   $ra, 8($sp)		#save the return address on the stack
	sw   $s0, 4($sp)		#save n1 on the stack
	sw   $s1, 0($sp)		#save n2 on the stack

	jal gcd

	lw  $s1, 0($sp)			#load n2 back from the stack
	lw  $s0, 4($sp)			#load n1 back from the stack
	lw  $ra, 8($sp)			#load the return address to go back to main from the stack
	addi $sp, $sp, 12		#move stack pointer to top of stack

	add $t0, $v0, $zero		#$t0 is now equal to the gcd
	div $t1, $s1, $t0		#do n2 divided by the gcd
	mul $t3, $s0, $t1		#multiply n1 by the result of the division in the above operation
	add $v0, $t3, $zero		#retun $t3 which is the result of the multiplication in the above operation

	jr $ra				#return to main

firstint:
	li $v0,4
	la $a0, enterFirst		#print the first prompt: Enter first integer n1
	syscall
	
	li $v0, 5
	syscall				#take user input for n1 and put it in $s0
	add $s0, $v0, $zero

	blt  $s0, $zero, error1		#check if n1 is less than zero, if so print an error message and jump to the top of the procedure
	
	slti $t0, $s0, 256		#$t0 = 1 if $s0 < 256, check is n1 is less than 256
	beq  $t0, $zero, error1 	#If user input is greater than 255, print error message and jump to the top of the procedure

	jr $ra				#return to main


error1: 	
	li $v0,4
	la $a0, errorMessage		#print: Your input must be between 0 and 255
	syscall
		
	j firstint			#jump to firstint

secondint:
	li $v0,4
	la $a0, enterSecond		#print the second prompt: Enter second integer n2
	syscall
	
	li $v0, 5
	syscall				#take user input for n2 and put it in $s1
	add $s1, $v0, $zero	

	blt  $s1, $zero, error2		#check if n2 is less than zero, if so print an error message and jump to the top of the procedure
	
	slti $t0, $s1, 256		#$t0 = 1 if $s0 < 256, check is n2 is less than 256
	beq  $t0, $zero, error2 	#If user input is greater than 255, print error message and jump to the top of the procedure

	jr $ra				#return to main

error2:
	li $v0,4
	la $a0, errorMessage		#print: Your input must be between 0 and 255
	syscall
		
	j secondint			#jump to secondint

chechIfBothEqualZero:
	bne $s0, $zero, resume		#Both n1 and n2 can't be zero. The input is valid if at least one of them is not zero.
	bne $s1, $zero, resume		#This makes sure that least 1 user input value which is between [0,255] is greater than 0
					#if so, then return to main, if not return to the top of main so the user can reinput n1 and n2
	li $v0,4
	la $a0, errorMessage1		#print the second prompt: n1 and n2 cannot both be zero
	syscall

	j main				#return to the top of main

resume: 

	jr $ra				#return to main




