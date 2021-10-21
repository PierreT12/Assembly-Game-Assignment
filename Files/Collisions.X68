*-----------------------------------------------------------
* Title      : Neo Bonk - Collisions
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Checks for Collisiosn with the Player and Enemies
             ; It First checks to see if they have a greater or equal Y value
             ; Then Checks to see it the Player's Left X is within Enemy Bounds
             ; Or If the Player's Right X is within Enemy Bounds
             ;If either are true the Game Over will Load in
*-----------------------------------------------------------
CollisionCheck
    lea BatTopYPos,a4    ; Load in BatLeftXPos to an Address Register
    move.l (a4),d4       ; Move current Value into a Data Register
    asr.l  #8,d4 ;Arithmitic shift
    add.l #BALL_HEIGHT,d4   ; Add BALL_HEIGHT to BatLeftXPos
    
    
    move.l PlayerYPos,d1   ; Move PlayerYPos into a Data Register
    
    move.l PlayerXPos,d5    ; Move PlayerXPos into a Data Register
    asr.l  #8,d5 ;Arithmitic shift
    move.l d5,d3            ; Copy value into another Register
    addi.l #PLAYER_WIDTH,d3 ; Add PLAYER_WIDTH to PlayerXPos
    
    
    cmp.l d1,d4             ; Compare Player and Enemy Y value
    bge CheckXDirect        ; If they are greater than or equal do Check their X Values
    
    rts
    
  
CheckXDirect
    lea BatLeftXPos,a0  ; Load in BatLeftXPos to an Address Register
    lea BatRightXPos,a1 ; Load in BatRightXPos to an Address Register
    move.b #7,d0 ; Counter
loopCheck:              ; Will cycle through each Enemy to see if there is a hit
    move.l (a0),d6      ; Move Value of BatLeftXPos into Register
    move.l (a1),d7      ; Move Value of BatRightXPos into Register
    
    cmp.l d6,d5         ; Compares BatLeftXPos and PlayerXPos
    bge DoubleCheck     ; If greater or equal, double check
    
    cmp.l d6,d3         ; Compares BatLeftXPos and PlayerXPos+PLAYER_WIDTH
    bge OtherDoubleCheck  ; If greater or equal, double check
  
    add.l #4,a0 ;Shift Addresss forward by 1 Long
    add.l #4,a1 ;Shift Addresss forward by 1 Long
    subi.l #1,d0  ; Subtract 1 From Counter
    bne loopCheck ; If Counter isn't 0, keep looping
 
    rts
    
;Thsi just confirms that the collision is valid
DoubleCheck
    cmp.l d7,d5 ; Compares BatRightXPos and PlayerXPos
    ble Collision  ;If Less than or Equal to, thats a Hit
    
    cmp.l d6,d3 ; Compares BatLeftXPos and PlayerXPos+PLAYER_WIDTH
    bge OtherDoubleCheck  ; If greater or equal, double check
    
    
    add.l #4,a0 ;Shift Addresss forward by 1 Long
    add.l #4,a1 ;Shift Addresss forward by 1 Long
    subi.l #1,d0 ; Subtract 1 From Counter
    bne loopCheck ; If Counter isn't 0, keep looping
    rts

;Thsi just also confirms that the collision is valid
OtherDoubleCheck
    cmp.l d7,d3  ; Compares BatRightXPos and PlayerXPos+PLAYER_WIDTH
    ble Collision  ;If Less than or Equal to, thats a Hit
    
    
    add.l #4,a0 ;Shift Addresss forward by 1 Long
    add.l #4,a1 ;Shift Addresss forward by 1 Long
    subi.l #1,d0 ; Subtract 1 From Counter
    bne loopCheck ; If Counter isn't 0, keep looping
    rts

;If a hit is made
Collision
    jsr PlayBonkEffect      ; Play the Bonk Sound Effect
    jsr LoadGameOver        ; Load the Game Over Screen and Loop
    rts
    





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
