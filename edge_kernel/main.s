				PRESERVE8
                THUMB

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
__Vectors
				DCD  0x20001000     ; stack pointer value when stack is empty
				DCD  Reset_Handler  ; reset vector
				
				AREA	myCode, CODE, READONLY	
;**********************************************************************************
AHB1ENR   		EQU     0x40023830
	
GPIOA_MODER		EQU     0x40020000  ; 0x40020000 + 0x00
GPIOA_OSPEEDR	EQU     0x40020080  ; 0x40020000 + 0x80
GPIOA_PUPDR		EQU     0x4002000C  ; 0x40020000 + 0x0C	
GPIOA_IDR   	EQU     0x40020010  ; 0x40020000 + 0x10
	
GPIOB_MODER		EQU     0x40020400  ; 0x40020400 + 0x00
GPIOB_OTYPER	EQU		0x40020404  ; 0x40020400 + 0x04
GPIOB_OSPEEDR	EQU     0x40020480  ; 0x40020400 + 0x80
GPIOB_PUPDR		EQU     0x4002040C  ; 0x40020400 + 0x0C	
GPIOB_ODR  		EQU     0x40020414  ; 0x40020400 + 0x14
	
FilteredPhoto   EQU		0x20000000	; Output of kernel is Stored in SRAM Starting form Address 0x20000000
;**********************************************************************************
				ENTRY
Reset_Handler

;**********************************************************************************

			;********** Activating GPIOA, GPIOB Clock ****************************************
            MOV32   r0, #AHB1ENR     	; r0 <- GPIO Enable Clock Register Address(AHB1ENR)
			LDR		r1, [r0]			; r1 <- AHB1ENR Register Value
            MOV32   r2, #0x00000003     ; r2 <- 0b00000000000000000000000000000011
			ORR 	r1, r1, r2			; r1 <- r1 OR r2 (AHB1ENR | 0b11)
            STR     r1, [r0]            ; AHB1ENR Register <- r1
			;*********************************************************************************
			
			;********** Configuring GPIOA.PIN0 as input 2MHz Without Pullup/Pulldown *********
            MOV32   r0, #GPIOA_MODER    ; r0 <- GPIOA MODER Register Address
			LDR		r1, [r0]			; r1 <- GPIOA_MODER Register Value
            MOV32   r2, #0x00000003     ; r2 <- 0b00000000000000000000000000000011
			MVN		r2, r2;				; r2 <- ~r2
			AND 	r1, r1, r2			; r1 <- r1 AND r2 (GPIOA_MODER & ~0b11)
            STR     r1, [r0]            ; GPIOA_MODER Register <- r1
			
			MOV32   r0, #GPIOA_OSPEEDR    ; r0 <- GPIOA OSPEEDR Register Address
			LDR		r1, [r0]			; r1 <- GPIOA_OSPEEDR Register Value
            MOV32   r2, #0x00000003     ; r2 <- 0b00000000000000000000000000000011
			MVN		r2, r2;				; r2 <- ~r2
			AND 	r1, r1, r2			; r1 <- r1 AND r2 (GPIOA_OSPEEDR & ~0b11)
            STR     r1, [r0]            ; GPIOA_OSPEEDR Register <- r1
			
			MOV32   r0, #GPIOA_PUPDR    ; r0 <- GPIOA PUPDR Register Address
			LDR		r1, [r0]			; r1 <- GPIOA_PUPDR Register Value
            MOV32   r2, #0x00000003     ; r2 <- 0b00000000000000000000000000000011
			MVN		r2, r2;				; r2 <- ~r2
			AND 	r1, r1, r2			; r1 <- r1 AND r2 (GPIOA_PUPDR & ~0b11)
            STR     r1, [r0]            ; GPIOA_PUPDR Register <- r1
			;*********************************************************************************
			
			;********** Configuring GPIOB.PORT1 as output 2MHz Push Pull Without Pullup/Pulldown *********
            MOV32   r0, #GPIOB_MODER    ; r0 <- GPIOB MODER Register Address
			LDR		r1, [r0]			; r1 <- GPIOB_MODER Register Value
            MOV32   r2, #0x00000004     ; r2 <- 0b00000000000000000000000000000100
			ORR 	r1, r1, r2			; r1 <- r1 OR r2 (GPIOB_MODER | 0b100)
            STR     r1, [r0]            ; GPIOB_MODER Register <- r1
			
			MOV32   r0, #GPIOB_OTYPER   ; r0 <- GPIOB OTYPER Register Address
			LDR		r1, [r0]			; r1 <- GPIOB_OTYPER Register Value
            MOV32   r2, #0x00000002     ; r2 <- 0b00000000000000000000000000000010
			MVN		r2, r2;				; r2 <- ~r2
			AND 	r1, r1, r2			; r1 <- r1 AND r2 (GPIOB_OTYPER & ~0b10)
            STR     r1, [r0]            ; GPIOB_OTYPER Register <- r1
			
			MOV32   r0, #GPIOB_OSPEEDR  ; r0 <- GPIOB_OSPEEDR Register Address
			LDR		r1, [r0]			; r1 <- GPIOB_OSPEEDR Register Value
            MOV32   r2, #0x0000000C     ; r2 <- 0b00000000000000000000000000001100
			MVN		r2, r2;				; r2 <- ~r2
			AND 	r1, r1, r2			; r1 <- r1 AND r2 (GPIOB_OSPEEDR & ~0b1100)
            STR     r1, [r0]            ; GPIOB_OSPEEDR Register <- r1
			
			MOV32   r0, #GPIOB_PUPDR    ; r0 <- GPIOB_PUPDR Register Address
			LDR		r1, [r0]			; r1 <- GPIOB_PUPDR Register Value
            MOV32   r2, #0x0000000C     ; r2 <- 0b00000000000000000000000000001100
			MVN		r2, r2;				; r2 <- ~r2
			AND 	r1, r1, r2			; r1 <- r1 AND r2 (GPIOB_PUPDR & ~0b1100)
            STR     r1, [r0]            ; GPIOB_PUPDR Register <- r1
			;***************************************************************************************
			
			;****** Waiting for PORTA.0 to Activate ***********************
