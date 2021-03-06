.syntax unified
.cpu cortex-m7
.fpu softvfp
.thumb

.global Test_Progs

.section .data
.word RCC_AHB1ENR
RCC_AHB1ENR = 0x40023830;

.word GPIOB_MODER
GPIOB_MODER = 0x40020400;

.word GPIOE_MODER
GPIOE_MODER = 0x40021000;

.word SYST_CSR
SYST_CSR = 0xE000E010;

.word LCD_WRITE_MODES
LCD_WRITE_MODES = 0x55554011;

.section .text.test_progs
Test_Progs:
	//MOV R0, #0x000A
	//BL Fib

	BL Arr_sort

	B Default_Handler

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

//Delay for 3 seconds
MOV R0, #3000
BL Delay

RCC_Init:
	//Enable Peripheral Clock for GPIO Port B and GPIO Port E
	//RCC_AHB1ENR - set bit 1 and 4
	LDR R1, =RCC_AHB1ENR
	LDR R2, [R1]
	ORR R2, R2, #18
	STR R2, [R1]

LCD_Init:
	//Set bits x-y in GPIOE_MODER to select output mode for PEx-PEy
	//PE0 - RS
	//PE2 - E
	//PE7 - RW
	//PE8-PE15 - DB0-DB7
	LDR R1, =GPIOE_MODER
	LDR R2, =LCD_WRITE_MODES
	STR R2, [R1]

//Turn on LED on pin PB7
LED_Init:
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
	//Leave LED on for 2 seconds
	PUSH {R1}
	MOV R0, #2000
	BL Delay

//Output "��� �����!" on the LCD screen
Hello_World:
	//Wait for initialisation
	MOV R0, #50
	BL Delay
	//BL LCD_wait

	//Set DataLine to 8 bits, Number of rows to 2 and Font to 5x8 px
	MOV R1, #0
	MOV R0, #56
	BL LCD_Write
	MOV R0, #5
	BL Delay
	MOV R1, #0
	MOV R0, #56
	BL LCD_Write
	MOV R0, #1
	BL Delay
	MOV R1, #0
	MOV R0, #56
	BL LCD_Write

	//Clear display
	MOV R1, #0
	MOV R0, #1
	BL LCD_Write
	BL LCD_wait

	//Set entry mode: increment, no shift
	MOV R1, #0
	MOV R0, #6
	BL LCD_Write
	BL LCD_wait

	//Enable cursor and cursor blinking, turn on the display
	MOV R1, #0
	MOV R0, #15
	BL LCD_Write
	BL LCD_wait

	//Set cursor position to 0;0 and set shift to 0
	MOV R1, #0
	MOV R0, #2
	BL LCD_Write

	MOV R0, #1
	BL Delay
	//BL LCD_wait		//Reading the Busy Flag increments the cursor position WTF?!?

	//Output something
	MOV R1, #1
	MOV R0, #0x5A
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #128
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x44
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #129
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x72
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #130
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x20
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #131
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x62
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #132
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x45
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #133
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x70
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #134
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x34
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #135
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x65
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #136
	BL LCD_Write
	BL LCD_wait

	MOV R1, #1
	MOV R0, #0x21
	BL LCD_Write
	BL LCD_wait

	MOV R1, #0
	MOV R0, #168
	BL LCD_Write

//Blink LED on PB7 at 1Hz
Blink:
	POP {R1}
	Blink_Loop:
		MOV R2, #1
		LSL R2, #23
		STR R2, [R1]
		PUSH {R1}
		MOV R0, #500
		BL Delay
		POP {R1}
		MOV R2, #128
		STR R2, [R1]
		PUSH {R1}
		MOV R0, #500
		BL Delay
		POP {R1}
		B Blink_Loop

B Default_Handler

//Provides delay in miliseconds indicated by R0
Delay:
	CMP R0, #0
	IT LE						//Why do I need this?
		BXLE LR
	LDR R1, =SYST_CSR
	ADD R0, R0, #1				//Ensure minimum delay
	Delay_Loop:
		LDR R2, [R1]
		ANDS R2, R2, #0x10000	//Sets N=1, Z=0 instead of N=0, Z=1
		CMP R2, #0
		IT NE					//Why do I need this?
			SUBSNE R0, R0, #1
		CMP R0, #0
		BNE Delay_Loop
	BX LR

