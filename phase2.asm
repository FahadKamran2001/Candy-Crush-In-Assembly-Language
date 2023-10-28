.MODEL SMALL
.STACK 1024h
											;FAHAD KAMRAN	20I-0983	CS-B
											;COAL PROJECT
.DATA
;file vars
fname db 'TEXTFILE.txt',0
fhandle dw 0
buffer db 500 dup('$')


randNum db 0
; var for displayTiles
arrCounter1 dw 0
arrCounter2 dw 0
tempCx dw 0
tempDx dw 0
temp2cx dw 0
temp2dx dw 0
; var for printing triangle
height db 0
count1 db 0
count2 db 0
tTemp1 dw ?
tTemp2 dw ?
last dw ?
;var for square
xaxis dw 160
counter1 dw 20



; Vars used for game levels
levelNum DB ?
levelArray DB 1,2,3,1,2,3,1
		   DB 1,2,3,1,2,3,1
		   DB 1,2,3,1,2,3,1
		   DB 1,2,3,1,2,3,1
		   DB 1,2,3,1,2,3,1
		   DB 1,2,3,1,2,3,1



; Vars for drawLevel
rowIter DB ?		     
colIter DB ?		     
temp DB ?
loopCounter DB ?	            

; Vars for drawSquare 
drawSquareClr DB 9
drawSquareRow DW 0
drawSquareCol DW 0
drawSquareSize DW 32

; Vars for drawString
drawStrRow DB ?
drawStrCol DB ? 
drawStrColor DB ?
 


; Vars for diplayMultiDigitNumber
quotient DB ?
remainder DB ?
displayNumCount DB ?
displayNumColor DB ? 
displayNumRow DB ?
displayNumCol DB ?

; Game vars
score DW 0
totalScore DW 0
moves DW 0

; Vars for displayInitialScreen
backgroundChar DB ?
msg db ".","$"
gameTitleCandy db "CANDY CRUSH","$"
enterNameMSG db "Enter Your Name: ","$"
instructionTitleMSG db "INSTRUCTIONS","$"
instruction1MSG db "1. There are limited moves displayed on the top of screen","$"
instruction2MSG db "2. Click and hold tile and move in direction of your choice","$"
instruction3MSG db "3. 3 in a row results in a crush either horizontal or verticle","$"
instruction4MSG db "4. Use you mouse to move candies by selecting and dragging","$"
instruction5MSG db "5. Bomb clears all the candies in screen","$"
instruction6MSG db "6. Bomb awards 20 points","$"
instruction7MSG db "7. Crushing groups of 3 awards 3 points","$"

playerName db 20 DUP(?)
squareLength dw ?	; x-axis
squareWidth dw ?	; y-axis
initialSquarePixels dw ?

;Strings
userName DB "Name:","$"
userMoves DB "Moves:","$"
userScore DB "Score:","$"
levelScoreMSG DB "Your score for this level is", "$"
thankYouMSG DB "Thank you for playing!", "$"
endScoreMSG DB "Your final score is", "$"
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;<<< MAIN >>>;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
.CODE
main proc
  
    mov AX, @data
    mov DS, AX
	
	call oneSecDelay			;one second delay before showing starting screen
	call displayInitialScreen	; Ask player name and starting level number
	call oneSecDelay 			;add a 1 second delay between transition from main screen to instruction page
	call drawInstructions
	call oneSecDelay
	call oneSecDelay
	call oneSecDelay
	call oneSecDelay
	call oneSecDelay
	startGame::			
				
	
	cmp levelNum, 1
	je startLevelOne

	startLevelOne:
		call initializeLevelOne

		jmp beginGame				; If no combos exist, then the game begins

	beginGame:	
		call drawLevel 
		mov score, 0		; Resetting score accumulated during preliminary crushing
		mov moves, 0
	
		call displayGameInfo		; Display name, moves, score	
		call oneSecDelay
		call oneSecDelay
		call oneSecDelay
		call oneSecDelay
		call oneSecDelay
		call oneSecDelay
		
		mov score, 0
		call displayEndScreen
	                   
    exitMain::
    mov AH, 4Ch
    int 21h

main endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| initializeLevelOne |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initializes levelArray by populating each index with a random number between 1-5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initializeLevelOne proc

push SI
push CX
push BX
    	
mov SI, 0
mov CX, 100

fillLoop:  
    mov randNum, 1
    mov BL, randNum
    mov levelArray[SI], 1
    inc SI
    loop fillLoop      

