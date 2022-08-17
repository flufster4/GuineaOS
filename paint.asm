[bits 32]

global paint_main

%include "headers/kernal.inc"
%include "headers/screen.inc"

paint_main:

    mov ah, 0x11
    call clrscrn

    mov ah, 0xff
    mov al, ' '
    mov word [0xb8000+160*2], ax

    mov esi, bar
    mov ah, 0x77
    mov edx, 0
    mov ecx, 0
    mov ebx, 0xb8000
    call print
    mov esi, bar
    mov ebx, 0xb8000+160
    call print

    mov ah, 0x00
    mov al, ' '
    mov word [0xb8000+72], ax
    mov ah, 0x11
    mov word [0xb8000+74], ax
    mov ah, 0x22
    mov word [0xb8000+76], ax
    mov ah, 0x33
    mov word [0xb8000+78], ax
    mov ah, 0x44
    mov word [0xb8000+80], ax
    mov ah, 0x55
    mov word [0xb8000+82], ax
    mov ah, 0x66
    mov word [0xb8000+84], ax
    mov ah, 0x88
    mov word [0xb8000+86], ax
    mov ah, 0x99
    mov word [0xb8000+88], ax
    mov ah, 0xaa
    mov word [0xb8000+90], ax
    mov ah, 0xbb
    mov word [0xb8000+92], ax
    mov ah, 0xcc
    mov word [0xb8000+94], ax
    mov ah, 0xdd
    mov word [0xb8000+96], ax
    mov ah, 0xee
    mov word [0xb8000+98], ax
    mov ah, 0xff
    mov word [0xb8000+100], ax

    mov ah, 0x70
    mov al, '0'
    mov word [0xb8000+72+160], ax
    mov al, '1'
    mov word [0xb8000+74+160], ax
    mov al, '2'
    mov word [0xb8000+76+160], ax
    mov al, '3'
    mov word [0xb8000+78+160], ax
    mov al, '4'
    mov word [0xb8000+80+160], ax
    mov al, '5'
    mov word [0xb8000+82+160], ax
    mov al, '6'
    mov word [0xb8000+84+160], ax
    mov al, '7'
    mov word [0xb8000+86+160], ax
    mov al, '8'
    mov word [0xb8000+88+160], ax
    mov al, '9'
    mov word [0xb8000+90+160], ax
    mov al, 'a'
    mov word [0xb8000+92+160], ax
    mov al, 'b'
    mov word [0xb8000+94+160], ax
    mov al, 'c'
    mov word [0xb8000+96+160], ax
    mov al, 'd'
    mov word [0xb8000+98+160], ax
    mov al, 'e'
    mov word [0xb8000+100+160], ax

paint_loop:
         
    in al, 0x60
    cmp al, 0x4D
    je move_cursor_right
    cmp al, 0x4B
    je move_cursor_left
    cmp al, 0x48
    je move_cursor_up
    cmp al, 0x50
    je move_cursor_down
    cmp al, 0x01
    je _start
    cmp al, 0x1D
    je ctrld
    cmp al, 0x9D
    je ctrlu
    cmp al, 0x02


    cmp byte [ctrldown], 1
    je .ctrlkeys

    jmp paint_loop

.ctrlkeys: 
    cmp al, 0x2F
    je pastchar
    jmp paint_loop

ctrld:
    mov byte [ctrldown], 1
    jmp loop

ctrlu:
    mov byte [ctrldown], 0
    jmp loop

exit:
    jmp _start


move_cursor_right:
    movzx edx, word [es:cursorx]
    cmp edx, 1999
    je .wait
    mov ax, [ 0xb8000 + 160 * 25 ]
    mov word [ 0xB8000 + edx * 2 ], ax
    add edx, 1   
    mov ax, [ 0xb8000+edx*2 ]
    mov word [ 0xb8000 + 160 * 25 ], ax
    mov ah, 0xf0
    mov word [ 0xB8000 + edx * 2 ], ax
    mov [es:cursorx], edx
.wait:
    in al, 0x60
    cmp al, 0xCD
    je paint_loop
    jmp .wait

move_cursor_left:
    movzx edx, word [es:cursorx]  
    cmp edx, 0
    je .wait
    mov ax, [ 0xb8000 + 160 * 25 ]
    mov word [ 0xB8000 + edx * 2 ], ax
    sub edx, 1
    mov ax, [ 0xb8000+edx*2 ]
    mov word [ 0xb8000 + 160 * 25 ], ax
    mov ah, 0xf0
    mov word [ 0xB8000 + edx * 2 ], ax
    mov [es:cursorx], edx
.wait:
    in al, 0x60
    cmp al, 0xCB
    je paint_loop
    jmp .wait

move_cursor_up:
    movzx edx, word [es:cursorx]
    cmp edx, 239
    jle .wait
    mov ax, [ 0xb8000 + 160 * 25 ]
    mov word [ 0xB8000 + edx * 2 ], ax
    sub edx, 80
    mov ax, [ 0xb8000+edx*2 ]
    mov word [ 0xb8000 + 160 * 25 ], ax
    mov ah, 0xf0
    mov word [ 0xB8000 + edx * 2 ], ax
    mov [es:cursorx], edx
.wait:
    in al, 0x60
    cmp al, 0xC8
    je paint_loop
    jmp .wait
    

move_cursor_down:
    movzx edx, word [es:cursorx]
    cmp edx, 1920
    jge .wait
    mov ax, [ 0xb8000 + 160 * 25 ]
    mov word [ 0xB8000 + edx * 2 ], ax
    add edx, 80
    mov ax, [ 0xb8000+edx*2 ]
    mov word [ 0xb8000 + 160 * 25 ], ax
    mov ah, 0xf0
    mov word [ 0xB8000 + edx * 2 ], ax
    mov [es:cursorx], edx
.wait:
    in al, 0x60
    cmp al, 0xD0
    je paint_loop
    jmp .wait

pastchar:
    movzx edx, word [es:cursorx]
    mov ax, [0xb8000+2+(160*25)]
    mov [0xb8000+160*25], ax
    mov ah, 0xf0
    mov [0xb8000+edx*2], ax
    jmp paint_loop

cursorx: dw 160
bar: times 80 db ' '
ctrldown: db 0