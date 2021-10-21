*-----------------------------------------------------------
* Title      : Neo Bonk - Player Update
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Updates the Player POS by adding Velocity to it
             ; This is depenedent on if the Player Presses 'A' or 'D'
             ; to move the Character.
             ; The Player can only move so far left and right before hitting
             ; The Max bounds
*-----------------------------------------------------------
;Updates the Players Postiton when the Player presses A or D
;Draws a Black Square behind the player as well
UpdatePlayer
    jsr DrawBehindPlayer    ; Draw Black Square Behind Player
    addi.l #1,RealScore     ; Add 1 to the Score 
    move.l #GET_USER_INPUT_COMMAND,d0   ; Loading in the User Input Trap Code
    move.l #'A'<<8+'D',d1               ; The Keys it will be checking fo
    trap #15                            ; Gets Keys
    cmpi.b #0,d1                        ; Seeing if 'D' was pressed
    bne moveRight                       ; If it was, Move Right
    rol #8,d1                           ; Switching the bools of 'A' and 'D'
    cmpi.b #0,d1                        ; Seeing if 'A' was pressed
    bne moveLeft                       ; If it was, Move Left
    rts
    
;Moving the Player Character Right
moveRight:
    move.l PlayerVelocity,d2 ; Moves PlayerVelocity into Register
    add.l d2,PlayerXPos      ; Adds PlayerVelocity to PlayerXPos 
    cmpi.l	#(RIGHT_SIDE_OF_SCREEN-PLAYER_WIDTH)<<8,PlayerXPos ; Compares Right of Screen - Player Width Value
    ble	noNegativeSetPlayer ; If it less than or equal to, move to noNegativeSetPlayer 
    
    move.l	#0,PlayerVelocity ; Moves 0 into PlayerVelocity
    
    cmpi.l	#(RIGHT_SIDE_OF_SCREEN-PLAYER_WIDTH)<<8,PlayerXPos ; Compares Right of Screen - Player Width Value

    bra noPositiveSetExtra ; Always Branch to noPositiveSetExtra

;Moving the Player Character Left
moveLeft:
ContinueMove
    move.l PlayerVelocity,d2     ; Moves PlayerVelocity into Register
    sub.l  d2,PlayerXPos ; Subtract PlayerVelocity from PlayerXPos 
    cmpi.l	#(120-PLAYER_WIDTH)<<8,PlayerXPos ; Compares 120(Left of Screen) - Player Width Value to PlayerXPos

    ble leftStop  ; If its less than or Equal to, stop the Velocity
    move.l #PLAYER_VELOCITY,PlayerVelocity  ;Move the EQU of PLAYER_VELOCITY into PlayerVelocity 
    rts

;Resets the Velocity of the Player
ResetVelocity
    bra ContinueMove ; Always Branch to ContinueMove
    
;Checks to see if the Player has gone too far left
noNegativeSetPlayer:
    cmpi.l	#120,PlayerXPos ; Compares 120(Left of Screen) to PlayerXPos
    move.l #PLAYER_VELOCITY,PlayerVelocity  ;Move the EQU of PLAYER_VELOCITY into PlayerVelocity 
    bgt	noPositiveSetExtra ; Always Branch to noPositiveSetExtra

; Stops the Player from Moving since they've gone too far left
leftStop
    move.l #0,PlayerVelocity ;Move 0 into PlayerVelocity
    bra	noPositiveSetExtra ; Always Branch to noPositiveSetExtra

; Just Returns to the last JSR
noPositiveSetExtra
	rts
	

    







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
