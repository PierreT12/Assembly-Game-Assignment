*-----------------------------------------------------------
* Title      : Neo Bonk - Seven Segment LED 
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Takes the Score
             ; Shifts it to Normalize the Value
             ; Draws the correct number in the correct digits place up to 999
             ; Handles Display Last Score and GameOver Score
*-----------------------------------------------------------
;This is going to handle drawing the 7 Segment LEDs
DrawingLEDs
;
    move.l RealScore,d1  ;This is where the actual score is set to display
    
    asr.l  #8,d1 ;Arithmitic shift
    asr.l  #2,d1 ;Arithmitic shift
    
    move.l d1,d4 ;Creating A copy
    cmpi.l #999,d1  ;Compares the Current Score to Max Possible (999)
    beq MaxOut      ; If it is 999 Go to Max Out
    cmpi.w #10,d1   ; Checks to see if the score is 10 or larger
    bge PlacementCheck  ; If its do a Placement check
    blt OnesDraw    ;If not go to the Ones Draw
    rts

;If the score is max, the game will end and the max score will be displayed
MaxOut
    cmp.l #1,IsGameOver ;Checking to see if the game has ended    
    beq PlacementCheck  ; Do a Placement Check for Score
    jsr LoadGameOver    ; If not, End the Game
    rts

;Gets the Routine to display the right number in the Ones Digit for the socre
OnesDraw
    lea SevenSegLEDRountines,a4 ; Load in the Function Pointer into a Regiter
 

    cmp.l #1,IsGameOver ;Checking to see if the game has ended    
    beq ShiftPlacement  ; If it has, shift the placement of the score
    
    cmp.l #1,IsSavedScore ;See if we need to display the saved score
    beq ShiftPlacementScore ; If it does, shift the placement of the score
    
    ;The Ones Position
    move.l #415,d6 ;X
    move.l #555,d7 ;Y
    

;Continues to display the digit even after a shift in POS is made
ContinueOnes:
    ;Going to the RoutinePOS
    muls #4,d1      ;Multiplies the 1 digit score to get the poitner address
    add.l d1,a4     ; Adds it to the Address Regiser
    
    move.l (a4),a3  ; Gets the Address of the actual Routine
    
    movem.l D1-D7/A0-A6,-(sp)  ; Moving Registers onto the Stack
    jsr (a3)                   ;Jumping to the correct Routine
    movem.l (sp)+,D1-D7/A0-A6  ; Restoring Registers from Stack
    rts
   
; This shifts the placement if the game is over, so the final score can be displayed correctly 
ShiftPlacement:
    move.l #410,d6 ;X
    move.l #515,d7 ;Y
    move.l #0, IsGameOver ;Resetting this value
    jsr ContinueOnes ;Finish the rest of loading in the Digit
    cmp.l #1,IsSavedScore ;See if we need to display the saved score
    beq JsrTime         ;So we can jsr to the score stuff
    jsr ReplayLevelLoop ;Go back to the replay level Loop
    
; This shifts the placement if the score is being saved, so the saved score can be displayed correctly 
ShiftPlacementScore:
    move.l #410,d6 ;X
    move.l #325,d7 ;Y
    move.l #0, IsSavedScore ;Resetting this value
    jsr ContinueOnes ;Finish the rest of loading in the Digit
    jsr ScoreTimeSave

    
;Check to see how big the number is    
PlacementCheck
    cmpi.w #100,d1      ; Comparing 100 to the Real Score
    bge HundredsPlace   ; If it is bigger or equal to 100 start getting the hundreths digit
    blt TensPlace       ; If not, start getting the tenths digit
    rts

;Gets the Routine to display the right number in the Hundreds Digit for the socre
HundredsPlace
    clr.l d3        ; Clearing Register so there is No Mix Up
    lea SevenSegLEDRountines,a4  ; Load in the Function Pointer into a Regiter
