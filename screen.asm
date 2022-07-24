[bits 32]

global print
global fill
global clrscrn

print:
    lodsb
    or al,al                        
    jz pd 
    cmp al, 1
    je .incy
    cmp al, '&'
    je .readcolor
    mov word [ebx], ax 
.incx:
    add ebx, 2
    jmp print
.incy:
    imul ebx, edx, 160
    lea ebx, [0xb8000 + ebx + ecx*2]
    inc edx
    jmp print
.readcolor:
    lodsb
    cmp al, '&'
    je .readcolorc
    cmp al, '0'
    je .rcb
    cmp al, '2'
    je .rcg
    cmp al, '3'
    je .rcdc
    cmp al, '4'
    je .rcdr
    cmp al, '5'
    je .rcdp
    cmp al, '6'
    je .rcgo
    cmp al, '7'
    je .rclg
    cmp al, '8'
    je .rcdg
    cmp al, '9'
    je .rclbl
    cmp al, '1'
    je .readcolornext
    jmp print

;next charecter
.readcolornext:
    lodsb
    cmp al, '0'
    je .rclgr
    cmp al, '1'
    je .rclc
    cmp al, '2'
    je .rclr
    cmp al, '3'
    je .rclp
    cmp al, '4'
    je .rcy
    cmp al, '5'
    je .rcw
    cmp al, '6'
    je .rcbl
    dec esi
    
    jmp print
.rcy:
    mov ah, 0x0e
    jmp print
.rcw:
    mov ah, 0x0f
    jmp print
.rclr:
    mov ah, 0x0c
    jmp print
.rclp:
    mov ah, 0x0d
    jmp print
.rcb:
    mov ah, 0x00
    jmp print
.rcbl:
    mov ah, 0x01
    jmp print
.rcg:
    mov ah, 0x02
    jmp print
.rcdc:
    mov ah, 0x03
    jmp print
.rcdr:
    mov ah, 0x04
    jmp print
.rcdp:
    mov ah, 0x05
    jmp print
.rcgo:
    mov ah, 0x06
    jmp print
.rclg:
    mov ah, 0x07
    jmp print
.rcdg:
    mov ah, 0x08
    jmp print
.rclbl:
    mov ah, 0x09
    jmp print
.rclgr:
    mov ah, 0x0a
    jmp print
.rclc:
    mov ah, 0x0b
    jmp print
.readcolorc:
    mov al, '&'
    jmp print
pd:
	ret

clrscrn:
    mov esi, fill
    mov ebx, 0xb8000
    mov edx, 0
    mov ecx,0
    call print
    ret

fill: times 2000 db " "