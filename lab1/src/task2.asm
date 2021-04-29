; define constants: 
; LCD_BUS is LCD's data bus
; LCD_RS is LCD's R/S pin
; LCD_E is LCD's E pin

LCD_BUS     equ     P1
LCD_RS      equ     P3.0
LCD_E       equ     P3.1

    mov     R0, #20     ; initialization - wait for approx. 30 ms (or even slightly more)

initial_wait:
    lcall   long_delay          ; call function which waits for more than 1.53 ms
    djnz    R0, initial_wait    ; loop that will perform actions 10 times

    mov     LCD_BUS, #00111000B ; function set
    lcall   send_command
    lcall   short_delay         ; wait for more than 39 us

    mov     LCD_BUS, #00001110B ; turn display on
    lcall   send_command
    lcall   short_delay         ; wait for more than 39 us

    mov     LCD_BUS, #00000110B ; entry set mode
    lcall   send_command
    lcall   short_delay         ; wait for more than 39 us

    ; number printing
    mov     LCD_BUS, #10000100B ; set cursor on the 5th position in 1st line (address 0x4 in DDRAM)
    lcall   send_command
    lcall   short_delay         ; wait for more than 39 us

    mov     LCD_BUS, #'3'       ; write digit "3"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'0'       ; write digit "0"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    lcall   send_data           ; write digit "0"
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'1'       ; write digit "1"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'7'       ; write digit "7"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'1'       ; write digit "1"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    ; name printing
    mov     LCD_BUS, #11000001B ; set cursor on the 2nd position in 2nd line (address 0x41 in DDRAM)
    lcall   send_command
    lcall   short_delay         ; wait for more than 39 us

    mov     LCD_BUS, #'M'       ; write letter "M"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'a'       ; write letter "a"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'c'       ; write letter "c"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'i'       ; write letter "i"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'e'       ; write letter "e"
    lcall   send_data
    lcall   long_delay          ; wait for more than 1.53 ms

    mov     LCD_BUS, #'j'       ; write letter "j"
    lcall   send_data

    jmp     $                   ; stay in infinte loop

send_command:       ; send command from LCD's data bus
    clr     LCD_RS  ; set mode to command mode
    setb    LCD_E   ; get data from bus
    clr     LCD_E
    ret

send_data:          ; send character data from LCD's data bus
    setb    LCD_RS  ; set mode to write mode
    setb    LCD_E   ; get data from bus
    clr     LCD_E
    ret

long_delay:         ; wait for approx. 1.53 ms: (256 us * 2 + 1 us) * 3 + 2 us + 3 us + 1 us
    mov     R1, #3  

inner_loop_long_delay:
    mov     R2, #256
    djnz    R2, $                       ; loop that will perform actions 256 times

    djnz    R1, inner_loop_long_delay   ; loop that will perform actions 3 times
    ret

short_delay:            ; wait for approx. 39 us: 1 us + 18 us * 2 + 2 us
    mov     R0, #18
    djnz    R0, $       ; loop that will perform actions 18 times
    ret