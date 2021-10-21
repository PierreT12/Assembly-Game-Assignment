*-----------------------------------------------------------
* Title      : Neo Bonk - Drawing Background BitMaps
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This File
             ; Shifts Equates into VariableArray HoldingEquatesPOS
             ; Puts Values from HoldingEquatesPOS into their respective places into BitMap X/Y Start/Stop
             ; Draws the Left Stripe, Right Stripe, and then the Bottom BitMap
             ; For each:
             ; Loads the BitMap into a Register
             ; Gets its Width, Height, and Start of Pixel Data
             ; Loads the Proper Start/Stop X/Y values from the BitMap Variables
             ; Draws the BitMap
             ; Incements to the Next one
             ; Exits Out Once its done
*-----------------------------------------------------------
; Puts Equates into HoldingEquatesPOS
ShiftingValuesIn

   lea HoldingEquatesPOS, a0        ; Loads in Holding Equates
    
    move.l #XPOS_LEFTBAR, (a0)      ; Puts XPOS of Left Stripe into it
    add.w #4,a0                     ; Moves to the Next Long
    move.l #YPOS_LEFTBAR, (a0)      ; Puts YPOS of Left Stripe into it
    add.w #4,a0                     ; Moves to the Next Long
    move.l #XPOS_RIGHTBAR, (a0)     ; Puts XPOS of Right Stripe into it
    add.w #4,a0                     ; Moves to the Next Long
    move.l #YPOS_RIGHTBAR, (a0)     ; Puts YPOS of Right Stripe into it
    add.w #4,a0                     ; Moves to the Next Long
    move.l #XPOS_SCORE, (a0)        ; Puts XPOS of Bottom BitMap into it
    add.w #4,a0                     ; Moves to the Next Long
    move.l #YPOS_SCORE, (a0)        ; Puts YPOS of Bottom BitMap into it

    rts



; Puts all values in HoldingEquatesPOS, into their respective places
LoadingBitMapVariable
    jsr RelaodData              ; Reloads the Addresses for BitMap Start/Stop X/Y
    lea HoldingEquatesPOS, a6   ; Loads in HoldingEquatesPOS into a register
    move.b #3,d0                ; Counter

VariableLoop:     
    move.l (a6),(a2)            ; Moves XPOS into BitmapXStart
    move.l (a6),d4              ; Moves XPOS into a register

    add.l d4,(a3)               ; Adds XPOs to BitmapXStop
    
    add.w #4,a6                 ; Shifts Over to the next set of Data in HoldingEquatesPOS
    
    move.l (a6),(a4)            ; Moves YPOS into BitmapYStart
    move.l (a6),d6              ; Moves YPOS into a Register

    jsr ShiftBitMapXYValues     ; Goes to the Next BitMap X/Y to Load in
    
    add.w #4,a6                 ; Does the same as above but only for HoldingEquatesPOS
    subi.l #1,d0                ; Subtract 1 from Counter
    bne VariableLoop            ; Keeps going if Counter is not equal to 0

    rts


;Reloads in the Data of the BitMap X/Y Start/Stop into Address Registers
RelaodData
    lea BitmapXStart,a2     ; Loads BitmapXStart into an Address Register
    lea BitmapXStop,a3      ; Loads BitmapXStop into an Address Register
    lea BitmapYStart,a4     ; Loads BitmapYStart into an Address Register
    lea BitmapYStop,a5      ; Loads BitmapYStop into an Address Register
    rts

;Calls each BitMap Loadin
LoadABunchofBitMaps
    jsr LoadLeftStripe      ; Loads in and Draws the Left Vertical Stripe
    
    jsr LoadRightStripe     ; Loads in and Draws the Right Vertical Stripe

    jsr LoadOrginalBitMap   ; Loads in and Draws the Bottom BitMap
    
    rts


;Loading and Drawing the Bottom BitMap
LoadOrginalBitMap
    lea BottomBitMap, a0 ; Loading BitMap into Address Register
    jsr GetBitMapValues  ; Getting data from BitMap File
     
    ;This doesn't like PreDrawLoop
    clr.l d1            ; Clears Register to prevent Data MixUp
    move.l d5,d6        ; Copies Height into another Register
    move.l (a4),d2      ; Moves BitmapYStart into Register
    move.l (a5),d5      ; Moves BitmapYStop into Regiser
    clr.l d1            ; Clears Register to prevent Data MixUp
    add.l (a2),d1       ; Add BitmapXStart to Register
    add.l (a3),d4       ; Add BitmapXStop to Register
    jsr DrawLoop        ; Draw the Bottom BitMap 
    jsr ShiftBitMapXYValues ; Shift the BitMap Start/Stop X/Y Values
    rts


