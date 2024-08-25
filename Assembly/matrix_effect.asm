BITS 16

org 0x100

section .data
    chars db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+[]{}|;:,.<>?/~`'
    chars_len equ $ - chars

section .text

start:
    ; Set video mode 3 (80x25 color text mode)
    mov ah, 0x00
    mov al, 0x03
    int 0x10

main_loop:
    ; Get random X and Y position on the screen
    call random_pos

    ; Get random character from the list
    call random_char

    ; Draw the character on screen
    call draw_char

    ; Delay for a while
    call delay

    ; Loop indefinitely
    jmp main_loop

random_pos:
    ; Generate random position
    ; X position (0-79)
    call random
    and al, 79
    mov dh, al

    ; Y position (0-24)
    call random
    and al, 24
    mov dl, al

    ret

random_char:
    ; Get random character from chars array
    call random
    mov ah, 0
    div byte [chars_len]
    mov al, [chars + ax]
    ret

draw_char:
    ; Set cursor position
    mov ah, 0x02
    mov bh, 0
    mov dh, dh  ; Y position in DH
    mov dl, dl  ; X position in DL
    int 0x10

    ; Draw the character
    mov ah, 0x0E
    int 0x10
    ret

random:
    ; Simple random generator
    mov ax, dx
    shl ax, 7
    xor ax, dx
    shr dx, 9
    xor ax, dx
    shl dx, 8
    xor ax, dx
    mov al, ah
    ret

delay:
    ; Simple delay
    mov cx, 0xFFFF
delay_loop:
    loop delay_loop
    ret

times 510 - ($ - $$) db 0
dw 0xAA55