mov ah, 0
mov al, 12h
int 10h
		   
pop BX
pop CX
pop SI
ret    
                                                                                                                                                                                                                                                                
initializeLevelOne endp                                                                                      



 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| drawBoardGrid |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws grid surrounding numbers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      
drawBoardGrid proc
	push AX
	push BX
	push CX
	push DX
	push SI
	
	
	mov drawSquareClr, 11
	mov drawSquareRow, 42
	mov drawSquareCol, 102
	mov drawSquareSize, 60
	mov loopCounter, 0
	mov DX, drawSquareSize

	mov SI, 0
	printLoop:
		cmp loopCounter, 7
		je finishPrint   
		
		mov CX, 7
		printRow:
			cmp levelArray[SI], 'B'
			je setBombTileColor
			cmp levelArray[SI], 'X'
			jne cont
			mov drawSquareClr, 0Fh	; Set tile color to white for blockers
			jmp cont
			
			setBombTileColor:
				mov drawSquareClr, 0Dh	; Set color for bomb
		
			cont:
				call drawSquare  
				add drawSquareCol, 60
				mov drawSquareClr, 11
				inc SI
				loop printRow
	 
		add drawSquareRow, 60
		mov drawSquareCol, 102
		inc loopCounter
		jmp printLoop
	 
	finishPrint:   
		cmp levelNum, 2
		jne finish
		mov si, 20
		mov di, 20
	
	finish:
		call displayTiles
		pop SI
		pop DX
		pop CX
		pop BX
		pop AX 
		ret   
          
drawBoardGrid endp 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| drawLevel |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Draws the levelArray on the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      
drawLevel proc 
   
   push SI
   
   mov AH, 0h            ; Set screen to 640x480
   mov AL, 12h
   int 10h     
   
    int 10h  
    call drawBoardGrid        ; Draws hollow squares around each number
    pop SI
	ret

drawLevel endp 

drawInstructions proc 
   
   push SI
   
   mov AH, 0h            ; Set screen to 640x480
   mov AL, 12h
   int 10h     
   
    int 10h  
    call instructionsPage        ; Draws instructions 
    pop SI
	ret

drawInstructions endp 

instructionsPage proc
		push AX
		push BX
		push CX
		push DX
		push SI
		
		mov dh, 3
		mov dl, 32
		mov si, 0
		
		;setting background colours
	mov ah, 0Bh
	mov bh, 00h
	mov bl, 03h	; 0001 blue , 0000 black, 0010 green, 0011 cyan, 1111 white
	int 10h

		
		printingInstructionTitle:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instructionTitleMSG[si]
		mov bl, 0Fh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp instructionTitleMSG[si], "$"
		jne printingInstructionTitle 
		
		;instruction1MSG
		mov dh, 8
		mov dl, 5
		mov si, 0
		printingInstructionOne:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instruction1MSG[si]
		mov bl, 0Bh
		mov cx, 1
		mov bh, 0
		int 10h	
		
		inc dl
		inc si
		cmp instruction1MSG[si], "$"
		jne printingInstructionOne 
		
		;instruction2MSG
		mov dh, 11
		mov dl, 5
		mov si, 0
		printingInstructionTwo:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instruction2MSG[si]
		mov bl, 0Bh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp instruction2MSG[si], "$"
		jne printingInstructionTwo
		
		;instruction3MSG
		mov dh, 14
		mov dl, 5
		mov si, 0
		printingInstructionThree:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instruction3MSG[si]
		mov bl, 0Bh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp instruction3MSG[si], "$"
		jne printingInstructionThree
		
		;instruction4MSG
		mov dh, 17
		mov dl, 5
		mov si, 0
		printingInstructionFour:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instruction4MSG[si]
		mov bl, 0Bh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp instruction4MSG[si], "$"
		jne printingInstructionFour
		
		;instruction5MSG
		mov dh, 20
		mov dl, 5
		mov si, 0
		printingInstructionFive:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instruction5MSG[si]
		mov bl, 0Bh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp instruction5MSG[si], "$"
		jne printingInstructionFive
		
		;instruction6MSG
		mov dh, 23
		mov dl, 5
		mov si, 0
		printingInstructionSix:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instruction6MSG[si]
		mov bl, 0Bh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp instruction6MSG[si], "$"
		jne printingInstructionSix
		
		;instruction7MSG
		mov dh, 26
		mov dl, 5
		mov si, 0
		printingInstructionSeven:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, instruction7MSG[si]
		mov bl, 0Bh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp instruction7MSG[si], "$"
		jne printingInstructionSeven
	
		pop SI
		pop DX
		pop CX
		pop BX
		pop AX 
		ret
