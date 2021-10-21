*-----------------------------------------------------------
* Title      : Neo Bonk - Main Game Loop
* Written by : Trevor Pierre
* Date       : 10/18/2021
* Description: This is the main GameLoop for Neo Bonk.
             ; The Super Pre Game Loop will set up:
             ; The Window Size
             ; The Seed for the Random Number Generation
             ; Moving the Values in for the Game Screen BitMaps
             ; Loading in the Title Sequence Loop
             
             ; The Main Game Loop will
             ; Increase the counter for the acceleration and acclerate if need be
             ; Update the Enemey and Player Positions(POS)
             ; Redraw the Enemy and Player for this frame
             ; Check for Collisions
             ; Draw the Current Score
             ; Switch Buffers to display the correct frame
             ; Restart the Game Loop
             
        ; Neo Bonk - The Game
; Neo Bonk is a game where you're goal is to dodge being hit by
; blocks coming down from the top of the screen by moving
; left or right.
; Over time the blocks will get faster but max out at a velocity
; of 100-ish.
; These blocks also spawn at random points on the top of the screen.
; The longer you stay alive the more points you get(these also
; max out at 999).
; But if you get hit once, you're dead and will get a Game Over.
*-----------------------------------------------------------
;Regsiter Clearing
ALL_REG         REG     D1-D7/A0-A6
ALL_DATA        REG     D1-D7

;TRAPCODES
SET_OUTPUT_RESOLUTION_TRAP_CODE EQU     33
SET_PEN_COLOR_COMMAND   equ     80
SET_FILL_COLOR_COMMAND  equ     81
DRAW_PIXEL_TRAP_CODE    EQU     82
DRAW_SQUARE_COMMAND     equ     87
DRAW_LINE_COMMAND       equ     84
CLEAR_SCREEN_COMMAND    equ     11
CLEAR_SCREEN_MAGIC_VAL  equ     $FF00
DRAWING_MODE_TRAP_CODE	 equ	92
DOUBLE_BUFFERED_MODE	 equ	17
DOUBLE_BUFFERED_MODE_OFF	 equ	16
REPAINT_SCREEN_TRAP_CODE equ	94
GET_USER_INPUT_COMMAND  equ    19
MUSIC_LOAD_COMMAND      equ    74
MUSIC_CONTROLLER_COMMAND equ   77
TIME_COMMAND             equ    8
OPEN_FILE_COMMAND        equ    51
OPEN_FILE_COMMAND_OVERWRITE        equ    52
CLOSE_FILE_COMMAND       equ    56
READ_FILE_COMMAND       equ    53
WRITE_FILE_COMMAND       equ    54

;Enemy Info
BALL_WIDTH		         equ	20
BALL_HEIGHT		         equ	40
BALL_TOP_X_POSITION	     equ	75
BALL_VELOCITY		     equ	10


;Player Info
PLAYER_WIDTH            equ     20
PLAYER_HEIGHT           equ     20
PLAYER_TOP_Y_POS        equ     400
PLAYER_VELOCITY         equ     50

;Screen POS Data to check against
RIGHT_SIDE_OF_SCREEN	 equ	699
BOTTOM_OF_THE_SCREEN	 equ	430

;The POS of the Score Keeper Bitmap (Where it will Render)
XPOS_SCORE equ 100
YPOS_SCORE equ 600

;The POS of the Left Sidebar Bitmap (Where it will Render)
XPOS_LEFTBAR equ 0
YPOS_LEFTBAR equ 600

;The POS of the Right Sidebar Bitmap (Where it will Render)
XPOS_RIGHTBAR equ 700
YPOS_RIGHTBAR equ 600

;For Seven Segment LED, how much to shift the segments by before 
;they render so it all looks even
SEVENSEGSHIFTVALUE equ 15

;Colors for all Non Bitmap Renders
ENEMY_COLOR     equ $00ff2d67
PLAYER_COLOR   equ $001FF4BF
BLACK          equ $00000000
SEVEN_SEGMENT_COLOR equ $00FF0FF7

    

    ORG    $1000
