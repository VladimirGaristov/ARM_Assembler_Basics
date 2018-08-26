.syntax unified
.cpu cortex-m7
.fpu softvfp
.thumb

.global Test_Progs

.word RCC_AHB1ENR
RCC_AHB1ENR = 0x40023830;

.word GPIOB_MODER
GPIOB_MODER = 0x40020400;

.word SYST_CSR
SYST_CSR = 0xE000E010;

.section .text.test_progs
Test_Progs:

//Enable the system timer and set its period to 1ms
System_Timer_Init:
	//Set bit 2 to use the system clock and set bit 0 to enable
	LDR R1, =SYST_CSR
	LDR R2, =0x5
	STR R2, [R1]

	//Set SYST_RVR to 16000 to provide 1ms delay at 16MHz
	ADD R1, R1, 0x4
	MOV R2, #0x3E80
	STR R2, [R1]

//Delay for 10 seconds
MOV R0, #3000
BL Delay

//Turn on LED on pin PB7
LED_Init:
	//Enable Peripheral Clock for GPIO Port B
	//RCC_AHB1ENR - set bit 1
	LDR R1, =RCC_AHB1ENR
	LDR R2, [R1]
	ORR R2, R2, #2
	STR R2, [R1]

	//Set bit 14 in GPIOB_MODER to select output mode for PB7
	LDR R1, =GPIOB_MODER
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

	//Increment R1 to point to GPIOB_BSRR
	ADD R1, R1, #4
	//Leave LED on for 5 seconds
	PUSH {R1}
	MOV R0, #5000
	BL Delay
	POP {R1}

//Blink LED on PB7 at 1Hz
Blink:
	MOV R2, #1
	LSL R2, #23
	STR R2, [R1]
	PUSH {R1}
	MOV R0, #500
	BL Delay
	POP {R1}
	MOV R2, #1
	LSL R2, #7
	STR R2, [R1]
	PUSH {R1}
	MOV R0, #500
	BL Delay
	POP {R1}
	B Blink

B Default_Handler

//Provides delay in miliseconds indicated by R0
Delay:
	CMP R0, #0
	IT LE						//Why do I need this?
		BXLE LR
	LDR R1, =SYST_CSR
	Delay_Loop:
		LDR R2, [R1]
		ANDS R2, R2, #0x10000	//Sets N=1, Z=0 instead of N=0, Z=1
		CMP R2, #0
		IT NE					//Why do I need this?
			SUBSNE R0, R0, #1
		CMP R0, #0
		BNE Delay_Loop
	BX LR

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