instructionsPage endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| drawSquare |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a square on drawSquareRow, Col of size equal to drawSquareSize
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawSquare PROC

	push DX
	push CX
	push AX
	
	mov BX, 0
	mov AX, drawSquareSize              ; Length of line in pixels
	mov DX, drawSquareRow
	mov CX, drawSquareCol
	
	push CX
	push DX
	push AX
	call printHorizontalLine
	call printVerticalLine  
	
	pop AX
	pop DX
	add DX, AX
	dec DX
	push DX
	push AX
	call printHorizontalLine
	
	pop AX
	pop DX
	mov DX, drawSquareRow
	pop CX
	add CX, AX   
	dec CX
	push CX
	push DX
	push AX
	call printVerticalLine
	 
	pop AX
	pop DX 
	pop CX 
	pop AX
	pop CX 
	pop DX  
	ret
	
drawSquare ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| printHorizontalLine |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a horizontal line using values pushed on stack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printHorizontalLine PROC   
    push bp     
    mov bp, sp
   
    mov BX, [bp + 4]	; drawSquareSize
    mov DX, [bp + 6]
    mov CX, [bp + 8]
    
	push AX
	
	mov AX, 0
	
	printLine:
		cmp AX, BX
		je exitPrintLine
		
		push AX
		mov AH, 0Ch 
		mov BH, 0
		mov AL, drawSquareClr
		int 10h
		         
	    pop AX	         
		inc AX
		inc CX
		jmp printLine
	
	exitPrintLine:
		pop AX    
		pop bp
		ret 
		
printHorizontalLine ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| printVerticalLine |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a vertical line using values pushed on stack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printVerticalLine PROC
	push bp     
    mov bp, sp
   
    mov BX, [bp + 4]
    mov DX, [bp + 6]
    mov CX, [bp + 8]

	push AX
	
	mov AX, 0
	
	printLineA:
		cmp AX, BX
		je exitPrintLineA
		   
		push AX   
		mov AH, 0Ch
		mov BH, 0
		mov AL, drawSquareClr
		int 10h
		
		pop AX
		inc AX
		inc DX
		jmp printLineA
	
	exitPrintLineA:
		pop AX    
		pop bp
		ret
		
printVerticalLine ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| drawString |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a string on drawStrRow, Col where the string address is contained in SI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawString proc
	push AX
	push BX
	push DX
		
	mov DH, drawStrRow
	mov DL, drawStrCol
	
	drawLoop:
		mov AH, [SI]
		cmp AH, '$'
		je exit
		
		mov AH, 02h
		int 10h

		mov AH, 09h
		mov AL, [SI]
		mov BH, 0
		mov BL, drawStrColor 
		mov CX, 1
		int 10h
		
		inc DL
		inc SI
		jmp drawLoop
exit:
	pop DX
	pop BX
	pop AX
	ret
	
drawString endp  
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| oneSecDelay |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pauses program for one second
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
oneSecDelay proc
	push ax
	push cx
	push dx
	
	mov cx, 0Fh				; Add time delay of 1 sec
	mov dx, 4240h
	mov ah, 86h
	int 15h 		

	pop dx
	pop cx
	pop ax
	ret
oneSecDelay endp  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| diplayMultiDigitNumber |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Displays a multidigit number at displayNumRow, Col. Displayed number must be in AX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
diplayMultiDigitNumber proc
	push DX
	push CX
	mov displayNumCount, 0 
	mov BL, 10d
	mov dx, 0
	pushingNumberIntoStack:
		div BL
		mov remainder, AH
		mov quotient, AL
		mov AH, 0
		mov AL, remainder
		push AX					; pushing remainder to the stack
		inc displayNumCount
		mov AL, quotient		; moving the quotient value in the AL
		mov AH, 0
		cmp AL, 0				; checking if the all numbers are pushed into the stack
		jne pushingNumberIntoStack
		mov DH, displayNumRow
		mov DL, displayNumCol
		
		popingAndPrintingNumber:
		pop AX
		mov remainder, AL 	;temp. storing the value
		add remainder, 48
		mov AH, 02			;moving cursor to the position where char should be printed
		int 10h
		
		mov AH, 09
		mov AL, remainder
		mov BL, displayNumColor
		mov CX, 1
		mov BH, 0
		int 10h
		
		inc DL					;inc column
		dec displayNumCount
		cmp displayNumCount, 0
		ja popingAndPrintingNumber
	
	pop CX
	pop DX
	ret
