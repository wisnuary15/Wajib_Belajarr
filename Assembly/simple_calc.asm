section .data
    prompt1 db 'Masukkan angka pertama: ', 0
    prompt2 db 'Masukkan angka kedua: ', 0
    result_msg db 'Hasil: ', 0
    newline db 0xA                 ; Karakter newline (baris baru)
    buffer db 10 dup(0)            ; Buffer untuk menyimpan input dari pengguna

section .bss
    num1 resd 1                    ; Tempat menyimpan angka pertama (4 bytes)
    num2 resd 1                    ; Tempat menyimpan angka kedua (4 bytes)

section .text
    global _start

_start:
    ; Prompt pertama
    mov eax, 4                     ; syscall number for sys_write
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, prompt1               ; pointer ke prompt1
    mov edx, 22                    ; panjang prompt1
    int 0x80                       ; panggil kernel

    ; Input angka pertama
    mov eax, 3                     ; syscall number for sys_read
    mov ebx, 0                     ; file descriptor 0 (stdin)
    mov ecx, buffer                ; buffer untuk menyimpan input
    mov edx, 10                    ; panjang buffer
    int 0x80                       ; panggil kernel

    ; Konversi string ke integer (angka pertama)
    call str2int
    mov [num1], eax                ; simpan hasil konversi di num1

    ; Prompt kedua
    mov eax, 4                     ; syscall number for sys_write
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, prompt2               ; pointer ke prompt2
    mov edx, 21                    ; panjang prompt2
    int 0x80                       ; panggil kernel

    ; Input angka kedua
    mov eax, 3                     ; syscall number for sys_read
    mov ebx, 0                     ; file descriptor 0 (stdin)
    mov ecx, buffer                ; buffer untuk menyimpan input
    mov edx, 10                    ; panjang buffer
    int 0x80                       ; panggil kernel

    ; Konversi string ke integer (angka kedua)
    call str2int
    mov [num2], eax                ; simpan hasil konversi di num2

    ; Penjumlahan
    mov eax, [num1]                ; muat angka pertama
    add eax, [num2]                ; tambahkan angka kedua

    ; Konversi hasil ke string dan cetak hasil
    call int2str
    mov ecx, result_msg            ; pointer ke result_msg
    mov edx, 7                     ; panjang result_msg
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov eax, 4                     ; syscall number for sys_write
    int 0x80                       ; panggil kernel

    ; Cetak hasil
    mov ecx, buffer                ; buffer yang berisi hasil
    mov edx, 10                    ; panjang buffer
    mov eax, 4                     ; syscall number for sys_write
    int 0x80                       ; panggil kernel

    ; Exit program
    mov eax, 1                     ; syscall number for sys_exit
    xor ebx, ebx                   ; exit code 0
    int 0x80                       ; panggil kernel

str2int:
    ; Mengubah string dalam buffer menjadi integer di EAX
    xor eax, eax                   ; clear register EAX
    xor ebx, ebx                   ; clear register EBX
    mov ecx, buffer                ; load address of buffer
.convert:
    mov bl, [ecx]                  ; load next character
    cmp bl, 0xA                    ; check for newline
    je .done                       ; if newline, end loop
    sub bl, '0'                    ; convert ASCII to integer
    imul eax, eax, 10              ; multiply current number by 10
    add eax, ebx                   ; add next digit
    inc ecx                        ; move to next character
    jmp .convert                   ; repeat loop
.done:
    ret

int2str:
    ; Mengubah nilai integer di EAX menjadi string dan disimpan di buffer
    mov ebx, 10                    ; divider untuk modulasi
    mov ecx, buffer + 9            ; pointer ke akhir buffer
    mov byte [ecx], 0              ; tambahkan null terminator
    dec ecx
.convert_loop:
    xor edx, edx                   ; clear register EDX
    div ebx                        ; bagi EAX dengan 10
    add dl, '0'                    ; tambahkan ASCII ke hasil
    mov [ecx], dl                  ; simpan hasil
    dec ecx                        ; pindah ke posisi berikutnya
    cmp eax, 0                     ; cek apakah selesai
    jne .convert_loop              ; ulangi jika belum selesai
    inc ecx                        ; adjust pointer ke hasil string
    ret
