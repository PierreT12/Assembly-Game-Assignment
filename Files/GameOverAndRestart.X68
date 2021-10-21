*-----------------------------------------------------------
* Title      : Neo Bonk - Game Over and Restart Loading
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Starts the GameOver Loop
             ; Turns off Double Buffer Mode
             ; Stops the Main Game Music
             ; Draws the Game Over Sceen using a Draw Loop
             ; to the whole screen (800x600)
             ; Keeps it displayed until the Player presses
             ; Either 'E' or 'R'
             ; Clears the screen if either are pressed 
             ; And plays a sound effect
             ; If 'R' is pressed, some variables (Score, Velocity, etc.)
             ; are reset and then it jumps to the StartGame routine
             ; If 'E' is pressed
             ; Go to the Save Score Screen
*-----------------------------------------------------------

LoadGameOver                 ; Going throught the Game Over Sequence
    jsr DoubleBufferModeOFF  ; Turning Double Buffer Off since is no longer needed
    jsr StopMusic            ; Turning off the Main Music since its no Longer needed
    jsr ClearScreen          ; Clearing the screen so that the Game Over BitMap can be drawn
    jsr LoadGameOverBitMap   ; Loading and Drawing the Game Over BitMap
    

;Loading the Game Over BitMap and Drawing it to the Screen
LoadGameOverBitMap
    lea GameOverBitMap,a0   ; Loading the Game Over Bitmap into an Address Register
    jsr GetBitMapValues     ; Get the Size and Pixel Data Start Positions
    
    clr.l d1                ; Clear D1 so Data doesn't get mixed up
    move.l #600,d2          ; Move 600 int D2 so the Draw Loop knows
                            ; when to stop drawing on the Y axis
    jsr DrawLoopMax         ; Draws the Game Over Screen
    
    move.l #1,IsGameOver    ; Sets IsGameOver to True 
    
    movem.l ALL_REG,-(sp)   ; Moving Registers onto the Stack
    jsr DrawingLEDs         ; Drawing the Final Score in the LEDs
    movem.l (sp)+,ALL_REG   ; Restoring Registers from Stack
    
    jsr ReplayLevelLoop     ; Jump to the Replay Level Loop
    rts

ReplayLevelLoop             ; Loop Start
    jsr GetUserInputReplay  ; Checks to see if the Player has pressed a button
    bra ReplayLevelLoop     ; If not, keep checking until it does    
   	
GetUserInputReplay                      ; Getting User Input
    move.l #GET_USER_INPUT_COMMAND,d0   ; Loading in the User Input Trap Code
    move.l #'E'<<8+'R',d1               ; The Keys it will be checking for
    trap #15                            ; Gets Keys        
    cmpi.b #0,d1                        ; Seeing if 'R' was pressed
    bne RestartGame                     ; If so, Restart the Game
    rol #8,d1                           ; Switching the bools of 'E' and 'R'
    cmpi.b #0,d1                        ; Seeing if 'E' was pressed
    bne SaveScoreScreenLoad             ; If so, Go to the Save Score Screen
    rts 	
   	
RestartGame                 ; Restarting the Game
    jsr ResetVariables      ; Resetting some variable theres no Data MixUp
    jsr StartGame           ; Goes to start the game
    rts
  

ResetVariables                      ; Resetting some of the variables
    jsr Erase                       ; Resetting the score keeper for velocity increase
    move.l #0,RealScore             ; Resetting the score
    move.l #BALL_VELOCITY,BatSpeed  ; Resetting the velocity
    rts  




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
