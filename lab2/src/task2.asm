; define constants
; DISPLAY_BUS is port to which cathodes of displays are connected
; DECODER_CS is decoder's chip select pin
; DECODER_ADDR decoder's (demultiplexer) address pins; in fact only P3.0 and P3.1 are used

DISPLAY_BUS     equ     P1
DECODER_CS      equ     P2.0
DECODER_ADDR    equ     P3

;-----------------------------start-----------------------------------
    mov     DISPLAY_BUS, #11111111b ; set all GPIO pins in P1 in order to turn off the display
    jmp     init

    ; interrupt handler
    org     0Bh                         ; write instruction to 0xB address (interrupt handler)

    clr     DECODER_CS                  ; turn off the decoder
    mov     DECODER_ADDR, #3            ; select active display with demultiplexer
    xrl     DISPLAY_BUS, #10000000b     ; use xor on display bus to change the most significant bit to make segment blinking
    setb    DECODER_CS                  ; turn on demultiplexer (ergo turn on display)

    mov     TL0, #0DFh                   ; restore timer
    mov     TH0, #0B1h

    reti
    
init:
; timer T0 configuration
    setb    TR0                 ; turn on T0 timer
    mov     TMOD, #00000001b    ; set mode 1, count internal clock cycles, do not react in external interrupts
    setb    ET0                 ; enable overflow interrupt
    setb    EA                  ; enable global interrupt

    mov     TH0, #0B1h
    mov     TL0, #0DFh           ; load timer with 0xFFFF - 20000 in order to set timer to 20 ms

    jmp     $