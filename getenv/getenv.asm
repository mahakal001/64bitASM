 ;asmsyntax=nasm
;====== This code is quite similar to get_arg.asm .The only difference is the initial calculation which
;====== compute the location where first environment variable is stored .So actually a common file 
;====== can be used for env. and args..This commong code can then from main with suitable 
;======  location passed as argument.I have created diff files to keep things simple for us

BITS 64

GLOBAL getenv

section .data
       newline: db 0xa    ; new line feed
       len: equ $-newline

section .text

getenv:  ;our first task is to locate first environment variable.Details are at bottom
     
          mov   rax,rbp     ; copy base pointer to rax
          mov   r14,[rbp+8] ; copy count of arguments received by program in r14
          imul  r14,8       ; calculate no. of bytes used to store addresses of argument
          add   r14,24      ; 24 = (The first 16 byte + the 8 byte of null pointer at end of addr to args)
          add   rax,r14     ; add the consume bytes to base pointer to get pointer to environment 
          mov   rcx,rax     ; move this address to rcx
    .while:
          xor   r11,r11
          cmp   [rcx],r11
	  je    .return
          mov   r9,rcx
	  call  .print
	  mov   rcx,r9
          add   rcx,8
          jmp   .while
            
   .print:
	  mov  r10,[rcx+8]
          mov  r13,[rcx]
          sub  r10,r13
          cmp  r10,0
          jl   .last
	  mov  rdx,r10
	  mov  rax,1
	  mov  rdi,1
	  mov  rsi,r13
	  syscall
	  call .feedline
	  ret
     .return:
          ret
     .feedline:
          mov  rax,1           ; the next five line puts a newline char '\n'
          mov  rdi,1           ; to fascilitate the command prompt ..
          mov  rsi,newline     ; you can uncomment them to see the difference...
          mov  rdx,len         ; if you are on command line
          syscall
          ret
      .last:
           mov r10,[rcx+16]
           sub r10,r13
           mov rax,1
	   mov rdi,1
	   mov rsi,r13
	   mov rdx,r10
	   syscall
	   call .feedline
	   ret
	    
; ==============  Locating first env variable ===============================
; The layout of  stack on ubuntu x86-64 is
;
; * At rbp+8 contain a count of arguments received by the program
; * Starting from rbp+16 to rbp+16+8*(count_of_argument) contains addresses of arg strings.(Remember that
;   on 64 bit rbp+16 implies the location specified by address from rbp+16 through rbp+24 and so on.)
; * Then a NULL pointer pf 8 bytes marks the end of arg string.
; * Then we have environment variables .
; * so , after rbp+16+8*(count_of_argument)+8 = rbp+24+8*(count_of_argument) we have our env var.
;===============================================================================================
