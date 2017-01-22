;asmsyntax=nasm ;uncomment and reopen while editing in vim editor(the giant version)
BITS 64 
;========================== str_to_num.asm  =====================================
;this program print integer value on the screen
;Algorithm:
;         * Divide the number by 10
;         * Get the quotient and remainder of division 
;         * The quotient become num for next loop
;         * And add 48 to the remainder to get equivalent ascii code of that digit
;         * Push this code on the stack 
;         * Loop till all digits are processed
;         * now pop and print the digits one by one
;         * exit
;===============================================================================


section .data             ; Containing initialized data

     num   dq 9876     ; Integer to be tested
     ten   dq 10       
     rem   dq 0
     newline: db 0xa
     len: equ $-newline

section .text          ; instruction starts from here
global _start          ; telling linker the starting point
_start:              

xor rcx,rcx        ; initialising the loop counter
while:
    cmp qword [num],0  ; if number == 0  break out of the loop
    je  print          ; print the number 'num'  if whole digit has been processed
    mov rax, [num]    ; moving 'num' to rax for division
    xor rdx, rdx      ; rax:rdx is dividend for division and zero out unnecessary space
    idiv  qword [ten]    ; divide rax:rdx by 10

; The quotient is put into rax and remiander in rdx by default

    mov   [num],rax      ; moving quotient to num (for next loop) 
    add   rdx,48         ; addding 48 to remainder to have equ ascii code of that digit
    mov   [rem],rdx      ; storing the above obtained ascii code  in 'rem' 
    push  qword [rem]    ; pushing the ascii code on stack
    inc   rcx            ; incrementing the loop counter
    jmp   while          ; iterate

; Now, the register rcx has the count of digits in original 
; number 'num'
; And we have to make same number of pop operation to retrieve the original number
; Also since the stack is LIFO,so the pop operation will give digits
; in correct sequence

print:                   ; printing the number
   cmp  rcx,0           ; check if all numbers have been printed or not
   je   exit            ; if the number has been printed ,exit the loop
   mov  [num],rcx       ; the next syscall may affect rcx,so storing the ...
                        ; ... loop counter in 'num'.
   pop  qword [rem]     ; pop a quad word from stack into [rem]
   mov  rsi,rem         ; pass the address in rsi
   mov  rdx,8           ; number of bytes to be printed
   mov  rdi,1           ; code for STDOUT file descriptor
   mov  rax,1           ; code for write syscall
   syscall              ; make the call
   mov  rcx,[num]       ; restoring our rcx register
   dec  rcx             ; decrementing counter
   jmp  print           ; call print again
  
exit:
   mov  rax,1           ; the next five line puts a newline char '\n'
   mov  rdi,1           ; to fascilitate the command prompt ..
   mov  rsi,newline     ; you can uncomment them to see the difference...
   mov  rdx,len         ; if you are on command line
   syscall
   mov  rax,0x3c        ; code for exit syscall 
   mov  rsi,1           ; 1 => operation successfull 
   syscall              ; make the call
