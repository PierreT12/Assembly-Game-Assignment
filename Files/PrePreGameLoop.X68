*-----------------------------------------------------------
* Title      : Neo Bonk - PrePre Game Loop
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This sets up a few things and then loads the Title Screen Loop.
             ; This File:
             ; Jumps to Set the Window Size
             ; Jumps to Get the Seed for Random Numbers
             ; Jumps to Shifts Values In, Loads EQU into a General Address Register
             ; Jumps to Loads said Valuses into their speific
             ; Address Registers in the right place
             ; Jumps to start the Title Sequence Game Loop 
*-----------------------------------------------------------
SuperPreGameLoop 
    jsr SetWindow               ; Setting up the window
    clr.l d1                    ; Clears Width and Height Values after set so they dont mess up stuff 

    ;Only get the seed once
    jsr GetTimeSeed             ; Gets the Seed for Random Number Generation
    
    jsr ShiftingValuesIn        ; Shifts EQU Values into General Address Register
    
    jsr LoadingBitMapVariable   ; Shifts Values from General Register into their Respective Registers
    
    
    movem.l ALL_REG,-(sp)       ; Moving Registers onto the Stack
    jsr TitleSequenceLoop       ; Starts the Title Screen Loop
    movem.l (sp)+,ALL_REG       ;Restoring Registers from Stack




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
