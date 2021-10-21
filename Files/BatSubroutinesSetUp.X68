*-----------------------------------------------------------
* Title      : Neo Bonk - Bat Subroutines SetUp
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Sets Up the X/Y Positions for all Enemies
             ; All of their values are stored in variables and loaded in
             ; Via Address Registers
             ; The X Value is Randomly Generated 
             ; 4 Bats have the High Random Numbers (256-680)
             ; 3 Bats have the Low Random Numbers (100 - 255)
*-----------------------------------------------------------
; Loadint all Enemy POS Values int Address Registers and Set Them
BatSetUpLoop
    lea BatLeftXPos,a0      ; Load in BatLeftXPos to an Address Register
    lea BatRightXPos,a1     ; Load in BatRightXPos to an Address Register
    lea BatTopYPos,a4       ; Load in BatTopYPos to an Address Register
    lea BatBottomYPos,a5    ; Load in BatBottomYPos to an Address Register
    move.b #4,d0        ; Counter For Upper Enemies
    move.l #BALL_TOP_X_POSITION,d4  ;Spacing out the bats

;Loop that Sets up all Upper Enemies
loop:
    jsr SetBatsUpHigher     ; Gets the Higher Random Value and Set X/Y Value

    jsr IncrementBatValues  ; Move Addresses Forward by a Long
    
    subi.b #1,d0            ; Subtract 1 From Counter
    bne loop                ; If Counter isn't 0, keep looping
    move.b #3,d0 ;If Counter is 0, Set Lower Counter

;For balance we need 3 Enemies in the lower 255 X pixels
;This Lower Loop Sets those Enemies
lowerLoop:
    jsr SetBatsUpLower      ; Gets the Lower Random Value and Set X/Y Value

    jsr IncrementBatValues  ; Move Addresses Forward by a Long
    
    subi.b #1,d0            ; Subtract 1 From Counter
    bne lowerLoop           ; If Counter isn't 0, keep looping
    rts

;Setting up the Higher Enemies
SetBatsUpHigher
    ;clr.l d1
    jsr GetRandomValue256   ; Get a Higher Random Numer
    jsr InnerBatSetUp       ; Set the X/Y POS of the Enemy
    rts
;Setting up the Higher Enemies   
SetBatsUpLower
    clr.l d1                ; Clears Register so there's no Data Mix Up
    clr.l d7                ; Clears Register so there's no Data Mix Up
    jsr GetRandomValue      ; Get a Lower Random Numer
    jsr InnerBatSetUp       ; Set the X/Y POS of the Enemy
    rts

;Sets the X/Y values for the Enemies
InnerBatSetUp
;Setting Up X
    move.l	d1,(a0)     ; Moves Register Value into BatLeftXPos
    move.l d1,d5        ; Setting up both L/R X values, Copying BatLeftXPos Register
    add.l #BALL_WIDTH,d5  ; Adding BALL_WIDTH to BatLeftXPos, to make BatRightXPos
    move.l d5,(a1)        ; Moves Register Value into BatRightXPos


    ;Setting Y and Y velocity
    move.l #0,(a4)  ;Move 0 into BatTopYPos since its starts a Y = 0
    move.l #BALL_VELOCITY,(a5) ; Move BALL_VELOCITY into BatBottomYPos
    rts

;Shifts all the Addresses Forward by 1 long
IncrementBatValues
    add.w #4,a0     ; Shift BatLeftXPos by 1 Long
    add.w #4,a1     ; Shift BatRightXPos by 1 Long
    add.w #4,a4     ; Shift BatTopYPos to by 1 Long
    add.w #4,a5     ; Shift BatBottomYPos by 1 Long
    add.l #150,d4 ;Making sure they aren't set right on top of eachother
    rts









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
