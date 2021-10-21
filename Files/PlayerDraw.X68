*-----------------------------------------------------------
* Title      : Neo Bonk - Player Draw
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Sets Pen/Fill TrapCodes
             ; Draws Black Box Behind Player
             ; Draws Player
*-----------------------------------------------------------
;Common Commands used when Drawing Enemy/Player to the Screen
DrawCommands
    move.b	#SET_PEN_COLOR_COMMAND,d0   ; Sets Pen Color TrapCode
	trap	#15
	move.b	#SET_FILL_COLOR_COMMAND,d0  ; Sets Fill Color TrapCode
	trap	#15
    rts

;Drawing a Black Box behind the Player
DrawBehindPlayer
    move.l	#BLACK,d1       ; Sets the  Color
    
    jsr DrawCommands        ; Sets the TrapCodes for the Pen/Fill
    
	move.b	#DRAW_SQUARE_COMMAND,d0 ; Sets the TrapCode to draw Square

    move.l PlayerXPos,d1            ; Move PlayerXPos into a Register
	asr.l #8,d1                     ; Arithmitic shift
	
	move.l PlayerYPos,d2            ; Move PlayerYPos into a Register
	
	move.l d1,d3                    ; Copy PlayerXPos into another register
	
	add.l #PLAYER_WIDTH,d3          ; Add the Player Width to it to get the
	                                ; Proper Square Size
	move.l PlayerYCombined, d4      ; Move PlayerYCombined into a Register

    trap	#15
    rts



;Draws the Player
DrawPlayer
    move.l	#PLAYER_COLOR,d1         ; Sets the Player's Color
    
	jsr DrawCommands                 ; Sets the TrapCodes for the Pen/Fill
	
	move.b	#DRAW_SQUARE_COMMAND,d0  ;Sets the TrapCode to draw Square
	
	move.l PlayerXPos,d1             ; Move PlayerXPos into a Register
	asr.l #8,d1                      ; Arithmitic shift
	
	move.l PlayerYPos,d2             ; Move PlayerYPos into a Register
	
	move.l d1,d3                     ; Copy PlayerXPos into another register
	
	add.l #PLAYER_WIDTH,d3           ; Add the Player Width to it to get the
	                                 ; Proper Square Size
	move.l PlayerYCombined, d4       ; Move PlayerYCombined into a Register
    trap	#15

    rts
   




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
