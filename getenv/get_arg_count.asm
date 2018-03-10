;asmsyntax=nasm ; Uncomment while editing in vim for coloring environment.
BITS 64         ; Hey assembler,This is 64 bit code.

GLOBAL count    ; Be ready,count is expected to be called by external file.

EXTERN strToNum ; Hey assembler,These are external function and can be called by this file.
EXTERN feedline 

section .text

;For count function,we need the pointer to base of stack which is stored in the regster rbp.
count:        
    mov rsi,rbp    ; Mov rbp in rsi.
    add rsi,8      ; Adding 8 to get the address where 'argument count' is stored.
    mov rax,[rsi]  ; Derefernce the pointer in rsi to get the count.
    call strToNum  ; Call strToNum for printing our number correctly.
    call feedline  ; Feed the line with newline char.
    ret            ; Return.

