; define constants: 
; MATRIX_BUS is a port connected to the keyboard matrix's pins
; LED is the first LED from the LED bank

MATRIX_BUS  equ     P0
LED         equ     P1.0

    jmp     init    ; jump to the initialization

    ; interrupt handler
    org     013h         ; write instruction to 0xB address (interrupt handler)
    xrl     LED, #1     ; use xor on LED pin to change the bit's value to the opposite one
    reti                ; return to the infinite loop

init:
; global interrupt initialization
    setb    EA                      ; enable global interrupts
    setb    EX1                     ; enable INT1 interrupt
    setb    IT1                     ; set INT1 to work with falling edge of the input signal

    mov     MATRIX_BUS, #01110000B  ; clear all row bits in order to make keyboard working

    jmp     $                       ; infinite loop waiting for interrupt