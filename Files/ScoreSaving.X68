*-----------------------------------------------------------
* Title      : Neo Bonk -  Score Saving
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Opens the Score File using TrapCodes
             ; Write to the Score File using TrapCodes
             ; Closes the Score File using TrapCodes
             ; Reads from the Scroe File using TrapCodes
*-----------------------------------------------------------

;This writes the score you got to the Bin File
;It only saves the last one you got
SaveScore
    clr.l d1          ; Clears Register so theres no MixUp in the Data
    lea ScoreFile,a1  ; Loads the Score file
    move.l #OPEN_FILE_COMMAND_OVERWRITE,d0     ; Using Open File TrapCode   
    trap #15          ; Opens the file

    lea RealScore,a1  ; Loads the score that will be moved in
    
    move.l #WRITE_FILE_COMMAND,d0     ; Using the Write To File TrapCode
    
    move.l #4,d2      ; Setting How many bytes the write will be
    trap #15          ; Writing the score to the file
    
    lea ScoreFile,a1  ; Loading the file one more time
    move.l #CLOSE_FILE_COMMAND,d0     ; Using the Close File TrapCode
    trap #15          ; Closing the File
    
    rts

;Reads the score from File  
ReadScore
    clr.l d1          ; Clears Register so theres no MixUp in the Data
    lea ScoreFile,a1  ; Loads the Score file
    move.l #OPEN_FILE_COMMAND,d0     ; Using Open File TrapCode   
    trap #15          ; Opens the file
    
    move.l #0,RealScore ;Clearing Real Score so the data isn't messy
    
    lea RealScore,a1 ; Loads the score that will be moved in
    move.l #READ_FILE_COMMAND,d0    ; Using the Read from File TrapCode
    move.l #4,d2     ; How many bytes to read
    trap #15
    
    rts





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
