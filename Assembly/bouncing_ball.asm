section .data
    ball db 'O'
    empty_space db ' '
    ball_x dw 40           ; posisi awal bola di sumbu X
    ball_y dw 12           ; posisi awal bola di sumbu Y
    direction_x db 1       ; arah gerak bola di sumbu X (1: kanan, -1: kiri)
    direction_y db 1       ; arah gerak bola di sumbu Y (1: bawah, -1: atas)

section .bss

section .text
    org 0x100              ; Program mulai dieksekusi pada alamat memori 0x100
    start:
        ; Setup mode teks 80x25 (mode 3)
        mov ah, 0x00
        mov al, 0x03
        int 0x10           ; BIOS video interrupt

    main_loop:
        ; Hapus bola dari posisi sebelumnya
        call clear_ball

        ; Update posisi bola
        call update_position

        ; Gambar bola di posisi baru
        call draw_ball

        ; Tunggu sebentar (delay)
        call delay

        ; Lompat kembali ke awal loop
        jmp main_loop

    update_position:
        ; Perbarui posisi X
        mov ax, [ball_x]
        add ax, [direction_x]
        ; Cek jika bola mengenai batas layar di sumbu X
        cmp ax, 0
        jl reverse_x_direction
        cmp ax, 79
        jg reverse_x_direction
        mov [ball_x], ax
        jmp update_y

    reverse_x_direction:
        neg byte [direction_x]
        jmp update_y

    update_y:
        ; Perbarui posisi Y
        mov ax, [ball_y]
        add ax, [direction_y]
        ; Cek jika bola mengenai batas layar di sumbu Y
        cmp ax, 0
        jl reverse_y_direction
        cmp ax, 24
        jg reverse_y_direction
        mov [ball_y], ax
        ret

    reverse_y_direction:
        neg byte [direction_y]
        ret

    draw_ball:
        ; Tempatkan kursor pada posisi bola
        mov ah, 0x02
        xor bh, bh         ; halaman layar 0
        mov dh, [ball_y]
        mov dl, [ball_x]
        int 0x10           ; BIOS video interrupt

        ; Cetak karakter bola
        mov ah, 0x09
        mov al, [ball]
        mov cx, 1          ; cetak 1 karakter
        int 0x10           ; BIOS video interrupt
        ret

    clear_ball:
        ; Tempatkan kursor pada posisi bola sebelumnya
        mov ah, 0x02
        xor bh, bh         ; halaman layar 0
        mov dh, [ball_y]
        mov dl, [ball_x]
        int 0x10           ; BIOS video interrupt

        ; Hapus karakter bola
        mov ah, 0x09
        mov al, [empty_space]
        mov cx, 1          ; hapus 1 karakter
        int 0x10           ; BIOS video interrupt
        ret

    delay:
        ; Membuat delay sederhana
        mov cx, 0xFFFF
    delay_loop:
        loop delay_loop
        ret