START:  
    
    jsr SuperPreGameLoop ; Does all of the preloading and gets the
                         ; Title Screen Set up

mainGameLoop:
    
    movem.l D1-D6,-(sp) ; Moving Registers onto the Stack
    jsr CounterSpawn ; Increasing the speed if need be
    movem.l (sp)+,D1-D6 ; Restoring Registers from Stack
    
    ;Updating all the Objects
    
    movem.l ALL_DATA,-(sp) ; Moving Registers onto the Stack
    jsr UpdatePlayer ; Updates the Player POS
    movem.l (sp)+,ALL_DATA ; Restoring Registers from Stack
    
    
    movem.l ALL_REG,-(sp) ; Moving Registers onto the Stack
    jsr BatUpdateLoop ; Updates the Enemy POS
    movem.l (sp)+,ALL_REG ; Restoring Registers from Stack
    
    ;Drawing All Moving Objects
   
    movem.l ALL_REG,-(sp) ; Moving Registers onto the Stack
    jsr BatDrawLoop ; Draws Main Enemies
    movem.l (sp)+,ALL_REG ; Restoring Registers from Stack
    
    
    movem.l ALL_DATA,-(sp) ; Moving Registers onto the Stack
    jsr DrawPlayer ; Draws Player
    movem.l (sp)+,ALL_DATA ; Restoring Registers from Stack
 
    
    movem.l ALL_REG,-(sp) ; Moving Registers onto the Stack
    jsr CollisionCheck ; Checks for Collision
    movem.l (sp)+,ALL_REG ; Restoring Registers from Stack

    
    movem.l ALL_REG,-(sp) ; Moving Registers onto the Stack
    jsr DrawingLEDs ; Drawing Score
    movem.l (sp)+,ALL_REG ; Restoring Registers from Stack
    
    
    jsr	swapBuffers ; Swapping buffers for the frame
    
    bra mainGameLoop ; Going back to the start of GameLoop
    


    
* Put variables and constants here

; Bitmaps
; These hold all the bitmaps used in the game
TitleScreenBitMap   INCBIN "Assets/TitleScreenBitMap.bmp" ; Title Screen BitMap
InstructionsBitMap  INCBIN "Assets/InstructionsFinal.bmp" ; Instruction Screen BitMap
GameOverBitMap      INCBIN "Assets/EndScreen.bmp"    ; Game Over Screen BitMap
SaveScoreBitMap      INCBIN "Assets/ScoreSaveScreen.bmp"    ; SaveScore Screen BitMap

; In Game BitMaps
BottomBitMap INCBIN "Assets/FinalBottomBitMap.bmp"        ; Bottom Score Section BitMap
StripesBitMap INCBIN "Assets/VerticalStripesTest1.bmp"    ; Vertical Bars BitMap

; This holds the positional data for the background bitmaps from the EQU
HoldingEquatesPOS dc.l 0, 0, 0, 0, 0, 0

; Arrays for Background BitMpas
; This holds the positional data for all of the In Game/Background Bitmaps
BitmapXStart dc.l 0, 0, 0 ; Bottom Left Starting X POS for Bitmaps
BitmapXStop dc.l 0, 0, 0  ; Bottom Right Ending X POS for Bitmaps
BitmapYStart dc.l 0, 0, 0 ; Bottom Starting Y POS for Bitmaps 
BitmapYStop dc.l 0, 0, 442 ; Top Ending Y POS for Bitmaps


; Counter Variables
; These help determine when to speed up and help keep the score for the
; Seven Segment LEDs
SpawnCounter ds.l 1
ScoreCounter ds.l 1
RealScore dc.l 0
RealScore2 dc.l 0
; This is lets the Seven Segment LEDs know if the game is over or not
; And what type of scores to display
; So that the score display can be shifted properly
IsGameOver dc.l 0

; For the Seven Segment LEDs to know if it is showing a saved score or not
IsSavedScore dc.l 0

; Player Variables
; These hold the player's positional data and its Velocity
PlayerXPos ds.l 1 ; Player X POS
PlayerYPos ds.l 1 ; Player Y POS
PlayerYCombined ds.l 1 ; Player Y POS + PLAYER_HEIGHT
PlayerVelocity ds.l 1 ; Player Velocity