LoadLeftStripe
    lea StripesBitMap, a0 ; Loading BitMap into Address Register
    jsr GetBitMapValues ; Getting data from BitMap File
    
    jsr RelaodData      ; Reloads the Address Registers since its the First Draw
    
    jsr PreDrawLoop     ;Got to predraw loop to set Registers
    
    rts


LoadRightStripe
    lea StripesBitMap, a0 ; Loading BitMap into Address Register
    jsr GetBitMapValues ; Getting data from BitMap File
    
    
    jsr PreDrawLoop     ;Got to predraw loop to set Registers
    
    rts


PreDrawLoop
    clr.l d1                  ; Clears Register to prevent Data MixUp
    move.l d5,d6              ; Copies Height into another Register
    move.l (a4),d2            ; Moves BitmapYStart into Register
    move.l (a5),d5            ; Moves BitmapYStop into Regiser
    clr.l d5                  ; Clears Register to prevent Data MixUp
    clr.l d1                  ; Clears Register to prevent Data MixUp
    add.l (a2),d1             ; Add BitmapXStart to Register
    add.l (a3),d4             ; Add BitmapXStop to Register
    jsr DrawLoop              ; Draw the Bottom BitMap 
    jsr ShiftBitMapXYValues   ; Shift the BitMap Start/Stop X/Y Values
    rts

; Calls to get Values from BitMap file
GetBitMapValues
    move.l a0,a1                ; Copies BitMap Address to another Register
    jsr GettingFullImageSize    ; Gets the full Width and Height
    jsr JumptoPixelData         ; Gets to the start of the pixel data
    rts

; Shifts Each Address Forward 1 Long
ShiftBitMapXYValues
    add.w #4,a2         ; Shifts BitmapXStart forward
    add.w #4,a3         ; Shifts BitmapXStop forward
    add.w #4,a4         ; Shifts BitmapYStart forward
    add.w #4,a5         ; Shifts BitmapYStop forward
    rts

; Gets the Full Width and Height of a Image
GettingFullImageSize
    add.w #18, a1   ; Added to the Address Register to get to the correct place
    move.w (a1),d4  ;Getting the Width 
    rol #8,d4       ;Making sure in the correct orientation
    add.w #4,a1                             
    move.w (a1),d5  ;Getting the Height
    rol #8,d5       ;Making sure in the correct orientation
    move.l a0,a1    ;Resseting this address
    rts

; Gets to the start of the Pixel Data
JumptoPixelData
    add.w #10,a1    ; Added to the Address Register to get to the correct place
    move.w (a1),d7  ; Moves Value of Address into Register
    rol #8, d7      ; Corrects the value
    move.l a0,a1    ; Reloading the Address
    add.w d7,a1     ; Moving to the actual start of the pixel data
    rts

; Gets the 32 bit color for a pixel
SetColor
    clr.l d1                            ; Clears Register to prevent Data MixUp
    move.b (a1)+,d1                     ; Gets First Color Value
    swap.w d1                           ; Swaps it to correct Endian
    move.b (a1)+,d1                     ; Gets Second Color Value
    rol #8,d1                           ; Swaps last to bytes
    move.b (a1)+,d1                     ; Shifts Forward and jolds the last Color Value
    move.b (a1)+,d3                     ; Holidng the opacity

    move.l #SET_PEN_COLOR_COMMAND, d0   ; Sets the Pen Color TrapCode
    trap #15
    rts  


; Draw Loop
; This Draw Loop draws to specifc parts of the screen
; From Left to Right, Bottom to Top
; It:
; Gets the Color
; Draws the Pixel
; Shifts X forward 1
; Checks to see if it's at the end of a row
; If not, Loop again
; If so, Reset X and Subtrat 1 from Y
; Checks to see if Y is equal to 0
; If not, Loop again
; If so, Exit the Draw Loop

DrawLoop
    movem.l D1-D5,-(sp)                 ; Moving Registers onto the Stack
    jsr SetColor                        ; Gets Color from Pixel Data and Sets It
    movem.l (sp)+,D1-D5                 ; Restoring Registers from Stack
    move.l  #DRAW_PIXEL_TRAP_CODE,d0    ; Sets Up Draw Pixel TrapCode
    trap #15                            ; Draw Pixel
    addi.w #1,d1                        ; Adds 1 to the X value
    cmp.w d4,d1                         ; Checks to see if its at the end of the row
    bne DrawLoop                        ; If not, Loop Back
    movem.l D2,-(sp)                    ; Moving Registers onto the Stack
    move.l (a2),d1                      ; If so, Reset X
    movem.l (sp)+,D2                    ; Moving Registers onto the Stack
    subi.w #1,d2                        ; Subtract 1 for Y
    cmp.l d5,d2                         ; See if Y is at 0
    trap #15
    bne DrawLoop                        ; If not, Keep Loop
    rts                                 ; If so, Exit Out
    






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
