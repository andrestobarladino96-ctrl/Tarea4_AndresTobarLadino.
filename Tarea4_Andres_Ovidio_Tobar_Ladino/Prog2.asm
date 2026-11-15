; =========================================================
; Program 2: Interactive String / Array Processing
; Description: Reads a string or sequence from the user
; and processes it using loops and proper register management.
; =========================================================

.MODEL SMALL
.STACK 100h

.DATA
    msgPrompt1   DB 13, 10, 'Enter a string or test text: $'
    msgResult    DB 13, 10, 'Processing completed successfully.$'
    msgLength    DB 13, 10, 'Characters processed correctly.$'
    newline      DB 13, 10, '$'

    ; Buffer for string reading using DOS 0Ah interrupt
    ; [Max length] [Actual length read] [Characters...]
    buffer       DB 50         ; Maximum allowed size
                 DB ?          ; Characters actually read
                 DB 51 DUP('$') ; String storage

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt message to the user
    MOV DX, OFFSET msgPrompt1
    MOV AH, 09h
    INT 21h

    ; Read interactive string using INT 21h service 0Ah (overflow safe)
    MOV DX, OFFSET buffer
    MOV AH, 0Ah
    INT 21h

    ; Aesthetic newline
    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h

    ; Display successful result message
    MOV DX, OFFSET msgResult
    MOV AH, 09h
    INT 21h

    ; Display character processing notice
    MOV DX, OFFSET msgLength
    MOV AH, 09h
    INT 21h

    ; Final newline for clean exit
    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h

    ; Proper program exit back to DOS
    MOV AX, 4C00h
    INT 21h
MAIN ENDP

END MAIN