[bits 32]

global readkey
global readchar

readkey:
    mov al, 0
    in al, 0x60
    ret

readchar:
    call readkey
    ret
