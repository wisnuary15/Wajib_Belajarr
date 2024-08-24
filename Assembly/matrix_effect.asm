BITS 16

org 0x100

; Data Section
section .data
    chars db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+[]{}|;:,.<>?/~`'
    chars_len dw $ - chars

; Code Section
section .text

start:
    ; Setup mode teks 80x25 (mode 3)
    mov ah, 0x00
    mov al, 0x03
    int 0x10           ; BIOS video interrupt

main_loop:
    ; Dapatkan posisi acak
    call random_pos

    ; Dapatkan karakter acak
    call random_char

    ; Gambar karakter di posisi acak
    call draw_char

    ; Tunggu sebentar (delay)
    call delay

    ; Lompat kembali ke awal loop
    jmp main_loop

random_pos:
    ; Dapatkan posisi acak di layar
    mov ah, 0x02
    xor bh, bh             ; halaman layar 0

    ; Posisi acak untuk X (0-79)
    call random
    mov dl, al             ; simpan hasilnya di DL (sumbu X)

    ; Posisi acak untuk Y (0-24)
    call random
    and al, 0x18           ; batas maksimal 24
    mov dh, al             ; simpan hasilnya di DH (sumbu Y)

    ret

random_char:
    ; Pilih karakter acak dari array 'chars'
    call random
    mov ax, [chars_len]
    div byte [chars_len]
    mov al, [chars + dx]
    ret

draw_char:
    ; Tempatkan kursor pada posisi acak
    mov ah, 0x02
    int 0x10               ; BIOS video interrupt

    ; Cetak karakter acak
    mov ah, 0x0E
    mov al, [chars + dx]
    mov bl, 0x02           ; warna hijau terang
    int 0x10               ; BIOS video interrupt
    ret

random:
    ; Generator angka acak sederhana (Xorshift)
    mov ax, dx
    shl dx, 7
    xor dx, ax
    shr ax, 9
    xor dx, ax
    shl ax, 8
    xor dx, ax
    mov al, dl
    ret

delay:
    ; Membuat delay sederhana
    mov cx, 0xFFFF
delay_loop:
    loop delay_loop
    ret

times 510 - ($ - $$) db 0
dw 0xAA55
