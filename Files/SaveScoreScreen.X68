*-----------------------------------------------------------
* Title      : Neo Bonk - Save Score Screen
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Displays the Save Score Screen using a DrawMax Loop
             ; Displays the Current Score and the Last Score
             ; Loops Until the user Press 'R' to restart the game
*-----------------------------------------------------------
; Clears Screen and starts the Load/Draw BitMap Process
SaveScoreScreenLoad
    jsr PlaySelectEffect ; Plays the Select Sound Effect
    jsr ClearScreen         ; Clears the screen
    jsr LoadSavingBitMap    ; Loads in and Draws the BitMap
    
    rts
    
    
; Draws the Loaded BitMap and Displays the propper Scores  
LoadSavingBitMap
    lea SaveScoreBitMap,a0   ; Loading the Game Over Bitmap into an Address Register
    jsr GetBitMapValues     ; Get the Size and Pixel Data Start Positions
    
    clr.l d1                ; Clear D1 so Data doesn't get mixed up
    move.l #600,d2          ; Move 600 int D2 so the Draw Loop knows
                            ; when to stop drawing on the Y axis
    jsr DrawLoopMax         ; Draws the Game Over Screen
    
    move.l #1,IsGameOver    ; Sets IsGameOver to True 
    
    move.l #1, IsSavedScore ; Sets IsSavedScore to True 
    
    movem.l ALL_REG,-(sp)   ; Moving Registers onto the Stack
    jsr DrawingLEDs         ; Drawing the Final Score in the LEDs
    movem.l (sp)+,ALL_REG   ; Restoring Registers from Stack

; Needed so that this can be JSR-ed from another File
ScoreTime:    
    move.l RealScore,RealScore2 ;Making a Copy of the most current score
    

    
    jsr ReadScore           ; Reading Last Score from File
    
    
    movem.l ALL_REG,-(sp)   ; Moving Registers onto the Stack
    jsr DrawingLEDs         ; Drawing the Last Score in the LEDs
    movem.l (sp)+,ALL_REG   ; Restoring Registers from Stack
ScoreTimeSave:     
    move.l RealScore2,RealScore ;Moving Score Back to Current Value
    
    jsr SaveScore           ; Saving Current Score to File
    
    jsr ReplayLevelLoopScore     ; Jump to the Replay Level Loop
    rts

; Loop that waits for the Player to Press a Button
ReplayLevelLoopScore             ; Loop Start
    jsr GetUserInputReplayScore  ; Checks to see if the Player has pressed a button
    bra ReplayLevelLoopScore     ; If not, keep checking until it does    
   	
; Checks if the User has Pressed R
GetUserInputReplayScore                      ; Getting User Input
    move.l #GET_USER_INPUT_COMMAND,d0   ; Loading in the User Input Trap Code
    move.l #'R',d1               ; The Keys it will be checking for
    trap #15                            ; Gets Keys        
    cmpi.b #0,d1                        ; Seeing if 'R' was pressed
    bne RestartGameScore                     ; If so, Restart the Game
    rts

; Resets some Values
RestartGameScore                 ; Restarting the Game
    jsr ResetVariables      ; Resetting some variable theres no Data MixUp
    jsr StartGame           ; Goes to start the game
    rts


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
