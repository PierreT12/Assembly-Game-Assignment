*-----------------------------------------------------------
* Title      : Neo Bonk - Pre Game Loop
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This is the Pre Game Loop, this starts after
             ; the title screen is passed at the player actually
             ; starts the game.
             ; This File:
             ; Jumps to load in all of the Background BitMaps
             ; seen during play
             ; Jumps to Start playing the Main Game Music
             ; Jumps to turn Double Buffering Mode on
             ; Jumps to set up the Enemies
             ; Jumps to set up the Player
             ; Jumps to start the Main Game Loop
*-----------------------------------------------------------
PreGameLoop
    movem.l ALL_REG,-(sp)       ; Moving Registers onto the Stack
    jsr LoadABunchofBitMaps     ; Load in all Background BitMaps
    movem.l (sp)+,ALL_REG       ; Restoring Registers from Stack
    
    movem.l ALL_REG,-(sp)       ; Moving Registers onto the Stack
    jsr PlayMusicOnLoop         ; Start play Main Game Music on Loop
    movem.l (sp)+,ALL_REG       ; Restoring Registers from Stack
    
    jsr DoubleBufferModeON      ; Turn on Double Buffer Mode
    
    movem.l ALL_REG,-(sp)       ; Moving Registers onto the Stack
    jsr BatSetUpLoop            ; Set Up Enemies
    movem.l (sp)+,ALL_REG       ; Restoring Registers from Stack
    
    movem.l ALL_REG,-(sp)       ; Moving Registers onto the Stack
    jsr SetUpPlayer             ; Set Up Players
    movem.l (sp)+,ALL_REG       ; Restoring Registers from Stack
    
    movem.l ALL_REG,-(sp)       ; Moving Registers onto the Stack
    jsr mainGameLoop            ; Start Main Game Loop
    movem.l (sp)+,ALL_REG       ; Restoring Registers from Stack


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
