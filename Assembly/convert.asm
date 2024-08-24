section .data
    num db 13               ; Angka desimal yang ingin dikonversi
    bin db 8 dup(0)         ; Tempat menyimpan hasil konversi biner
    newline db 0xA          ; Karakter newline untuk output

section .bss
    idx resb 1              ; Index untuk array bin

section .text
    global _start

_start:
    mov al, [num]           ; Memuat angka desimal ke register AL
    mov ecx, 8              ; Panjang biner (8 bit)
    mov edi, bin            ; Pointer ke array bin
    add edi, ecx            ; Pindah ke akhir array bin
    dec edi                 ; Pindah ke byte terakhir

convert:
    mov bl, al              ; Salin nilai ke register BL
    and bl, 1               ; Ambil bit terendah (least significant bit)
    add bl, '0'             ; Ubah menjadi karakter ASCII ('0' atau '1')
    mov [edi], bl           ; Simpan hasil ke array bin
    dec edi                 ; Pindah ke posisi array sebelumnya
    shr al, 1               ; Geser register AL ke kanan untuk memproses bit berikutnya
    loop convert            ; Ulangi sampai semua bit diproses

print:
    mov edx, 8              ; Panjang biner yang akan dicetak
    mov ecx, bin            ; Pointer ke array bin
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov eax, 4              ; Syscall untuk write
    int 0x80                ; Panggil kernel

    ; Cetak newline
    mov edx, 1              ; Panjang newline
    mov ecx, newline        ; Pointer ke karakter newline
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov eax, 4              ; Syscall untuk write
    int 0x80                ; Panggil kernel

exit:
    mov eax, 1              ; Syscall untuk exit
    xor ebx, ebx            ; Status kode 0
    int 0x80                ; Panggil kernel
