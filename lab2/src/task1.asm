; define constants
; DISPLAY_BUS is port to which cathodes of displays are connected
; DECODER_CS is decoder's chip select pin
; DECODER_ADDR decoder's (demultiplexer) address pins; in fact only P3.0 and P3.1 are used

DISPLAY_BUS     equ     P1
DECODER_CS      equ     P2.0
DECODER_ADDR    equ     P3

;-----------------------------start-----------------------------------
    mov     DISPLAY_BUS, #11111111b ; set all GPIO pins in P1 in order to turn off the display

    mov     R0, #2                  ; activate 3rd display
    mov     R1, #10010010b          ; set pins to turn on segments which will show digit 5
    lcall   show_digit              ; call function: R0 - active display; R1 - segments to display

    jmp     $                       ; infinite loop

; subroutine which turns on selected segments in selected display
show_digit:
    clr     DECODER_CS          ; turn off the decoder
    mov     DECODER_ADDR, R0    ; select active display with demultiplexer
    mov     DISPLAY_BUS, R1     ; set cathodes of display to turn on selected segments
    setb    DECODER_CS          ; turn on demultiplexer (ergo turn on display)

    ret                         ; return from function