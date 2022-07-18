[bits 32]

global move_cursor_down
global move_cursor_left
global move_cursor_right
global move_cursor_up
global pastchar
global copychar

[extern loop]

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
    je loop
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
    je loop
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
    je loop
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
    je loop
    jmp .wait

copychar:
    mov ax, [0xb8000+160*25]
    mov [0xb8000+2+(160*25)], ax
    jmp loop

pastchar:
    movzx edx, word [es:cursorx]
    mov ax, [0xb8000+2+(160*25)]
    mov [0xb8000+160*25], ax
    mov ah, 0xf0
    mov [0xb8000+edx*2], ax
    jmp loop

cursorx: dw 0