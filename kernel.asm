[bits 32]

[extern print]
[extern readkey]
section .text

global _start

_start:

    mov esi, welcome
    mov ah, 0x0f
    mov ebx, 0xb8000+50+160*9
    mov edx, 10
    mov ecx, 25
    call print

    mov esi, paint
    mov ah, 0x0f
    mov ebx, 0xb8000+6
    mov edx, 0
    mov ecx, 0
    call print

	pushf
	push eax
	push edx
 
	mov dx, 0x3D4
	mov al, 0xA
	out dx, al
 
	inc dx
	mov al, 0x20
	out dx, al
 
	pop edx
	pop eax
	popf

    mov word [0xB8000], 0xff20

    mov ah, 0x00

loop:

    ;user input
    call readkey
    cmp al, 0x1D
    je ctrld
    cmp al, 0x9D
    je ctrlu
    cmp al, 0x19
    je ester_egg
    cmp al, 0x4D
    je move_cursor_right
    cmp al, 0x4B
    je move_cursor_left
    cmp al, 0x48
    je move_cursor_up
    cmp al, 0x50
    je move_cursor_down

    cmp byte [ctrldown], 1
    je .ctrlkeys

    jmp loop

.ctrlkeys:
    cmp al, 0x20
    je ester_egg    
    cmp al, 0x2E
    je copychar
    cmp al, 0x2F
    je pastchar
    jmp loop

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

ctrld:
    mov byte [ctrldown], 1
    jmp loop
ctrlu:
    mov byte [ctrldown], 0
    jmp loop
ester_egg:
    inc ah
    mov esi, ester_egg_msg
    mov ebx, 0xb8000+160*24
    mov edx, 0
    mov ecx, 0
    call print
    mov esi, ester_egg_msg_build
    mov ebx, 0xb8000+160*11+94
    mov edx, 0
    mov ecx, 0
    call print
    jmp ester_egg

    welcome: db "&7Welcome to Guinea OS!",1,"Made by Markian V.",1,"Verson: 1.0 | Build: 300",1,1,"&15Cursor Time!",0
    ester_egg_msg: times 80 db " "
    ester_egg_msg_build: db "DISCO",0
    paint: db "abcdefghijklmnopqrxtuvwxyz.,!",0x0D,0

    cursorx: dw 0

    ctrldown: db 0