; Enemy Arrays
; These hold the positional data for all the enemeies
BatLeftXPos dc.l 0, 0, 0, 0, 0, 0, 0 ; Left X POS of all Enemies
BatRightXPos dc.l 0, 0, 0, 0, 0, 0, 0 ; Left X POS + BALL_WIDTH of all Enemies
BatTopYPos dc.l 0, 0, 0, 0, 0, 0, 0 ; Top Y POS of all Enemies
BatBottomYPos dc.l 0, 0, 0, 0, 0, 0, 0 ; Top Y POS + BALL_HEIGHT of all Enemies

; This holds the enemy speed and is updated as needed
BatSpeed ds.l 1


; Function Pointers

; Function Pointer for Seven Segment LED's
; Points to the Number Routines, which are responsible for drawing
; a specific number
SevenSegLEDRountines dc.l routine0, routine1,routine2, routine3, routine4, routine5, routine6, routine7, routine8, routine9

; Pointers to the Segment Rounties, which are responsible for drawing
; a speicfic segment of the LED
SegtmentRoutines dc.l SegmentA, SegmentB, SegmentC, SegmentD, SegmentE, SegmentF, SegmentG


; Holds the Random Value generated by the Random Number Generator
RandomBatVariable  ds.l 1

;Score Saving Files
; This one is so that the file can be written to
ScoreFile dc.b 'Score.bin',0

; This one is so the values can be sorted to find the largest one (Maybe) 
ScoreArray INCBIN "Score.bin"

;Sounds used in the Game
MainMusic dc.b 'Assets/DelatruneTunes.wav',0 ; Main Song used in Game
Bonk       dc.b 'Assets/Bonk.wav',0          ; Death Sounds
Select     dc.b 'Assets/Select.wav',0        ; Game Start Selection Sounds




