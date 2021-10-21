*-----------------------------------------------------------
* Title      : Neo Bonk - Counter
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Increased the SpawnCounter and once it reachs 400
             ; The Enemy Velocity will increase.
             ; It will max out at 105 though as to not get too fast.
*-----------------------------------------------------------
;Increasing SpawnCounter and the BatSpeed if needed
CounterSpawn
    move.l BatSpeed,d7          ; Moving BatSpeed to a Register
    move.l SpawnCounter,d3      ; Moving SpawnCounter into a Register
    add.l #1,d3                 ; Add 1 to SpawnCounter
    move.l d3, SpawnCounter     ; Moving the Updated value into the SpawnCounter Variable
    cmpi.l #400,d3              ; Checks to see if the SpawnCounter is at 400 yet
    beq AddToScoreSpeed         ; If so, Increase BatSpeed
    bgt Erase                   ; If its larger, reset the value
    rts
    
;Increasing Enemy Velocity if need be
AddToScoreSpeed:
    addi.l #1, ScoreCounter     ; Add 1 to ScoreCounter
    cmpi.l #105,d7              ; Checking to see if velocity has maxed out
    beq Erase                   ; If it has just skip increasing the speed
    addi.l #1,d7                ; Add one to the BatSpeed Register
    move.l d7, BatSpeed         ; Update the BatSpeed

;Resetting the SpawnCounter Value
Erase:
    move.l #0, SpawnCounter ; Reset the SpawnCounter Value
    rts
    








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
