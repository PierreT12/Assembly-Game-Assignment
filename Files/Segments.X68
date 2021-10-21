*-----------------------------------------------------------
* Title      : Neo Bonk - Segments
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Depending on what segment gets called it will
             ; Draw the Segment called at a given Position
*-----------------------------------------------------------
;Drawing Segment A
SegmentA

    jsr SetPenColor ;Setting the Pen Color
    
    ;Draws at the top from left to right
    ;Starting POS
    move.l d6,d1    ; Setting Start X POS
    
    move.l d7,d2    ; Setting Start Y POS
    
    ;Ending POS
    move.l d6,d3 ; Setting End X POS
    addi.l #SEVENSEGSHIFTVALUE,d3 ; Shift End X POS over
    
    move.l d7,d4 ; Setting End X POS
    
    jsr DrawSegment ;Draws Segment
    rts

;Drawing Segment B    
SegmentB
    jsr SetPenColor ;Setting the Pen Color
    
    ;Draws at the top from top right to right middle
    ;Starting POS
    move.l d6,d1 ; Setting Start X POS
    addi.l #SEVENSEGSHIFTVALUE,d1 ; Shift Start X POS over
    
    move.l d7,d2 ; Setting Start Y POS
    
    
    ;Ending POS
    move.l d6,d3 ; Setting End X POS
    addi.l #SEVENSEGSHIFTVALUE,d3 ; Shift End X POS over
    
    move.l d7,d4  ; Setting End Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over
    
    jsr DrawSegment ;Draws Segment
    rts
;Drawing Segment C    
SegmentC
    jsr SetPenColor ;Setting the Pen Color
    
    ;Draws from mid right to bottom right
    ;Starting POS
    move.l d6,d1 ; Setting Start X POS
    addi.l #SEVENSEGSHIFTVALUE,d1 ; Shift Start X POS over
    
    move.l d7,d2 ; Setting Start Y POS
    addi.l #SEVENSEGSHIFTVALUE,d2 ; Shift Start Y POS over
    
    ;Ending POS
    move.l d6,d3 ; Setting End X POS
    addi.l #SEVENSEGSHIFTVALUE,d3 ; Shift End X POS over
    
    move.l d7,d4  ; Setting End Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over

    jsr DrawSegment ;Draws Segment
    rts

;Drawing Segment D    
SegmentD

    jsr SetPenColor ;Setting the Pen Color
    
    ;Draws at the bottom from left to right
    ;Starting POS
    move.l d6,d1 ; Setting Start X POS
    
    move.l d7,d2 ; Setting Start Y POS
    addi.l #SEVENSEGSHIFTVALUE,d2 ; Shift Start Y POS over
    addi.l #SEVENSEGSHIFTVALUE,d2 ; Shift Start Y POS over
    
    ;Ending POS
    move.l d6,d3 ; Setting End X POS
    addi.l #SEVENSEGSHIFTVALUE,d3 ; Shift End X POS over
    
    move.l d7,d4  ; Setting End Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over
    
    jsr DrawSegment ;Draws Segment
    rts

;Drawing Segment E    
SegmentE
    jsr SetPenColor ;Setting the Pen Color
    
    ;Draws from mid left to bottom left
    ;Starting POS
    move.l d6,d1 ; Setting Start X POS
    
    move.l d7,d2 ; Setting Start Y POS
    addi.l #SEVENSEGSHIFTVALUE,d2 ; Shift Start Y POS over
    
    ;Ending POS
    move.l d6,d3 ; Setting End X POS
    
    move.l d7,d4  ; Setting End Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over

    jsr DrawSegment ;Draws Segment
    rts

;Drawing Segment F    
SegmentF
    jsr SetPenColor ;Setting the Pen Color
    
    ;Draws at the top from top left to left middle
    ;Starting POS
    move.l d6,d1 ; Setting Start X POS
    
    move.l d7,d2 ; Setting Start Y POS
    
    
    ;Ending POS
    move.l d6,d3 ; Setting End X POS
    
    move.l d7,d4 ; Setting End Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over
    
    jsr DrawSegment ;Draws Segment
    rts

;Drawing Segment G    
SegmentG
    jsr SetPenColor ;Setting the Pen Color
    
    ;Draws at the middle from left to right
    ;Starting POS
    move.l d6,d1 ; Setting Start X POS
    
    move.l d7,d2 ; Setting Start Y POS
    addi.l #SEVENSEGSHIFTVALUE,d2 ; Shift Start Y POS over
    
    ;Ending POS
    move.l d6,d3 ; Setting End X POS
    addi.l #SEVENSEGSHIFTVALUE,d3 ; Shift End X POS over
    
    move.l d7,d4 ; Setting End Y POS
    addi.l #SEVENSEGSHIFTVALUE,d4 ; Shift End Y POS over
    
    jsr DrawSegment ;Draws Segment
    rts




;Basic Set Up and Draw Commands   
SetPenColor 
    move.l #SEVEN_SEGMENT_COLOR,d1      ; Sets the color
    move.b	#SET_PEN_COLOR_COMMAND,d0   ; Sets the Pen Color TrapCode
	trap	#15
    rts

;Basic Draw Command    
DrawSegment
    move.l #DRAW_LINE_COMMAND,d0    ; Sets the Draw Line TrapCode
    trap #15
    rts

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