PA0Loop
			MOV32   r0, #GPIOA_IDR    	; r0 <- GPIOA_IDR Register Address
			LDR		r1, [r0]			; r1 <- GPIOA_IDR Register Value
            MOV32   r2, #0x00000001     ; r2 <- 0b00000000000000000000000000000001
			AND 	r1, r1, r2			; r1 <- r1 AND r2 (GPIOA_IDR & 0b10)
            CMP		r1, #1
			BEQ		PA0Loop
			;**************************************************************
			
;****** Padded Photo Data Array ******************************************************************************************************
PdPhoto   DCB   129,129,124,130,126,127,122,129,14,128,118,125,128,130,138,125,125,129,129,124,130,126,127,122,129,14,128,118,125,128,130,138,125,125,112,112,99,145,131,99,117,128,29,118,93,111,119,133,158,145,145,105,105,97,104,111,134,96,127,11,125,114,98,109,129,114,129,129,107,107,109,117,92,81,105,129,6,126,111,93,78,121,105,118,118,101,101,99,75,101,100,108,122,0,125,76,79,90,94,122,118,118,120,120,71,68,112,116,125,114,1,125,90,75,115,103,79,99,99,129,129,126,127,126,130,128,118,2,115,115,111,119,129,127,128,128,16,16,25,15,18,4,1,4,35,6,7,7,18,20,14,21,21,128,128,126,128,128,127,115,118,8,125,120,87,90,108,96,122,122,129,129,93,91,104,76,97,129,6,121,96,80,89,109,116,113,113,129,129,117,102,91,108,90,128,14,115,108,111,105,90,109,100,100,125,125,94,117,78,124,124,124,29,113,117,115,106,80,100,100,100,120,120,95,81,119,87,103,127,31,109,111,111,87,86,86,114,114,120,120,103,113,125,109,124,121,9,101,86,118,104,100,78,117,117,128,128,128,130,145,127,123,123,0,114,95,93,112,84,105,122,122,128,128,128,130,145,127,123,123,0,114,95,93,112,84,105,122,122
;*********************************************************************************

			MOV32 	r0, PdPhoto 	; Padded Noisy Photo Data Arra Start Address
			ADD 	r0, r0, #18			; r0 <- First Main Pixel Address
			
			MOV32	r5, #FilteredPhoto	; r5 <- Beginning of Address where we store Filtered Photo Data
			MOV 	r1, #15				; r1 <- Row Counter
RowLoop
			MOV     r2, #15				; r2 <- Col Counter
ColLoop
			MOV 	r3, #0				; r3 <- Filtered Pixel
			
			LDRB 	r4, [r0,#-17]		; r4 <- kernel_12
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#-1]		; r4 <- kernel_21
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0]			; r4 <- kernel_22
			LSL		r4, #2				; r4 *= 4
			MVN		r4, r4				; r4 = ~r4
			ADD     r4, #1				; 2'nd complement
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#1]			; r4 <- kernel_23
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#17]		; r4 <- kernel_32
			ADD		r3, r3, r4			; r3 += r4
			
			MOV 	r4, #4				; r4 <- 4
			SDIV	r3, r3, r4			; sum(kernel*Pixel) / 4
			ADD		r3, r3, #64
			
			CMP 	r3, #100			; Comparing r3 with number 100
			BLE		LorE100				; r3 <= 100 goto LorE100 else if r3 > 100 goto next line
			MOV     r3, #255			; r3 <- 255 (white)
			B		GT100				; goto GT100 (jumping from next line)
LorE100
			MOV     r3, #0				; r3 <- 0 (black)
GT100
			STRB	r3, [r5]			; FilteredPhoto_Array <- FilteredPixel
			ADD		r5, r5, #1
			
			ADD		r0, r0, #1			; At the end of applying kernel on a pixel we add address with 1 to go to the next pixel
			SUB 	r2, r2, #1			; ColCounter--
			CMP		r2, #0				; if (ColCounter =! 0) Back to ColLoop
			BNE		ColLoop
			
			ADD		r0, r0, #2			; At the end of a row of the photo we add address with 2 to go to the address of the first pixel of the next row
			SUB 	r1, r1, #1			; RowCounter--
			CMP		r1, #0				; if (RowCounter =! 0) Back to RowLoop
			BNE		RowLoop
			
			
			;****** Finished => PORTB.1 = 1 ************************************
			MOV32   r0, #GPIOB_ODR    	; r0 <- GPIOB ODR Register Address
			LDR		r1, [r0]			; r1 <- GPIOB_ODR Register Value
            MOV32   r2, #0x00000002     ; r2 <- 0b00000000000000000000000000000010
			ORR 	r1, r1, r2			; r1 <- r1 OR r2 (GPIOB_ODR | 0b10)
            STR     r1, [r0]            ; GPIOB_ODR Register <- r1
			;*******************************************************************
loop
            B       loop
;**********************************************************************************
			END
