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
			
;****** Padded Noisy Photo Data Array ******************************************************************************************************
PdNoisyPhoto   DCB   129,129,109,153,143,118,158,144,42,102,175,157,133,114,177,72,72,129,129,109,153,143,118,158,144,42,102,175,157,133,114,177,72,72,102,102,110,157,109,97,111,114,6,102,99,86,122,122,183,151,151,83,83,107,103,133,137,39,130,2,103,110,75,93,94,135,121,121,105,105,99,144,81,116,80,125,48,102,107,108,77,95,100,108,108,95,95,100,66,85,108,66,126,22,71,53,98,88,147,137,100,100,192,192,73,79,119,119,136,113,7,112,85,80,141,132,36,87,87,144,144,144,135,122,172,122,118,0,137,101,140,85,102,127,118,118,32,32,28,27,0,25,0,29,42,38,14,0,34,0,0,59,59,114,114,130,100,184,113,124,97,8,104,151,58,62,65,120,140,140,122,122,44,116,78,82,141,93,0,111,57,63,99,61,110,139,139,116,116,107,169,45,159,106,123,0,112,121,97,116,133,101,102,102,68,68,40,158,88,100,143,115,57,141,153,114,48,62,117,81,81,137,137,69,78,117,106,85,126,19,91,87,82,100,82,83,112,112,145,145,144,132,95,121,148,85,67,72,166,153,87,80,77,127,127,131,131,141,166,134,171,129,128,9,112,116,74,113,73,64,122,122,131,131,141,166,134,171,129,128,9,112,116,74,113,73,64,122,122
;*******************************************************************************************************************************************

			MOV32 	r0, PdNoisyPhoto 	; Padded Noisy Photo Data Arra Start Address
			ADD 	r0, r0, #18			; r0 <- First Main Pixel Address
			
			MOV32	r5, #FilteredPhoto	; r5 <- Beginning of Address where we store Filtered Photo Data
			MOV 	r1, #15				; r1 <- Row Counter
RowLoop
			MOV     r2, #15				; r2 <- Col Counter
ColLoop
			MOV 	r3, #0				; r3 <- Filtered Pixel
			
			LDRB 	r4, [r0,#-18]		; r4 <- kernel_11
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#-17]		; r4 <- kernel_12
			LSL		r4, #1				; r4 *= 2
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#-16]		; r4 <- kernel_13
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#-1]		; r4 <- kernel_21
			LSL		r4, #1				; r4 *= 2
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0]			; r4 <- kernel_22
			LSL		r4, #2				; r4 *= 4
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#1]			; r4 <- kernel_23
			LSL		r4, #1				; r4 *= 2
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#16]		; r4 <- kernel_31
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#17]		; r4 <- kernel_32
			LSL		r4, #1				; r4 *= 2
			ADD		r3, r3, r4			; r3 += r4
			
			LDRB 	r4, [r0,#18]		; r4 <- kernel_33
			ADD		r3, r3, r4			; r3 += r4
			
			MOV 	r4, #16				; r4 <- 16
			UDIV	r3, r3, r4			; sum(kernel*Pixel) / 16
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
