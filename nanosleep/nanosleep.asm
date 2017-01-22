;asmsyntax=nasm     ; uncomment while editing in vim for colors
;===================== nanosleep =======================
; This code implements nanosleep system call in assembly
; "man nanosleep" for more details
;=======================================================

BITS 64            ; telling yasm that this is a 64 bit code

section .data      ; This section contain initialized data
  timespec:        ; structure specifying the time format
    tv_sec  dq 0   ; seconds 
    tv_nsec dq 0   ; nano-seconds

section .text      ; program codes starts from here
global _start      ; execution to be start from here
_start:

;int nanosleep(const struct timespec *req, struct timespec *rem);

mov qword [tv_sec],5   ; setting seconds to 5
mov qword [tv_nsec],99 ; setting nano-seconds to 99
mov rax,35             ; syscall code for nanosleep
mov rdi,timespec       ; passing time structure to rdi
mov rsi,0              ; rem = NULL
syscall                ; make the call

    ;exit(EXIT_SUCCESS)
mov rax,0x3c      ; syscall code for exit
mov rdi,1         ; successfull
syscall
