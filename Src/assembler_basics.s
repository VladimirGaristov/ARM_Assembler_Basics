.syntax unified
.cpu cortex-m7
.fpu softvfp
.thumb

.global Test_Progs

.word RCC_AHB1ENR
RCC_AHB1ENR = 0x40023830;

.word GPIOB_MODER
GPIOB_MODER = 0x40020400;

.section .text.test_progs
Test_Progs:

//Turn on LED on pin PB7
LED_Test:

	//Enable Peripheral Clock for GPIO Port B
	//RCC_AHB1ENR - set bit 1
	LDR R1, = RCC_AHB1ENR
	LDR R2, [R1]
	ORR R2, R2, #2
	STR R2, [R1]

	//Set bit 14 in GPIOB_MODER to select output mode for PB7
	LDR R1, = GPIOB_MODER
	LDR R2, [R1]
	MOV R3, #16384
	ORR R2, R2, R3
	STR R2, [R1]

	//Set bit ODR7 in GPIOB_ODR to set PB7 high
	ADD R1, R1, #20
	LDR R2, [R1]
	MOV R3, #128
	ORR R2, R2, R3
	STR R2, [R1]

	B Default_Handler

//Calculate the sum of natural numbers up to and including 5
Sum_N:
	MOV R0, #1
	MOV R1, #0
	Loop_Sum_N:
		ADDS R1, R1, R0
		ADD R0, R0, #1
		CMP R0, #5
	BLE Loop_Sum_N

B Default_Handler

.size Test_Progs, .-Test_Progs
