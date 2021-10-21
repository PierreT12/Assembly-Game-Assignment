*-----------------------------------------------------------
* Title      : Neo Bonk - Player SetUp
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Sets the Player X Pos
             ; Sets the Player Y Pos
             ; Sets the Player Velocity
*-----------------------------------------------------------
; Sets Up the Intital Player Position Values
SetUpPlayer
    move.l #76500,PlayerXPos                ; Sets the X POS it will be at when the Game Loads in
    move.l #PLAYER_VELOCITY,PlayerVelocity  ; Sets the Player Velocity
    
    move.l #PLAYER_TOP_Y_POS,d3             ; Put the YPOS into a Register
    move.l d3, PlayerYPos                   ; Moves it into PlayerYPos
    
    add.l #PLAYER_HEIGHT, d3                ; Add Player Height to Register
    move.l d3, PlayerYCombined              ; Move Register into PlayerYCombined (PlayerYPos + Player Height)
    rts
    


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