;Include Files

    ;Game Loop Prep and BitMap Loading
    
    ; Sets Up the Title & Instruction Screens
    ; Sets Windows Size
    ; Gets Seed for Random Number Generation
    INCLUDE "Files/PrePreGameLoop.x68"
    
    ; Loads in Background BitMaps, Starts Music
    ; Turns Double Buffer Mode on
    ; Sets Up Player and Enemies
    ; Starts Main Game Loop
    INCLUDE "Files/PreGameLoop.x68"
    
    ; Start Title Screen Loop
    ; Loads in Title Screen BitMap
    ; Loops Until the User Presses either 'A' or 'I'
    ; Gets User Input for above mentioned letters
    ; When 'A' is pressed plays the Select Sound and Loads in the
    ; Pre Game Loop
    ; When 'I' is pressed Loads the Instruction Page
    ; And holds a loop until the player hits 'A' to start the game
    ; Or they can hit 'I' forever and keep loading the Instructions
    ; Holds Clear Screen Method
    ; Holds Draw Loop to Draw a Bitmap for the entire Screen (800x600)
    INCLUDE "Files/TitleAndInstructLoading.x68"
    
    ; Starts the Game Over Screen Loop
    ; Loads in the Game Over Screen BitMap and Renders it
    ; Loops Until the User Presses either 'R' or 'E'
    ; Gets User Input for above mentioned letters
    ; When 'R' is pressed plays the Select Sound and Loads in the
    ; Game Loop After Resetting some Variables
    ; When 'E' is pressed it will Load in the Save Score Screen BitMap
    INCLUDE "Files/GameOverAndRestart.x68"
    
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
    INCLUDE "Files/DrawingBackgroundBitMaps.x68"
    
    ;Bat Generation and Movement
    
    ; Gets a Seed for Random Number Generation Based on the Time
    ; Generates a Random Number based on an Alogrithm in two ways
    ; Lower for numbers in between 100 - 255
    ; Higher for number in between 256 - 680
    ; These are the X POS for the Enemies
    ; If the Generated Number it Outside of this Range it's recalcuated
    INCLUDE "Files/RandomGen.x68"
    
    ; Sets Up the X/Y Positions for all Enemies
    ; All of their values are stored in variables and loaded in
    ; Via Address Registers
    ; The X Value is Randomly Generated 
    ; 4 Bats have the High Random Numbers (256-680)
    ; 3 Bats have the Low Random Numbers (100 - 255)
    INCLUDE "Files/BatSubroutinesSetUp.x68"
    
    ; Updates the Enemy Position Every Frame
    ; Adds Veclocity to their X and Y to move them Forward
    ; When they reach the bottom of the screen they respawn
    ; at the top in Random X POS
    ; They all have Equal Y POS
    ; Their X POS is determied by the Random Number Generation
    ; 4 Bats have the High Random Numbers (256-680)
    ; 3 Bats have the Low Random Numbers (100 - 255)
    INCLUDE "Files/BatSubroutinesUpdate.x68"
    
   ; Loads all of the Enemy X/Y POS Data
   ; Loops through and draws every Enemy
    INCLUDE "Files/BatSubroutinesDraw.x68"
    
    ;Player Generation and Movement
    
    ; Sets the Player X Pos
    ; Sets the Player Y Pos
    ; Sets the Player Velocity
    INCLUDE "Files/PlayerSetUp.x68"
    
    ; Updates the Player POS by adding Velocity to it
    ; This is depenedent on if the Player Presses 'A' or 'D'
    ; to move the Character.
    ; The Player can only move so far left and right before hitting
    ; The Max bounds.
    INCLUDE "Files/PlayerUpdate.x68"
    
    ; Sets Pen/Fill TrapCodes
    ; Draws Black Box Behind Player
    ; Draws Player
    INCLUDE "Files/PlayerDraw.x68"
    
    ;Score and Acceleration
    
    ; Increased the SpawnCounter and once it reachs 400
    ; The Enemy Velocity will increase.
    ; It will max out at 100 though as to not get too fast.
    INCLUDE "Files/Counter.x68"
    
    ; Stores all number Routines for the Seven Segment LED's
    ; When one is called it first:
    ; Draws a Black Square behind itself
    ; Then Loads the SegmentRoutine Function Pointer
    ; After that it jumps to the Segemnts it is required to draw for that number
    INCLUDE "Files/Routines.x68"
    
    ; Depending on what segment gets called it will
    ; Draw the Segment called at a given Position
    INCLUDE "Files/Segments.x68"
    
    ; Takes the Score
    ; Shifts it to Normalize the Value
    ; Draws the correct number in the correct digits place up to 999
    ; Handles Display Last Score and GameOver Score
    INCLUDE "Files/SevSegLEDs.x68"
    
    ;Collisions and Other Stuff
    
     ; Checks for Collisiosn with the Player and Enemies
     ; It First checks to see if they have a greater or equal Y value
     ; Then Checks to see it the Player's Left X is within Enemy Bounds
     ; Or If the Player's Right X is within Enemy Bounds
    ;If either are true the Game Over will Load in
    INCLUDE "Files/Collisions.x68"
    
    ; Resizes the Window for Game
    INCLUDE "Files/WindowSetUp.x68"
    
    ; Turning Double Buffer Mode On
    ; Swaping Buffers
    ; Turning Double Buffer Mode Off
    INCLUDE "Files/MiscCommands.x68"
    
    ; Plays the Main Music on Loop while the Player is alive
    ; Stops when the Player Dies
    ; Plays Bonk Effect when the Player gets hit
    ; Plays Select Effect whent the Player selects something(Play,Restart,Instructions,etc.)
    INCLUDE "Files/MusicLoop.x68"
    

    ;Score Stuff
    ; Opens the Score File using TrapCodes
    ; Write to the Score File using TrapCodes
    ; Closes the Score File using TrapCodes
    ; Reads from the Scroe File using TrapCodes
    INCLUDE "Files/ScoreSaving.x68"
    ; Displays the Save Score Screen using a DrawMax Loop
    ; Displays the Current Score and the Last Score
    ; Loops Until the user Press 'R' to restart the game
    INCLUDE "Files/SaveScoreScreen.x68"
    


    END    START        ; last line of source

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
