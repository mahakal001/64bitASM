all: main

main: main.o lib.o get_arg_count.o get_args.o getenv.o
	ld -o main main.o lib.o get_arg_count.o get_args.o getenv.o

main.o: main.asm 
	yasm -f elf64 -g dwarf2 main.asm

lib.o: lib.asm
	yasm -f elf64 -g dwarf2 lib.asm

get_arg_count.o: get_arg_count.asm
	yasm -f elf64 -g dwarf2 get_arg_count.asm

get_args.o: get_args.asm
	yasm -f elf64 -g dwarf2 get_args.asm

getenv.o: getenv.asm
	yasm -f elf64 -g dwarf2 getenv.asm