diplayMultiDigitNumber endp	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| displayInitialScreen |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Displays the initial screen when game begins
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
displayInitialScreen proc
	push ax
	
	mov ah, 0		; Set video mode 640x480
	mov al, 12h
	int 10h
	;for number, use format 1000 xxxxb for text colour so that it blinks, 1 as the left most bit causes blinking
	call displayStringBorder	; Display the border of numbers around game board
	
	call displayTitleGame
	call drawSquareBorder
	call drawSquareBorder2
	call displayEnterName
	call inputPlayerName
	
	pop ax
	ret
displayInitialScreen endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| displayStringBorder |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Displays a border of numbers around the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
displayStringBorder proc
	push ax
	push bx
	push cx
	push dx
	push si

	mov dh, 0
	mov cx, 5
	top:
		push cx
		call drawHorizontalStringLine		; Prints a horizontal number line in rows 0-7
		inc dh
		pop cx
		loop top
		
	mov dh, 25
	mov cx, 5
	bottom:
		push cx
		call drawHorizontalStringLine		; Prints a horizontal number line in rows 7-23
		inc dh
		pop cx
		loop bottom	
	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax	
	ret
displayStringBorder endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| displayEndScreen |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Displays screen when the game ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayEndScreen proc
	push ax
	mov ah, 0		; Set video mode 640x480
	mov al, 12h
	int 10h
	
	call displayStringBorder	; Display the border of numbers around game board
	call drawSquareBorder
	
	mov drawStrCol, 27			; "Thank you for playing"
	mov drawStrRow, 13
	mov drawStrColor, 0Eh
	lea SI, thankYouMSG
	call drawString 
	
	mov drawStrRow, 14			; "Your final score is"
	mov drawStrCol, 26
	mov drawStrColor, 0Eh
	lea SI, endScoreMSG
	call drawString
	
	mov displayNumCol, 46		; Display the score
	mov displayNumRow, 14
	mov displayNumColor, 0Eh
	add ax, score
	mov ax, totalScore
	
	call diplayMultiDigitNumber
	jmp exitMain
	
	pop ax
	ret
displayEndScreen endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| inputPlayerName |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Takes player name as input and stores it in playerName
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inputPlayerName proc
	push ax
	push dx
	mov dl, 43
	mov dh, 20
	mov ah, 02
	int 10h
	lea SI, playerName
	mov ah, 01h
	inputChar:
		int 21h
		mov [si], al
		inc si
		cmp al, 13
		jne inputChar
			
	pop dx
	pop ax
	ret	
inputPlayerName endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| displayEnterName |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Displays "Enter your name" in initial loading screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayEnterName proc
	push dx
	push ax
	push si
	push cx
	push bx
	
	mov dh, 20
	mov dl, 25
	mov si, 0
	
	printingEnterName:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, enterNameMSG[si]
		mov bl, 0Dh
		mov cx, 1
		mov bh, 0
		int 10h	
		
		inc dl
		inc si
		cmp enterNameMSG[si], "$"
		jne printingEnterName 	
	
	pop bx
	pop cx
	pop si
	pop ax
	pop dx
	
	ret
displayEnterName endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| printPlayerName |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Prints the name given by the player
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printPlayerName proc
	push dx
	push ax
	push si
	push cx
	push bx
	
	mov dh, 0
	mov dl, 6
	mov si, 0
	
	printingName:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, playerName[si]
		mov bl, 0Ch
		mov cx, 1
		mov bh, 0
		int 10h	
		
		inc dl
		inc si
		cmp playerName[si], 13
		jne printingName 	
		
	;loading file handlers
	mov dx, offset fname
	mov al, 1				
	mov ah, 3dh					
	int 21h
	mov fhandle, ax
	mov bx, ax
	;moving file pointer to the end
	mov cx, 0
	mov ah, 42h 			
	mov al, 02h					
	int 21h
	;writing
	mov bx, fhandle
	mov cx, 4
	mov dx, offset playerName
	mov ah, 40h		
	int 21h
	;closing of file
	mov ah, 3eh
	mov bx, fhandle
	int 21h

	
	pop bx
	pop cx
	pop si
	pop ax
	pop dx
	
	ret
