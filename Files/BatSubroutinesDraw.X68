*-----------------------------------------------------------
* Title      : Neo Bonk - Bat Subroutine Draw
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Loads all of the Enemy X/Y POS Data
             ; Loops through and draws every Enemy
*-----------------------------------------------------------
;The main loop for drawing all of the Enemies
BatDrawLoop
    lea BatLeftXPos,a0      ; Load in BatLeftXPos to an Address Register
    lea BatRightXPos,a1     ; Load in BatRightXPos to an Address Register
    lea BatTopYPos,a4       ; Load in BatTopYPos to an Address Register
    lea BatBottomYPos,a5    ; Load in BatBottomYPos to an Address Register
    move.b #7,d7 ; Counter

;This Loop Draws the Enemies
;Shifts the Address forward 1 Long and Loops    
updateDrawLoop:
    jsr DrawBats        ;Draw the Enemy
    
    jsr IncrementBatValues  ; Move Addresses Forawad by 1 Long
    
        
    subi.b #1,d7 ; Subtract 1 From Counter
    bne updateDrawLoop ; If Counter isn't 0, keep looping
    rts

;The Drawing of the Enemy
DrawBats
    move.l	#ENEMY_COLOR,d1 ; Sets the Enemy's Color

    jsr DrawCommands        ; Sets the TrapCodes for the Pen/Fill

	move.b	#DRAW_SQUARE_COMMAND,d0 ;Sets the TrapCode to draw Square
	
	
	move.l (a1),d3              ; Move BatRightXPos into a Register
	move.l (a0),d1              ; Move BatLeftXPos into a Register
	
	move.l (a4),d2              ; Move BatTopYPos into a Register
	asr.l  #8,d2 ;Arithmitic shift

    move.l d2,d4                 ; Copy BatTopYPos Register
    add.l #BALL_HEIGHT,d4        ; Add BALL_HEIGHT to the copy of BatTopYPos Register

    trap	#15                  ; Draw Enemy 
    rts
    




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
