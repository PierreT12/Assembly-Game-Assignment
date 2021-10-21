*-----------------------------------------------------------
* Title      : Neo Bonk - Music Loop
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
              ; Plays the Main Music on Loop while the Player is alive
              ; Stops when the Player Dies
              ; Plays Bonk Effect when the Player gets hit
              ; Plays Select Effect whent the Player selects something(Play,Restart,Instructions,etc.)
*-----------------------------------------------------------
;Plays Main Music on Loop
PlayMusicOnLoop
    lea	MainMusic,a1                        ; Loads in Main Music
    move.l #MUSIC_LOAD_COMMAND,d0           ; Load into Sound Memory
    trap #15           
    
    move.l #1,d2                            ; Setting Song to play in a Loop
    move.l #MUSIC_CONTROLLER_COMMAND,d0     ; Set Music Controller TrapCode
    trap #15
    rts

;Stop playing Main Music
StopMusic
    lea	MainMusic,a1                        ; Loads in Main Music
    move.l #MUSIC_LOAD_COMMAND,d0           ; Load into Sound Memory
    trap #15
    
    
    move.l #2,d2                            ; Setting Song to Stop Playing
    move.l #MUSIC_CONTROLLER_COMMAND,d0     ; Set Music Controller TrapCode
    trap #15
    rts

;Plays Bonk Effect
PlayBonkEffect
   lea	Bonk,a1                             ; Loads in Bonk Sound Effect
   move.l #MUSIC_LOAD_COMMAND,d0            ; Load into Sound Memory
   trap #15
   
   move.l #0,d2                             ; Setting Song to Play Once
   move.l #MUSIC_CONTROLLER_COMMAND,d0      ; Set Music Controller TrapCode
   trap #15
   rts
   
;Plays Select Effect
PlaySelectEffect
   lea	Select,a1                           ; Loads in Select Sound Effect
   move.l #MUSIC_LOAD_COMMAND,d0            ; Load into Sound Memory
   trap #15
   
   move.l #0,d2                             ; Setting Song to Play Once
   move.l #MUSIC_CONTROLLER_COMMAND,d0      ; Set Music Controller TrapCode
   trap #15

    rts



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
