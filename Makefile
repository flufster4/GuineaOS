build:
	echo compiling code...
	nasm "boot.asm" -f bin -o "bin/boot.bin"
	nasm "kernel.asm" -f elf -o "bin/kernel.o"
	nasm "zeroes.asm" -f bin -o "bin/zeroes.bin"
	nasm "string.asm" -f elf -o "bin/string.o"
	nasm "drivers/ps2keyboard.asm" -f elf -o "bin/ps2keyboard.o"
	nasm "cursor.asm" -f elf -o "bin/cursor.o"

	echo linking...
	i386-elf-ld -o "bin/full_kernel.bin" -Ttext 0x1000 "./bin/kernel.o" "./bin/string.o" "./bin/ps2keyboard.o" "./bin/cursor.o" --oformat binary 2>&1 | tee "./log/ld.log"
	cat "bin/boot.bin" "bin/full_kernel.bin" "bin/zeroes.bin"  > "bin/GuineaOS.bin"

	echo running...
	qemu-system-x86_64 -drive format=raw,file="bin/GuineaOS.bin",index=0,if=floppy,  -m 2048M, -serial mon:stdio 2>&1 | tee "./log/qemu.log"

debug:
	echo compiling code...
	nasm "boot.asm" -f bin -o "bin/boot.bin"
	nasm "kernel.asm" -f elf -o "bin/kernel.o"
	nasm "zeroes.asm" -f bin -o "bin/zeroes.bin"
	nasm "string.asm" -f elf -o "bin/string.o"
	nasm "drivers/ps2keyboard.asm" -f elf -o "bin/ps2keyboard.o"

	echo linking...
	i386-elf-ld -o "bin/full_kernel.bin" -Ttext 0x1000 "./bin/kernel.o" "./bin/string.o" "./bin/ps2keyboard.o" --oformat binary 2>&1 | tee "./log/ld.log"
	cat "bin/boot.bin" "bin/full_kernel.bin" "bin/zeroes.bin"  > "bin/GuineaOS.bin"

	echo running...
	qemu-system-x86_64 -drive format=raw,file="bin/GuineaOS.bin",index=0,if=floppy,  -m 124M, -gdb tcp:9000 2>&1 | tee "./log/qemu.log"
