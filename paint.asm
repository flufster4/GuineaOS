[bits 32]

global paint_main

%include "headers/kernal.inc"
%include "headers/screen.inc"

paint_main:

    mov ah, 0x11
    call clrscrn

    mov word [es:cursorx], 160
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
    cmp edx, 79
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

cursorx: dw 0
bar: times 80 db ' '
ctrldown: db 0