;Loop so that the propper Hundreds Digit can be displayed
HundredsLoop:
    addi.l #1,d3        ; Add 1 to Digit Counter
    subi.l #100,d1      ; Subtract 100 for Real Score 
    cmpi.l #100,d1      ; See if there is any Hundred's digits left
    bge HundredsLoop    ; If so, keep looping
    
    
    cmp.l #1,IsGameOver ;Checking to see if the game has ended  
    beq ShiftPlacementHundreds ; If it has, shift the placement of the score
    
    cmp.l #1,IsSavedScore ;See if we need to display the saved score
    beq ShiftPlacementHundredsScore  ; If it does, shift the placement of the score
    
    ;The Hundreds Position
    move.l #365,d6 ;X
    move.l #555,d7 ;Y
 ;Continues to display the digit even after a shift in POS is made   
ContinueHundreds:    
    muls #4,d3 ;Multiplies the 100's digit score to get the poitner address
    add.l d3,a4  ; Adds it to the Address Regiser
    
    move.l (a4),a3           ; Gets the Address of the actual Routine
    
    movem.l D1-D7/A0-A6,-(sp)    ; Moving Registers onto the Stack
     jsr (a3)                   ;Jumping to the correct Routine
    movem.l (sp)+,D1-D7/A0-A6   ; Restoring Registers from Stack

    jsr TensPlace ;Get the Tens Place

    rts

; This shifts the placement if the game is over, so the final score can be displayed correctly 
ShiftPlacementHundreds:
    move.l #360,d6 ;X
    move.l #515,d7 ;Y
    jsr ContinueHundreds ;Finish the rest of loading in the Digit

; This shifts the placement if the score is being saved, so the saved score can be displayed correctly 
ShiftPlacementHundredsScore:
    move.l #360,d6 ;X
    move.l #325,d7 ;Y
    jsr ContinueHundreds ;Finish the rest of loading in the Digit


;Gets the Routine to display the right number in the Tens Digit for the socre    
TensPlace
    clr.l d5
    lea SevenSegLEDRountines,a4 ; Load in the Function Pointer into a Regiter
    cmpi.l #10,d1    ; Comparing 10 to the Real Score
    blt TensLoopSkip ; If it is less than 10 Skip trying to fill the value with a non 0
;Loop so that the propper Tens Digit can be displayed
TensLoop:
    addi.l #1,d5    ; Add 1 to Digit Counter
    subi.l #10,d1   ; Subtract 10 for Real Score
    cmpi.l #10,d1   ; See if there is any Ten's digits left
    bge TensLoop    ; If so, keep looping
;This is for numbers that have a hundreds but no tenths place
TensLoopSkip


    cmp.l #1,IsGameOver ;Checking to see if the game has ended  
    beq ShiftPlacementTens ; If it has, shift the placement of the score
    
    cmp.l #1,IsSavedScore ;See if we need to display the saved score
    beq ShiftPlacementTensScore  ; If it does, shift the placement of the score

    ;The Tens Position
    move.l #390,d6 ;X
    move.l #555,d7 ;Y
;Continues to display the digit even after a shift in POS is made
ContinueTens:
    muls #4,d5   ;Multiplies the 10's digit score to get the poitner address
    add.l d5,a4  ; Adds it to the Address Regiser
    
    move.l (a4),a3           ; Gets the Address of the actual Routine
    
    movem.l D1-D7/A0-A6,-(sp)    ; Moving Registers onto the Stack
     jsr (a3)                   ;Jumping to the correct Routine
    movem.l (sp)+,D1-D7/A0-A6    ; Restoring Registers from Stack

    jsr OnesDraw
    rts

; This shifts the placement if the game is over, so the final score can be displayed correctly    
ShiftPlacementTens:
    move.l #385,d6 ;X
    move.l #515,d7 ;Y
    jsr ContinueTens ;Finish the rest of loading in the Digit

; This shifts the placement if the score is being saved, so the saved score can be displayed correctly 
ShiftPlacementTensScore:
    move.l #385,d6 ;X
    move.l #325,d7 ;Y
    jsr ContinueTens ;Finish the rest of loading in the Digit

;We Need to jsr to display the save score if needed
JsrTime
    jsr ScoreTime   ;Jsring to display Saved Score





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
