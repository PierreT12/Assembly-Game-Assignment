*-----------------------------------------------------------
* Title      : Neo Bonk - Routines
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Stores all number Routines for the Seven Segment LED's
             ; When one is called it first:
             ; Draws a Black Square behind itself
             ; Then Loads the SegmentRoutine Function Pointer
             ; After that it jumps to the Segemnts it is required to draw for that number
*-----------------------------------------------------------

;Drawing Segments for Number 0
routine0
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draw Segments A,B,C,D,E,F
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l (a0),a1 ; Loading in Segment A
    jsr (a1)        ;Drawing Segment A
    move.l #5,d5 ;Counter
    jsr LoopThrough ;Draws Segments B - F
    rts

;Drawing Segments for Number 1   
routine1
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draw Segments B,C
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l #2,d5 ;Counter
    jsr LoopThrough ;Draws Segments B - C
    rts

;Drawing Segments for Number 2  
routine2
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draws Segments A,B,D,E,G
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l (a0),a1  ;Loading in Segment A
    jsr (a1)        ;Drawing Segment A
    
    add.l #4,a0     ;Moving to Segment B
    move.l (a0),a1  ;Loading in Segment B
    jsr (a1)        ;Drawing Segment B
    
    add.l #8,a0     ;Moving to Segment D
    move.l (a0),a1  ;Loading in Segment D
    jsr (a1)        ;Drawing Segment D
    
    add.l #4,a0     ;Moving to Segment E
    move.l (a0),a1  ;Loading in Segment E
    jsr (a1)        ;Drawing Segment E
    
    add.l #8,a0     ;Moving to Segment G
    move.l (a0),a1  ;Loading in Segment G
    jsr (a1)        ;Drawing Segment G
    rts

;Drawing Segments for Number 3 
routine3
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draws Segments A,B,C,D,G
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l (a0),a1 ;Loading in Segment A
    jsr (a1)        ;Drawing Segment A
    move.l #3,d5 ;Counter
    jsr LoopThrough ;Draws Segments B - D
    add.l #12,a0    ;Moving to Segment G
    move.l (a0),a1  ;Loading in Segment G
    jsr (a1)        ;Drawing Segment G
    rts

;Drawing Segments for Number 4
routine4
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draws Segments B,C,F,G
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l #2,d5 ;Counter
    jsr LoopThrough ;Draws Segments B - C
    add.l #8,a0     ;Skipping Segment D - E
    move.l #2,d5 ;Counter
    jsr LoopThrough ;Draws Segments F - G
    rts

;Drawing Segments for Number 5 
routine5
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draws Segments A,C,D,F,G
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l (a0),a1 ; Loading in Segment A
    jsr (a1)        ;Drawing Segment A
    add.l #4,a0     ;Skip B
    move.l #2,d5 ;Counter
    jsr LoopThrough ;Draws Segments C - D
    add.l #4,a0     ;Skip E
    move.l #2,d5 ;Counter
    jsr LoopThrough ;Draws Segments F - G
    rts

;Drawing Segments for Number 6
routine6
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draws Segments A,C,D,E,F,G
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l (a0),a1 ; Loading in Segment A
    jsr (a1)        ;Drawing Segment A
    add.l #4,a0     ;Skip B
    move.l #5,d5 ;Counter
    jsr LoopThrough ;Draws Segments C - G
    rts

;Drawing Segments for Number 7   
routine7
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draws Segments A,B,C
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers    
    move.l (a0),a1 ; Loading in Segment A
    jsr (a1)        ;Drawing Segment A
    move.l #2,d5 ;Counter
    jsr LoopThrough ;Draws Segments B - C
    rts
    
;Drawing Segments for Number 8   
routine8
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draw Segments A,B,C,D,E,F,G
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l (a0),a1 ; Loading in Segment A
    jsr (a1)        ;Drawing Segment A
    move.l #6,d5 ;Counter
    jsr LoopThrough ;Draws Segments B - G
    rts

;Drawing Segments for Number 9    
routine9
    jsr DrawBehindSegment       ; Draw a Black Box behind Number
    ;Draw Segments A,B,C,F,G
    lea SegtmentRoutines,a0     ; Load in Segemnt Routines Function Pointers
    move.l (a0),a1  ; Loading in Segment A
    jsr (a1)        ; Drawing Segment A
    move.l #2,d5 ; Counter
    jsr LoopThrough ; Draws Segments B - C
    add.l #8,a0     ; Skip D - E
    move.l #2,d5 ; Counter
    jsr LoopThrough ; Draws Segments F - G
    rts
    
;Loops though Drawing Segments
LoopThrough:
    add.l #4,a0         ; Got to the next Function Address
    move.l (a0),a1      ; Load said address into a Register
    jsr (a1)            ; Drawing Segment
    subi.l #1,d5        ; Subtract 1 from Counter
    bne LoopThrough     ; If Counter isn't 0, keep looping
    rts
    
    
;Draws a black box behind number    
DrawBehindSegment
    move.l	#BLACK,d1   ; Sets the  Color

    jsr DrawCommands    ; Sets the TrapCodes for the Pen/Fill

    move.b	#DRAW_SQUARE_COMMAND,d0 ; Sets the TrapCode to draw Square

    move.l d6,d1        ; Sets the X POS
    
    move.l d1,d3        ; Copies X POS
    addi.l #SEVENSEGSHIFTVALUE,d3   ; Adds Segment Spacing 
                                    ; to Right Side X POS
    
    move.l d7,d2                    ; Sets the Y POS
    
    move.l d2,d4                    ; Copies the Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4   ; Adds Segment Spacing to Bottom Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4   ; Adds Segment Spacing to Bottom Y POS
    
    trap	#15
    rts

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
