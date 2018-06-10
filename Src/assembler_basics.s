.syntax unified
.cpu cortex-m7
.fpu softvfp
.thumb

.global Test_Progs

.section .text.test_progs
Test_Progs:



//Calculate the sum of natural numbers up to and including 5
	MOV R0, #1
	MOV R1, #0
Loop_Sum_N:
	ADDS R1, R1, R0
	ADD R0, R0, #1
	CMP R0, #5
	BLE Loop_Sum_N

	B Default_Handler

.size Test_Progs, .-Test_Progs
