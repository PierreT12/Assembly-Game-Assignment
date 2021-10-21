*-----------------------------------------------------------
* Title      : Neo Bonk - Title and Instructions Loading
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Starts the Title Screen Loop
             ; Loads in the Title Screen
             ; Has a Draw Loop to Render this in full screen (800x600)
             ; Keeps it displayed until the Player presses
             ; Either 'A' or 'I'
             ; Clears the screen if either are pressed 
             ; And plays a sound effect
             ; If 'A' is pressed, Jumps to the Pre Game Loop
             ; If 'I' is pressed, Loads the Instructions (with same Draw Loop)
             ; Holds on this Image until the Player presses 
             ; Either 'A' or 'I'
*-----------------------------------------------------------
;The Title Screen Loop
TitleSequenceLoop
    jsr LoadTitleScreen ; Loads the Title Screen
    
LoopPortion:            ; Loop Start
    jsr GetUserInput    ; Checks to see if the Player has pressed a button
    bra LoopPortion     ; If not, keep checking until it does    
 
;Gets the User Input
GetUserInput
    move.l #GET_USER_INPUT_COMMAND,d0 ; Loading in the User Input Trap Code
    move.l #'I'<<8+'A',d1             ; The Keys it will be checking for
    trap #15                          ; Gets Keys
    cmpi.b #0,d1                      ; Seeing if 'A' was pressed
    bne StartGame                     ; If so, Start the Game
    rol #8,d1                         ; Switching the bools of 'A' and 'I'
    cmpi.b #0,d1                      ; Seeing if 'I' was pressed
    bne InsctrutLoad                  ; If so, Load the Instructions
    rts

;Starting the Game
StartGame
    jsr PlaySelectEffect ; Plays the Select Sound Effect
    jsr ClearScreen      ; Clears the Screen
    jsr PreGameLoop      ; Goes to the Pre Game Loop
    rts
    
;Loading the Instructions BitMap and Drawing it to the Screen
InsctrutLoad
    jsr PlaySelectEffect       ; Plays the Select Sound Effect
    jsr ClearScreen            ; Clears the Screen
    lea InstructionsBitMap,a0  ; Loading the Instructions Bitmap into an Address Register
    jsr GetBitMapValues        ; Get the Size and Pixel Data Start Positions
    
    clr.l d1                   ; Clear D1 so Data doesn't get mixed up
    move.l #600,d2             ; Move 600 int D2 so the Draw Loop knows
                               ; when to stop drawing on the Y axis
    jsr DrawLoopMax            ; Draws the Instructions Screen
    jsr LoopPortion            ; Goes Back to the waiting for User Input Loop
    rts
  
;Clears the whole screen    
ClearScreen
    move.b  #CLEAR_SCREEN_COMMAND,d0    ; Setting Up the Clear Screen TrapCode 
    move.l  #CLEAR_SCREEN_MAGIC_VAL,d1  ; Sets Up Clear Screen Value
    trap    #15                         ; Clears Screen
    rts
   
;Loading the Title Screen BitMap and Drawing it to the Screen
LoadTitleScreen
    lea TitleScreenBitMap, a0   ; Loading the Title Screen Bitmap into an Address Register
    jsr GetBitMapValues         ; Get the Size and Pixel Data Start Positions
    
    move.l #600,d2              ; Move 600 int D2 so the Draw Loop knows when to stop drawing on the Y axis
    jsr DrawLoopMax             ; Draws the Title Screen
    rts

; Draw Loop
; This Draw Loop draws to the full screen (800x600)
; From Left to Right, Bottom to Top
; It:
; Gets the Color
; Draws the Pixel
; Shifts X forward 1
; Checks to see if it's at the end of a row
; If not, Loop again
; If so, Reset X and Subtrat 1 from Y
; Checks to see if Y is equal to 0
; If not, Loop again
; If so, Exit the Draw Loop
DrawLoopMax
    movem.l D1-D5,-(sp)                 ; Moving Registers onto the Stack
    jsr SetColor                        ; Gets Color from Pixel Data and Sets It
    movem.l (sp)+,D1-D5                 ; Restoring Registers from Stack
    move.l  #DRAW_PIXEL_TRAP_CODE,d0    ; Sets Up Draw Pixel TrapCode
    trap #15                            ; Draw Pixel
    addi.w #1,d1                        ; Adds 1 to the X value
    cmp.w #800,d1                       ; Checks to see if its at the end of the row
    bne DrawLoopMax                     ; If not, Loop Back
    move.l #0,d1                        ; If so, Reset X
    subi.w #1,d2                        ; Subtract 1 for Y
    cmpi.l #0,d2                        ; See if Y is at 0
    trap #15
    bne DrawLoopMax                     ; If not, Keep Loop
    rts                                 ; If so, Exit Out

  






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