printPlayerName endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| drawHorizontalNumberLine |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  ; Draw a horizontal line of random numbers at DH = Row
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawHorizontalStringLine proc
		
	push dx
	push si
	mov di, 0
	mov cx, 70
	mov DL, 0			  ; Line printed from first till last row
	print:
		mov AH, 02h		  ; Move cursor to tileRow, tileCol
		int 10h
		lea si, msg
		mov al, [si]
		mov backgroundChar, al
		mov al, 0
		lea ax, msg
		mov BH, 0		 	 	; Page number = 0
		mov BL, 4	     		; Seting color
		push cx
		mov CX, 11		  		; Display once
		mov AH, 9h				; Display character
		int 10h  
		;loop subprint
		pop cx
		inc dl
		
		loop print
	pop si
	pop dx	
	ret	
drawHorizontalStringLine endp




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| drawSquareBorder |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a border around the horizontal and vertical number borders used in screens(loading, initial, ending)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawSquareBorder proc
	push bx
	push dx
	push cx
	
	mov bx, 0
	mov cx, 130
	mov dx, 100
	topLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc cx
		inc bx
		cmp bx, 400
		jb topLine

	mov bx, 0
	mov cx, 130
	mov dx, 360
	bottomLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc cx
		inc bx
		cmp bx, 401
		jb bottomLine	
	
	mov bx, 0
	mov cx, 530
	mov dx, 100
	rightLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc dx
		inc bx
		cmp bx, 260
		jb rightLine	
		
	mov bx, 0
	mov cx, 130
	mov dx, 100
	leftLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc dx
		inc bx
		cmp bx, 260
		jb leftLine	
		
	pop cx
	pop dx
	pop bx
	ret
drawSquareBorder endp
drawSquareBorder2 proc
	push bx
	push dx
	push cx
	
	mov bx, 0
	mov cx, 128
	mov dx, 98
	topLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc cx
		inc bx
		cmp bx, 404
		jb topLine

	mov bx, 0
	mov cx, 128
	mov dx, 362
	bottomLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc cx
		inc bx
		cmp bx, 405
		jb bottomLine	
	
	mov bx, 0
	mov cx, 532
	mov dx, 98
	rightLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc dx
		inc bx
		cmp bx, 264
		jb rightLine	
		
	mov bx, 0
	mov cx, 128
	mov dx, 98
	leftLine:
		mov ah, 0Ch
		mov al, 0Bh
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc dx
		inc bx
		cmp bx, 264
		jb leftLine	
		
	pop cx
	pop dx
	pop bx
	ret
drawSquareBorder2 endp

displayTitleGame proc
	push dx
	push ax
	push si
	push cx
	push bx
	
	mov dh, 8
	mov dl, 33
	mov si, 0
	
	printingGameName:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, gameTitleCandy[si]
		mov bl, 10001100b
		mov cx, 1
		mov bh, 0
		int 10h	
		
		inc dh
		inc si
		cmp gameTitleCandy[si], "$"
		jne printingGameName 	
	
	pop bx
	pop cx
	pop si
	pop ax
	pop dx
	
	ret
displayTitleGame endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;| displayGameInfo |;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws strings at the top of the board
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
displayGameInfo proc
    
    push SI
    
    mov drawStrRow, 0
    mov drawStrCol, 0
    mov drawStrColor, 4
    lea SI, userName
    call drawString  

	call printPlayerName
	
    mov drawStrRow, 0			; Display moves string
    mov drawStrCol, 35 
    mov drawStrColor, 2
    lea SI, userMoves
    call drawString  
	
	mov ax, moves				; Displaying moves
	mov displayNumColor, 0Ah
	mov displayNumCol, 42
	mov displayNumRow, 0
	call diplayMultiDigitNumber
	
    mov drawStrRow, 0			; Displaying score string
    mov drawStrCol, 68
    mov drawStrColor, 3
    lea SI, userScore
    call drawString
	
	mov ax, score				; Displaying score
	mov displayNumColor, 0Bh
	mov displayNumCol, 75
	mov displayNumRow, 0
	call diplayMultiDigitNumber
	
    pop SI
    ret 

displayGameInfo endp 

