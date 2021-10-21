*-----------------------------------------------------------
* Title      : Neo Bonk - Misc. Commands
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File holds Routines that don't really go anywhere else.
             ; Turning Double Buffer Mode On
             ; Swaping Buffers
             ; Turning Double Buffer Mode Off
*-----------------------------------------------------------
;This turns Double Buffer Mode On
DoubleBufferModeON
    move.b	#DRAWING_MODE_TRAP_CODE,d0  ; Using Drawing Mode TrapCode        
    move.b	#DOUBLE_BUFFERED_MODE,d1    ; Using Double Buffer Mode On TrapCode
    trap	#15                         ; Setting Double Buffer Mode ON
    rts

; Swaps Buffers
swapBuffers
	move.b  #REPAINT_SCREEN_TRAP_CODE,d0 ; Using Repaint Screen TrapCode
    trap    #15                          ; Copies Off Buffer to the screen
	rts     

;This turns Double Buffer Mode Off
DoubleBufferModeOFF
    move.b	#DRAWING_MODE_TRAP_CODE,d0      ; Using Drawing Mode TrapCode   
    move.b	#DOUBLE_BUFFERED_MODE_OFF,d1    ; Using Double Buffer Mode Off TrapCode
    trap	#15                             ; Setting Double Buffer Mode Off
    rts

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
