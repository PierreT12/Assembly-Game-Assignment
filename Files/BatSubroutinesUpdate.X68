*-----------------------------------------------------------
* Title      : Neo Bonk - Bat Subroutine Update
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Updates the Enemy Position Every Frame
             ; Adds Veclocity to their X and Y to move them Forward
             ; When they reach the bottom of the screen they respawn
             ; at the top in Random X POS
             ; They all have Equal Y POS
             ; Their X POS is determied by the Random Number Generation
             ; 4 Bats have the High Random Numbers (256-680)
             ; 3 Bats have the Low Random Numbers (100 - 255)
*-----------------------------------------------------------
; Loadint all Enemy POS Values int Address Registers and Set Them
BatUpdateLoop
    lea BatLeftXPos,a0      ; Load in BatLeftXPos to an Address Register
    lea BatRightXPos,a1     ; Load in BatRightXPos to an Address Register
    lea BatTopYPos,a4       ; Load in BatTopYPos to an Address Register
    lea BatBottomYPos,a5    ; Load in BatBottomYPos to an Address Register
    move.b #4,d0 ; Counter For Upper Enemies
    move.l #BALL_TOP_X_POSITION,d4 ;Spacing out the bats

;Loop that Updates all Upper Enemies    
updateLoop:
    jsr UpdateBatsHigher    ; Update the Higher Enemy POS

    jsr IncrementBatValues  ; Move Addresses Forward by a Long
    
    subi.b #1,d0 ; Subtract 1 From Counter
    bne updateLoop ; If Counter isn't 0, keep looping
    move.b #3,d0 ; Counter

;For balance we need 3 Enemies in the lower 255 X pixels
;This Lower Loop Updates those Enemies
updateLoopLower:
    jsr UpdateBatsLower     ; Update the Lower Enemy POS
    jsr IncrementBatValues  ; Move Addresses Forward by a Long
    
    subi.b #1,d0            ; Subtract 1 From Counter
    bne updateLoopLower     ; If Counter isn't 0, keep looping
    rts

;The Top Part of Update
UpdateTop
    movem.l D0-D7/A0-A6,-(sp) ; Moving Registers onto the Stack
    jsr DrawBehindBats
    movem.l (sp)+,D0-D7/A0-A6 ; Restoring Registers from Stack


    move.l (a5),d6      ;Move BatBottomYPos into a Register
    
    move.l BatSpeed,d6  ; Move BatSpeed into a Register
    
    move.l (a4),d3      ; Move BatTopYPos into a Register
    
    add.l d6,d3         ; Add BatSpeed to BatTopYPos
    move.l d3,(a4)      ; Move the result into BatTopYPos
    rts

;Bottom Part of the Update
UpdateBottom
    cmp.l #BALL_VELOCITY,d6 ;Comapres BALL_VELOCITY to Current Velocity
    bne   OffestNegVelocityBat ; If not equal, go to OffestNegVelocityBat
    move.l (a5),d6   ;Need to reset to the compare is updated
    rts

;Updates the Upper 4 Enemies
UpdateBatsHigher
    
    jsr UpdateTop ; The First Part of the Update Routnine
    
    cmpi.l #(BOTTOM_OF_THE_SCREEN-BALL_HEIGHT)<<8,d3 ; Compare Bottom of Screen -BALL_HEIGHT  Value to BatTopYPos
    ble noNegativeSetBat ; If less than, go to OffestNegVelocityBat 
    
    jsr SetBatsUpHigher ; Sets up the 4 Upper Enemeies 


    jsr UpdateBottom    ; The rest of the Update

    cmpi.l #(BOTTOM_OF_THE_SCREEN-BALL_HEIGHT)<<8,d3 ; Compare Bottom of Screen -BALL_HEIGHT  Value to BatTopYPos
    bra	noPositiveSet ; Always Branch to noPositiveSet 
    
    rts

;Updates the Lower 3 Enemies
UpdateBatsLower
    
    jsr UpdateTop ; The First Part of the Update Routnine
    
    cmpi.l #(BOTTOM_OF_THE_SCREEN-BALL_HEIGHT)<<8,d3 ; Compare Bottom of Screen -BALL_HEIGHT  Value to BatTopYPos
    ble noNegativeSetBat ; If less than, go to OffestNegVelocityBat 

    jsr SetBatsUpLower ; Sets up the 3 Lower Enemeies 


    jsr UpdateBottom    ; The rest of the Update

    cmpi.l #(BOTTOM_OF_THE_SCREEN-BALL_HEIGHT)<<8,d3 ; Compare Bottom of Screen -BALL_HEIGHT  Value to BatTopYPos
    bra	noPositiveSet ; Always Branch to noPositiveSet 
    
    rts


noNegativeSetBat
    cmpi.l	#0,d3 ; Compare 0 to BatTopYPos
	bgt	noPositiveSet ; Go to noPositiveSet if greater than
	move.l	#BALL_VELOCITY,(a5) ;Move BALL_VELOCITY into BatBottomYPos
	move.l (a5),d6   ;Need to reset to the compare is updated
	cmp.l BatSpeed, d6  ;Check to see if the Velcity Match the most Current (BatSpeed)
	bne CorrectSpeedBat ; If not, Correct it
    rts

; Corrects the Velocity of the Enemies if they don't match BatSpeed
CorrectSpeedBat:
    move.l BatSpeed,(a5) ; Move BatSpeed into the value of that Addresss Register
    rts
    
    
OffestNegVelocityBat:
    move.l (a5),d6   ;Need to reset to the compare is updated
    subi.l #5,d6     ;Subtract 5 from BatBottomYPos Data Register
    move.l d6,(a5)   ;Update the Actual Value of BatBottomYPos
    cmpi.l #(BOTTOM_OF_THE_SCREEN-BALL_HEIGHT)<<8,d3 ; Compare Bottom of Screen -BALL_HEIGHT  Value to BatTopYPos
    bra	noPositiveSet   ; Always Branch to noPositiveSet 
    
;Draws a Black Box Right Behind each Enemy
DrawBehindBats
    move.l	#BLACK,d1   ; Sets the  Color
    
    jsr DrawCommands    ; Sets the TrapCodes for the Pen/Fill
	
    move.b	#DRAW_SQUARE_COMMAND,d0 ; Sets the TrapCode to draw Square

    move.l (a1),d3                  ; Move BatRightXPos into a Register
	move.l (a0),d1                  ; Move BatLeftXPos into a Register
	
	move.l (a4),d2                  ; Move BatTopYPos into a Register
	asr.l  #8,d2 ;Arithmitic shift

    move.l d2,d4                    ; Copy BatTopYPos Register
    add.l #BALL_HEIGHT,d4           ; Add BALL_HEIGHT to the copy of BatTopYPos Register

    trap	#15                     ; Draw Black Box
    rts
    
; Just Returns to the last JSR
noPositiveSet
	rts







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