displaySquareShape7 proc
	mov count1, 0
	mov count2, 0
	mov tTemp1, cx
	mov tTemp2, dx
	mov cx, tTemp1
	mov dx, tTemp2
	.while (count1 <= 50)
		.while (count2 <= 50)
			mov AH, 0ch
			mov BH, 0
			mov AL, 03h
			int 10h
			inc cx
			inc count2
		.endw
		mov count2, 0
		mov cx, tTemp1
		inc dx
		inc count1
	.endw
	
	ret
displaySquareShape7 endp

displaySquareShape6 proc
	mov count1, 0
	mov count2, 0
	mov tTemp1, cx
	mov tTemp2, dx
	mov cx, tTemp1
	mov dx, tTemp2
	.while (count1 <= 50)
		.while (count2 <= 50)
			mov AH, 0ch
			mov BH, 0
			mov AL, 0Ah
			int 10h
			inc cx
			inc count2
		.endw
		mov count2, 0
		mov cx, tTemp1
		inc dx
		inc count1
	.endw
	
	ret
displaySquareShape6 endp

displaySquareShape5 proc
	mov count1, 0
	mov count2, 0
	mov tTemp1, cx
	mov tTemp2, dx
	mov cx, tTemp1
	mov dx, tTemp2
	.while (count1 <= 50)
		.while (count2 <= 50)
			mov AH, 0ch
			mov BH, 0
			mov AL, 0Bh
			int 10h
			inc cx
			inc count2
		.endw
		mov count2, 0
		mov cx, tTemp1
		inc dx
		inc count1
	.endw
	
	ret
displaySquareShape5 endp

displayRectangleShape proc
	mov count1, 0
	mov count2, 0
	mov tTemp1, cx
	mov tTemp2, dx
	mov cx, tTemp1
	mov dx, tTemp2
	.while (count1 <= 30)
		.while (count2 <= 50)
			mov AH, 0ch
			mov BH, 0
			mov AL, 0Dh
			int 10h
			inc cx
			inc count2
		.endw
		mov count2, 0
		mov cx, tTemp1
		inc dx
		inc count1
	.endw
	mov ax, 0
	ret
displayRectangleShape endp

displayParallelogramShape proc
	mov count1, 0
	mov count2, 0
	add cx, 30
	mov tTemp1, cx
	add dx, 10
	mov tTemp2, dx
	mov cx, tTemp1
	mov dx, tTemp2
	.while (count1 <= 27)
	mov al, count1
		.while (count2 <= 20)
			mov AH, 0ch
			mov BH, 0
			mov AL, 0Eh
			int 10h
			inc cx
			inc count2
			inc al
		.endw
		mov count2, 0
		dec tTemp1
		mov cx, tTemp1
		inc dx
		inc count1
	.endw
	mov ax, 0
	;mov bx, 0
	ret
displayParallelogramShape endp

displayTriangleShape proc
	mov count1, 0
	mov count2, 0
	mov tTemp1, cx
	mov tTemp2, dx
	mov cx, tTemp1
	mov dx, tTemp2
	.while (count1 <= 50)
	mov al, count1
		.while (count2 <= al)
			mov AH, 0ch
			mov BH, 0
			mov AL, 09h
			int 10h
			inc cx
			inc count2
			mov al, count1
			inc al
		.endw
		mov count2, 0
		mov cx, tTemp1
		inc dx
		inc count1
	.endw
	mov ax, 0
	ret
displayTriangleShape endp

displaySquareShape proc
	mov count1, 0
	mov count2, 0
	mov tTemp1, cx
	mov tTemp2, dx
	mov cx, tTemp1
	mov dx, tTemp2
	.while (count1 <= 50)
		.while (count2 <= 50)
			mov AH, 0ch
			mov BH, 0
			mov AL, 0ch
			int 10h
			inc cx
			inc count2
		.endw
		mov count2, 0
		mov cx, tTemp1
		inc dx
		inc count1
	.endw
	
	ret
displaySquareShape endp

