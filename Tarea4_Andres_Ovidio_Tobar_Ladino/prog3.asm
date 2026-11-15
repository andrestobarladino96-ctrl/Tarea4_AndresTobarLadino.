; =========================================================
; Program 3: Automatic Progressive Counter in Base 16
; Description: Implements a loop structure (CX) to automatically
; display the hexadecimal sequence from 0h to Fh cleanly.
; =========================================================

.MODEL SMALL
.STACK 100h

.DATA
    msgHeader    DB 13, 10, 'Hexadecimal Counter (0h to Fh): $'
    newline      DB 13, 10, '$'
    space        DB ' $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display header
    MOV DX, OFFSET msgHeader
    MOV AH, 09h
    INT 21h

    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h

    ; Initialize counter for the loop (16 iterations: from 0 to 15)
    MOV CX, 16
    MOV BL, 0         ; BL will store the current counter value (from 0h to Fh)

PRINT_LOOP:
    MOV AL, BL        ; Copy current value to AL for printing
    CALL PRINT_NIBBLE ; Print the digit in hexadecimal format

    ; Print a space to visually separate numbers
    MOV DX, OFFSET space
    MOV AH, 09h
    INT 21h

    INC BL            ; Increment hexadecimal counter
    DEC CX            ; Decrement loop counter
    JZ END_PROGRAM    ; If CX reaches 0, exit the loop
    JMP PRINT_LOOP    ; Otherwise, continue the cycle

END_PROGRAM:
    ; Aesthetic final newline
    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h

    ; Proper and clean exit to DOS system
    MOV AX, 4C00h
    INT 21h
MAIN ENDP

; --- Subroutine: Print an individual digit (Nibble) in Hex ---
PRINT_NIBBLE PROC
    CMP AL, 9
    JLE IS_DIGIT_P
    ADD AL, 7         ; Adjustment for letters A through F
IS_DIGIT_P:
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h
    RET
PRINT_NIBBLE ENDP

END MAIN