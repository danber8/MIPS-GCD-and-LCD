# MIPS-GCD-and-LCD

Transform the following code into MIPS instructions. 

Basic Problem: 

Given two integers, write a program to find the Greatest Common Divisor (GCD) and Least Common Multiple (LCM) of them. Your assembly implementation should follow the pseudo code sequence given below. Please do not perform any optimization at pseudo code level or at assembly level. 

Input validation: 

The input numbers need be in range [0, 255]. Besides, both inputs cannot bezero at the same time since GCD(0,0) is undefined. So, you should verify the input numbers are valid.

Tips: 

For printing to/reading from console, you should first load correct value to register $v0, and then call “syscall” method. If there is an input, the value would be returned in $v0.

