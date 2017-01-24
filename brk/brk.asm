;asmsyntax=nasm     ;uncomment while editing
BITS 64

section .data      ;section containig initialized data

     ten: dq 10  ; var require for strToNum function
     rem: dq 0   ; require for strToNum

     current_brk:   dq 0  ; These var stores value of brk at diff instances
     initial_brk:   dq 0
     after_alloc:   dq 0
     after_dealloc: dq 0
     final_brk:     dq 0

    str1:  db "Current brk is at :" 
    str1len: equ $-str1

    str2: db "Program brk after allocating 2048 bytes of memory: "
    str2len: equ $-str2

    str3: db "Program brk after dealloc. 1024 bytes of memory: "
    str3len: equ $-str3

    str4: db  "Finally program brk is at:   "
    str4len: equ $-str4

    newline: db 0xa
    len: equ $-newline

section .bss
    num resq 1

section .text
global _start
_start:

    ; printing str1 string
 mov  rsi,str1         
 mov  rdx,str1len
 call write
   ; get initial brk and print it
 mov  rax,0xc           ; 0xc is code for brk syscall
 xor  rdi,rdi           ; passing invalid address , which ...
 syscall               ; return the current break addess in rax
 mov  [current_brk],rax ;moving address in currect_brk
 mov  [initial_brk],rax ;moving address in initial_brk
 call strToNum
 call feedline


   ; printing str2 string
 mov  rsi,str2    
 mov  rdx,str2len
 call write
   ; Allocating 2048 bytes memory and print new brk
 mov rdi,[current_brk]   ; passing current brk's address to rdi
 add rdi,2048            ; adding 2048 to current brk to set 
 mov rax,0xc             ; new brk address
 syscall                 ; equ. to brk(current_brk + 2048) 
 mov  [current_brk],rax
 call strToNum           ; printing the return address
 call feedline

    ;printing str3 string
 mov  rsi,str3
 mov  rdx,str3len
 call write
    ; Dealloacate 1024 bytes of memory and print the new brk  
 mov rax,[current_brk]
 sub rax,1024
 mov rdi,rax
 mov rax,0xc
 syscall
 call strToNum
 call feedline

     ; print str4 string
 mov  rsi,str4
 mov  rdx,str4len
 call write
      ; final address of brk()
 mov rdi,0
 mov rax,0xc
 syscall
 call strToNum
 call feedline

 call exit       ;terminate the program

;============= FUNCTIONS STARTS FROM HERE ===============
 strToNum:
    mov [num],rax
    xor  rcx,rcx        ; initialising the loop counter
    .while:
      cmp  qword [num],0  ; if number == 0  break out of the loop
      je   .print          ; print the number 'num'  if whole digit has been processed
      mov  rax, [num]    ; moving 'num' to rax for division
      xor  rdx, rdx      ; rax:rdx is dividend 4 division & 0 out unnecessary space
      idiv qword [ten]    ; divide rax:rdx by 10
      mov  [num],rax      ; moving quotient to num (for next loop) 
      add  rdx,48         ; addding 48 to remainder to have equ ascii code of that digit
      mov  [rem],rdx      ; storing the above obtained ascii code  in 'rem' 
      push qword [rem]    ; pushing the ascii code on stack
      inc  rcx            ; incrementing the loop counter
      jmp  .while          ; iterate

    .print:                   ; printing the number
      cmp  rcx,0           ; check if all numbers have been printed or not
      je   return        ; if the number has been printed ,exit the loop
      mov  [num],rcx       ; the next syscall may affect rcx,so storing the ...
      pop  qword [rem]     ; pop a quad word from stack into [rem]
      mov  rsi,rem         ; pass the address in rsi
      mov  rdx,8           ; number of bytes to be printed
      mov  rdi,1           ; code for STDOUT file descriptor
      mov  rax,1           ; code for write syscall
      syscall              ; make the call
      mov  rcx,[num]       ; restoring our rcx register
      dec  rcx             ; decrementing counter
      jmp  .print           ; call print again
              
    feedline:
      mov  rax,1           ; the next five line puts a newline char '\n'
      mov  rdi,1           ; to fascilitate the command prompt ..
      mov  rsi,newline     ; you can uncomment them to see the difference...
      mov  rdx,len         ; if you are on command line
      syscall
      ret

    write:
    mov rax,1
    mov rdi,1
    syscall
    ret

    return:
      ret

    exit:
      mov  rax,0x3c        ; code for exit syscall 
      mov  rsi,1           ; 1 => operation successfull 
      syscall              ; make the call

