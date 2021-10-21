*-----------------------------------------------------------
* Title      : Neo Bonk - Window Set Up
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Sets the Window Size for the Game.
*-----------------------------------------------------------
;Setting the Window Size
SetWindow
    move.b  #SET_OUTPUT_RESOLUTION_TRAP_CODE,D0 ; Using Output Resolution TrapCode
    move.l  #800,d1                             ; Sets width to 800
    swap.w  d1                                  ; Swaping words so Height can be set
    move.w  #600,d1                             ; Sets height to 600
    trap #15                                    ; Resizing Window
    rts
    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
