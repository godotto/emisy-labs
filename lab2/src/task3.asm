; define constants
; DISPLAY_BUS is port to which cathodes of displays are connected
; DECODER_CS is decoder's chip select pin
; DECODER_ADDR decoder's (demultiplexer) address pins; in fact only P3.0 and P3.1 are used

DISPLAY_BUS     equ     P1
DECODER_CS      equ     P2.0
DECODER_ADDR    equ     P3

    jmp     init                ; jump to initialization of the timer

    ; interrupt handler
    org     0Bh                 ; write instruction to 0xB address (interrupt handler)

    mov     ACC, R0             ; read indicator of which display should be turned on
    jb      ACC.0, display0     ; go to display 0
    jb      ACC.1, display1     ; go to display 1
    jb      ACC.2, display2     ; go to display 2
    jb      ACC.3, display3     ; go to display 3

display0:
    mov     R0, #00000010b      ; set indicator for display 1
    
    mov     R1, #0              
    mov     R2, #11111001b
    lcall   show_digit          ; call show_digit to display number 1 on display 0
    
    mov     TL0, #0DFh          ; restore timer
    mov     TH0, #0B1h

    reti

display1:
    mov     R0, #00000100b      ; set indicator for display 2

    mov     R1, #1
    mov     R2, #11111000b      
    lcall   show_digit          ; call show_digit to display number 7 on display 1
    
    mov     TL0, #0DFh          ; restore timer
    mov     TH0, #0B1h

    reti

display2:
    mov     R0, #00001000b      ; set indicator for display 3

    mov     R1, #2
    mov     R2, #11111001b
    lcall   show_digit          ; call show_digit to display number 1 on display 2
    
    mov     TL0, #0DFh          ; restore timer
    mov     TH0, #0B1h

    reti

display3:
    mov     R0, #00000001b      ; set indicator for display 0

    mov     R1, #3
    mov     R2, #11000000b
    lcall   show_digit          ; call show_digit to display number 0 on display 3
    
    mov     TL0, #0DFh          ; restore timer
    mov     TH0, #0B1h

    reti

init:
; timer T0 configuration
    setb    TR0                 ; turn on T0 timer
    mov     TMOD, #00000001b    ; set mode 1, count internal clock cycles, do not react in external interrupts
    setb    ET0                 ; enable overflow interrupt
    setb    EA                  ; enable global interrupt

    mov     TH0, #0B1h
    mov     TL0, #0DFh          ; load timer with 0xFFFF - 20000 in order to set timer to 20 ms

    mov     R0, #00000001b      ; set indicator for display 0

    jmp     $

; subroutine which turns on selected segments in selected display
show_digit:
    clr     DECODER_CS          ; turn off the decoder
    mov     DECODER_ADDR, R1    ; select active display with demultiplexer
    mov     DISPLAY_BUS, R2     ; set cathodes of display to turn on selected segments
    setb    DECODER_CS          ; turn on demultiplexer (ergo turn on display)

    ret                         ; return from function