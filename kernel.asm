[bits 32]

%include "headers/kernal.asm.inc"
%include "headers/cursor.inc"
%include "headers/screen.inc"

section .text

_start:

    mov ah, 0x11
    mov al, ' '
    mov [0xb8000 + 160 * 25], ax

    mov word [es:cursorx], 0
    
    mov ah, 0x11
    call clrscrn
    
    mov esi, welcome
    mov ah, 0x1f
    mov ebx, 0xb8000+50+160*9
    mov edx, 10
    mov ecx, 25
    call print

    mov esi, paint
    mov ah, 0x1f
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
    cmp al, 0x4D
    je move_cursor_right
    cmp al, 0x4B
    je move_cursor_left
    cmp al, 0x48
    je move_cursor_up
    cmp al, 0x50
    je move_cursor_down
    cmp al, 0x02
    je paint_main

    cmp byte [ctrldown], 1
    je .ctrlkeys

    jmp loop

.ctrlkeys: 
    cmp al, 0x2E
    je copychar
    cmp al, 0x2F
    je pastchar
    jmp loop

ctrld:
    mov byte [ctrldown], 1
    jmp loop

ctrlu:
    mov byte [ctrldown], 0
    jmp loop

    welcome: db "Welcome to Guinea OS!",1,"Made by Markian V.",1,"Verson: 1.0 | Build: 300",1,1,"Cursor Time!",0
    paint: db "abcdefghijklmnopqrxtuvwxyz.,!",0x0D,0

    ctrldown: db 0
