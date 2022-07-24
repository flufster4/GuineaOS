[bits 32]

global paint_main

%include "headers/kernal.inc"
%include "headers/screen.inc"
%include "headers/cursor.inc"

paint_main:
exit:
    jmp _start