//Write an instruction or data to the LCD
//R0 - instruction/data
//R1 - 1 for data, 0 for instruction
//Return value in R0: 0 - no errors, 1 - error
LCD_Write:
	//Return with error code if parameters are invalid
	CMP R1, #1
	ITT HI
		MOVHI R0, #1	//Invalid selection
		BXHI LR
	CMP R0, #255
	ITT HI
		MOVHI R0, #2	//Invalid instruction/data
		BXHI LR

	PUSH {LR}

	//Set R2 to the address of GPIOE_ODR
	LDR R2, =GPIOE_MODER
	ADD R2, R2, #0x14

	LSL R0, R0, #8
	ORR R0, R0, R1
	STR R0, [R2]

	//Set R2 to the address of GPIOE_BSRR
	ADD R2, R2, #0x4

	//Sets Enable bit
	MOV R3, #4
	STR R3, [R2]
	//Enable is set separately because there must be at least 40ns between setting the data/instruction bits and setting the enable bit
	//The execution time of 1 instruction @16MHz is enough to comply with the set-up time

	PUSH {R2, R3}
	MOV R0, #1
	BL Delay				//1ms is an overkill but I'm too lazy to implement a separate us delay
	POP {R2, R3}

	//Resets Enable bit
	LSL R3, R3, #16
	STR R3, [R2]

	MOV R0, #1
	BL Delay

	MOV R0, #0
	POP {PC}

//Check the busy flag and wait until it clears
LCD_wait:
	//Switch DB0-DB7 to input mode
	LDR R1, =GPIOE_MODER
	LDR R2, =0x4010
	STR R2, [R1]

	//Set R/W bit and reset all other bits
	MOV R2, #128
	STR R2, [R1, #0x14]

	PUSH {LR}

	LCD_wait_loop:
		//Sets Enable bit and waits
		MOV R3, #4
		STR R3, [R1, #0x18]
		PUSH {R1}
		MOV R0, #1
		BL Delay
		POP {R1}

		//Read busy flag
		LDR R6, [R1, #0x10]
		MOV R4, #0x8000
		AND R5, R4, R6

		//Reset Enable bit and wait
		LSL R3, R3, #16
		STR R3, [R1, #0x18]
		MOV R0, #1
		PUSH {R1}
		BL Delay
		POP {R1}

		//Check the busy flag
		CMP R5, #0
		BNE LCD_wait_loop

	//Switch DB0-DB7 to output mode
	LDR R2, =LCD_WRITE_MODES
	STR R2, [R1]

	POP {PC}

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

//Calculates the n-th fibonachi number (R0=n)
Fib:
	CMP R0, #3
	ITT LT
		MOVLT R0, #1
		BXLT LR
	PUSH {R0, LR}
	SUB R0, R0, #1
	BL Fib
	POP {R1}
	PUSH {R0}
	SUB R0, R1, #2
	BL Fib
	POP {R1}
	ADD R0, R0, R1
	POP {PC}

//Sorts the array
Arr_sort:
	LDR R0, =Arr
	MOV R1, #15				//Array lenght
	MOV R2, #0				//Counter

	Sort_Loop:
		MOV R3, #1			//Sorted flag

		Bubble_Loop:
			CMP R2, R1
			BGE Check_Flag

			LDRB R4, [R0, R2]
			ADD R2, R2, #1
			LDRB R5, [R0, R2]
			CMP R5, R4
			BGE Bubble_Loop

			STRB R4, [R0, R2]
			SUB R2, R2, #1
			STRB R5, [R0, R2]
			ADD R2, R2, #1
			MOV R3, #0
			B Bubble_Loop

		Check_Flag:
			CMP R3, #1
			IT EQ
				BXEQ LR
			SUB R1, R1, #1
			MOV R2, #0
			B Sort_Loop

.size Test_Progs, .-Test_Progs

.section .data
Arr:
.byte 0xAA, 0xF1, 0x08, 0xCD, 0x78, 0x12, 0x34, 0xAD, 0x45, 0x92, 0x32, 0x57, 0xE6, 0x4E, 0x1C