displayTiles proc
	mov arrcounter1, 0
	mov arrcounter2, 0
	mov tempCx, 106
	mov tempDx, 48
	Mov cx,tempCx
	Mov dx,tempDx
	Mov temp2cx,cx
	Mov temp2dx,dx

	.while arrcounter1 < 7

		.while arrcounter2 <7
			Mov temp2cx,cx
			Mov temp2dx,dx
			Call displaySquareShape
			Mov cx,temp2cx
			Mov dx, temp2dx
			Add cx,60
			Inc arrcounter2
		.endw
		Mov cx, tempcx
		Mov dx,tempdx
		Add dx,60
		Mov tempdx,dx
		Inc arrcounter1
	.endw

	mov arrcounter1, 0
	mov arrcounter2, 0
	mov tempCx, 106
	mov tempDx, 108
	Mov cx,tempCx
	Mov dx,tempDx
	Mov temp2cx,cx
	Mov temp2dx,dx

	.while arrcounter1 < 7

		.while arrcounter2 <7
			Mov temp2cx,cx
			Mov temp2dx,dx
			Call displayTriangleShape
			Mov cx,temp2cx
			Mov dx, temp2dx
			Add cx,60
			Inc arrcounter2
		.endw
		Mov cx, tempCx
		Mov dx,tempDx
		Add dx,60
		Mov tempdx,dx
		Inc arrcounter1
	.endw
	
	
	
	mov arrcounter1, 0
	mov arrcounter2, 0
	mov tempCx, 106
	mov tempDx, 168
	Mov cx,tempCx
	Mov dx,tempDx
	Mov temp2cx,cx
	Mov temp2dx,dx

	.while arrcounter1 < 7

		.while arrcounter2 <7
			Mov temp2cx,cx
			Mov temp2dx,dx
			Call displayParallelogramShape
			Mov cx,temp2cx
			Mov dx, temp2dx
			Add cx,60
			Inc arrcounter2
		.endw
		Mov cx, tempCx
		Mov dx,tempDx
		Add dx,60
		Mov tempDx,dx
		Inc arrcounter1
	.endw
	
	
	mov arrcounter1, 0
	mov arrcounter2, 0
	mov tempCx, 106
	mov tempDx, 238
	Mov cx,tempCx
	Mov dx,tempDx
	Mov temp2cx,cx
	Mov temp2dx,dx

	.while arrcounter1 < 7

		.while arrcounter2 <7
			Mov temp2cx,cx
			Mov temp2dx,dx
			Call displayRectangleShape
			Mov cx,temp2cx
			Mov dx, temp2dx
			Add cx,60
			Inc arrcounter2
		.endw
		Mov cx, tempCx
		Mov dx,tempDx
		Add dx,60
		Mov tempDx,dx
		Inc arrcounter1
	.endw
	
	mov arrcounter1, 0
	mov arrcounter2, 0
	mov tempCx, 106
	mov tempDx, 288
	Mov cx,tempCx
	Mov dx,tempDx
	Mov temp2cx,cx
	Mov temp2dx,dx

	.while arrcounter1 < 7

		.while arrcounter2 <7
			Mov temp2cx,cx
			Mov temp2dx,dx
			Call displaySquareShape5
			Mov cx,temp2cx
			Mov dx, temp2dx
			Add cx,60
			Inc arrcounter2
		.endw
		Mov cx, tempcx
		Mov dx,tempdx
		Add dx,60
		Mov tempdx,dx
		Inc arrcounter1
	.endw
	
	
	mov arrcounter1, 0
	mov arrcounter2, 0
	mov tempCx, 106
	mov tempDx, 348
	Mov cx,tempCx
	Mov dx,tempDx
	Mov temp2cx,cx
	Mov temp2dx,dx

	.while arrcounter1 < 7

		.while arrcounter2 <7
			Mov temp2cx,cx
			Mov temp2dx,dx
			Call displaySquareShape6
			Mov cx,temp2cx
			Mov dx, temp2dx
			Add cx,60
			Inc arrcounter2
		.endw
		Mov cx, tempCx
		Mov dx,tempDx
		Add dx,60
		Mov tempDx,dx
		Inc arrcounter1
	.endw
	
	
	mov arrcounter1, 0
	mov arrcounter2, 0
	mov tempCx, 106
	mov tempDx, 408
	Mov cx,tempCx
	Mov dx,tempDx
	Mov temp2cx,cx
	Mov temp2dx,dx

	.while arrcounter1 < 7

		.while arrcounter2 < 7
			Mov temp2cx,cx
			Mov temp2dx,dx
			Call displaySquareShape7
			Mov cx,temp2cx
			Mov dx, temp2dx
			Add cx,60
			Inc arrcounter2
		.endw
		Mov cx, tempCx
		Mov dx,tempDx
		Add dx,60
		Mov tempDx,dx
		Inc arrcounter1
	.endw
	mov ax, 0
	mov bx, 0
	mov cx, 0
	mov dx, 0
	ret
displayTiles endp

end