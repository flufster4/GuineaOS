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
    cmp al, 0x2A
    je shiftd
    cmp al, 0xAA
    je shiftu
    cmp al, 0x58
    je crash_screen
    
;    cmp al, 0x02
;    je paint_main

    cmp byte [ctrldown], 1
    je .ctrlkeys
    cmp byte [shiftdown], 1
    je .shiftkeys

    jmp loop

.ctrlkeys: 
    cmp al, 0x2E
    je copychar
    cmp al, 0x2F
    je pastchar
    jmp loop

.shiftkeys:
    jmp loop

ctrld:
    mov byte [ctrldown], 1
    jmp loop

ctrlu:
    mov byte [ctrldown], 0
    jmp loop

shiftd:
    mov byte [shiftdown], 1
    jmp loop

shiftu:
    mov byte [shiftdown], 0
    jmp loop

;causes RSOD
crash_screen:
    mov ah, 0x44
    call clrscrn

    mov esi, crash_info_text
    mov ah, 0x4f
    mov ebx, 0xb8000
    mov edx, 0
    mov ecx, 0
    call print

    mov esi, crash_subtitle_text
    mov ebx, 0xb8000+160
    mov edx, 0
    mov ecx, 0
    call print

    mov esi, crash_reason_text
    mov ebx, 0xb8000+160*3
    call print

    mov esi, CRASH_REASON_INTENT
    call print

    mov esi, crash_eax_text
    mov ebx, 0xb8000+160*5
    call print
    ;TODO: make eax print value

    mov esi, crash_ebx_text
    mov ebx, 0xb8000+160*6
    call print
    ;TODO: make ebx print value

    mov esi, crash_ecx_text
    mov ebx, 0xb8000+160*7
    call print
    ;TODO: make ecx print value

    mov esi, crash_edx_text
    mov ebx, 0xb8000+160*8
    call print
    ;TODO: make edx print value

    hlt

    welcome: db "Welcome to Guinea OS!",1,"Made by Markian V.",1,"Verson: 1.0 | Build: 300",1,1,"Cursor Time!",0
    paint: db "abcdefghijklmnopqrxtuvwxyz.,!",0x0D,0

    ctrldown: db 0
    shiftdown: db 0

    ;--------------------------------------
    ;       crash screen variables
    ;--------------------------------------

    crash_edx_text: db "edx: ",0
    crash_ebx_text: db "ebx: ",0
    crash_ecx_text: db "ecx: ",0
    crash_eax_text: db "eax: ",0

    crash_info_text: db "Guinea OS has experienced a catasrophic failure and was unable to recover.",0
    crash_subtitle_text: db "Please hard reset your computer.",0
    crash_reason_text: db "Crash reason: ",0
    
    CRASH_REASON_INTENT: db "Intended crash",0
    CRASH_REASON_KERNAL_CRASH: db "Kernal failure",0
    CRASH_REASON_SYS_CRASH: db "Critical system process died",0
    CRASH_REASON_OVERFLOW: db "Memory overflow",0
    CRASH_REASON_UNKNOWN: db "Unknown failure",0
    CRASH_REASON_DRIVER_FAILURE: db "Driver failure",0