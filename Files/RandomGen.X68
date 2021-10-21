*-----------------------------------------------------------
* Title      : Neo Bonk - Random Number Generation
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Gets a Seed for Random Number Generation Based on the Time
             ; Generates a Random Number based on an Alogrithm in two ways
             ; Lower for numbers in between 100 - 255
             ; Higher for number in between 256 - 680
             ; These are the X POS for the Enemies
             ; If the Generated Number it Outside of this Range it's recalcuated
*-----------------------------------------------------------
;Gets the Lower Random Byte and makes sure its within Range
GetRandomValue
    jsr GetRandomByte ; Gets the Random Byte
    move.b (a3),d1    ; Moves value of RandomBatVariable into Register
    jsr CompareReRun  ; Makes sure Random Number is Valid
    

    rts
    
;Gets the Upper Random Word and makes sure its within Range
GetRandomValue256
    jsr GetRandomByte ; Gets the Random Byte
    move.b (a3),d1    ; Moves value of RandomBatVariable into Register
    add.w #1,a3       ; Shift RandomBatVariable Address over
    rol #8,d1         ; Moves RandomBatVariable Register over so another bytec an fit
    move.b (a3),d1    ; Moves value of RandomBatVariable into Register
    jsr CompareReRunLarge   ; Makes sure Random Number Word is Valid
    rts


;Getting a Time Based Seed
GetTimeSeed
    lea RandomBatVariable,a3   ;Loading in RandomBatVariable to an Address Register
    
    move.l	#8,d0    ; Setting Getting Time TrapCode
    trap #15
    
	ori.l	#$75000000,d1       ; Setting the Upper Bits         
    move.l	d1,(a3)             ; Moving Upper Bit into Value of RandomBatVariable
	clr.l	d1                  ; Clearing Data Register
	move.l	#10,d2	
    clr.l	d4
    rts

;Getting Random Number from Generation
GetRandomByte
    movem.l	D0-D7,-(sp) ; Moving Registers onto the Stack
    
    lea RandomBatVariable,a3 ;Loading in RandomBatVariable to an Address Register
    move.l	(a3),d0         ;Getting the current seed
    cmpi.l #0, d0
    beq GetTimeSeed
    
    move.l	#$AF-$100,d1    ;Setting EOR Values
    
    move.l	#18,d2          ;Do this 19 times
    
looping
	add.l	d0,d0			;shift left 1 bit
	bcc.s	endLooping	;Skipping if its not set

	eor.b	d1,d0			;Doing the Galois LFSR Feedback
endLooping
	dbf	d2,looping		;Continue Looping if Needed
    
    
    move.l d0,(a3)      ;Updating RandomBatVariable
    
    movem.l	(sp)+,D0-D7	 ; Restoring Registers from Stack
    rts

; Making sure that the Random Number is between 100 - 255
CompareReRun
    move.b #100,d7  ;Move 100 into a Register
    cmp.w d7,d1  ;Checking if random number is less than 100
    blt GetRandomValue ; If it is, Get another Random Number
    move.w #255,d7  ;Move 255 into a Register
    cmp.w d7,d1 ;Checking if random number is Greater than 255
    bgt GetRandomValue ; If it is, Get another Random Number
    rts
    
; Making sure that the Random Number is between 256 - 680
CompareReRunLarge
    asr.l  #6,d1
    move.w #256,d7 ;Move 256 into a Register
    cmp.w d7,d1  ;Checking if random number is less than 256
    blt GetRandomValue256 ; If it is, Get another Random Number
    move.w #679,d7 ;Move 679 into a Register
    cmp.w d7,d1  ;Checking to see if random number is greater than 679
    bgt GetRandomValue256 ; If it is, Get another Random Number
    rts






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
