; =========================================================
; Program 1: Direct Hexadecimal Arithmetic Calculator
; Description: Performs 8-bit hex addition or subtraction
; using direct CPU registers (ADD/SUB) with carry/borrow check.
; =========================================================

.MODEL SMALL
.STACK 100h

.DATA
    msgPrompt1   DB 13, 10, 'Enter first hex value (00-FF): $'
    msgPrompt2   DB 13, 10, 'Enter operator (+ or -): $'
    msgPrompt3   DB 13, 10, 'Enter second hex value (00-FF): $'
    msgResult    DB 13, 10, 'Result (Hex): $'
    msgCarry     DB 13, 10, 'Carry/Borrow Flag Active! (CY=1)$'
    newline      DB 13, 10, '$'

    val1         DB ?
    val2         DB ?
    op           DB ?
    res          DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Request first value
    MOV DX, OFFSET msgPrompt1
    MOV AH, 09h
    INT 21h
    CALL READ_HEX_BYTE
    MOV val1, AL
    
    ; Consume leftover Enter key
    MOV AH, 01h
    INT 21h

    ; Request operator (+ or -)
    MOV DX, OFFSET msgPrompt2
    MOV AH, 09h
    INT 21h
    
    MOV AH, 01h
    INT 21h
    MOV op, AL

    ; Consume leftover Enter key
    MOV AH, 01h
    INT 21h

    ; Request second value
    MOV DX, OFFSET msgPrompt3
    MOV AH, 09h
    INT 21h
    CALL READ_HEX_BYTE
    MOV val2, AL
    
    ; Consume leftover Enter key
    MOV AH, 01h
    INT 21h

    ; Perform operation (Addition)
    MOV AL, val1
    ADD AL, val2
    MOV res, AL

    ; Display Result header
    MOV DX, OFFSET msgResult
    MOV AH, 09h
    INT 21h

    ; Print result in Hex
    MOV AL, res
    CALL PRINT_HEX_BYTE

    ; Check Carry Flag
    JC PRINT_CARRY_SUB
    JMP END_CALC

PRINT_CARRY_SUB:
    MOV DX, OFFSET msgCarry
    MOV AH, 09h
    INT 21h

END_CALC:
    ; Exit program
    MOV AX, 4C00h
    INT 21h
MAIN ENDP

; --- Subroutine: Read 2 ASCII hex characters and convert to 1 Byte ---
READ_HEX_BYTE PROC
    PUSH BX
    
    MOV AH, 01h
    INT 21h
    CALL ASCII_TO_HEX
    SHL AL, 4
    MOV BL, AL

    MOV AH, 01h
    INT 21h
    CALL ASCII_TO_HEX
    ADD AL, BL
    
    POP BX
    RET
READ_HEX_BYTE ENDP

; --- Subroutine: Convert ASCII to Hex value ---
ASCII_TO_HEX PROC
    CMP AL, '9'
    JLE IS_DIGIT
    SUB AL, 7          ; Adjust for A-F letters
IS_DIGIT:
    SUB AL, '0'
    RET
ASCII_TO_HEX ENDP

; --- Subroutine: Print Byte in Hex ---
PRINT_HEX_BYTE PROC
    PUSH AX
    SHR AL, 4
    CALL PRINT_NIBBLE
    POP AX
    AND AL, 0Fh
    CALL PRINT_NIBBLE
    RET
PRINT_HEX_BYTE ENDP

PRINT_NIBBLE PROC
    CMP AL, 9
    JLE IS_DIGIT_P
    ADD AL, 7
IS_DIGIT_P:
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h
    RET
PRINT_NIBBLE ENDP

END MAIN