; :) DOES'NT MATTER HOW HARD I TRY TO MAKE MY CODE LOOK BEAUTIFUL , IT ALWAYS LACKS SOMETHING (:

;  asmsyntax=nasm 
; if you want to edit this file uncomment the above line and reopen the file in VIM 
; if VIM is installed completely, you should have colors and make sure the above line remains in
; top five line.

; *************************************************************************************************
; assembler used is : yasm 
; steps: 
;       $ yasm -f elf64 -g dwarf2 -l compare.asm                 ; assemble
;       $ ld -o compare compare.o                                ; link
;       $ ./compare                                              ; run
;
; ****************************************************************************************************


;====================  section containing initilized data
section .data

         a dq 1         ; reserve quad word= 8 bytes 
         b dq 1        ; //

          instruction: db " YOU are going to compare two numbers",0xa
          instlen: equ $-instruction

          enter1:      db "enter  numbe a > ",0xa
          enter1len:   equ $-enter1

          enter2:      db "enter  number b >",0xa
          enter2len:   equ $-enter2

	  eqlmsg:      db " both numbers are equal",0xa
	  eqllen       equ $-eqlmsg

	  lesmsg       db "a is less than b",0xa
	  leslen       equ $-lesmsg

	  elsemsg      db " a is greater than b",0xa
	  elselen      equ $-elsemsg

         ;=================  WRITE =========
         ;this code is like a funnction in c and is called with name write
             write:
	         xor rax,rax
	         inc rax
                 xor rdi,rdi
	         inc rdi
                 syscall
                 ret

        ;=========================END OF WRITE FUNCTION ===================

        ;========================= READ ================================
	              ;this function do some repeated work during read call
          read:
        	xor rax,rax
        	xor rdi,rdi
        	syscall
	        ret
        ; ================== exit ================
 	         exit:
              mov rax,0x3c
              mov rdi,0
              syscall
;============ == section containing uniniitiliazed data

  section .bss

;====================== lets put the program instruction
  section .text
  global  _start
  _start:

;=====giving instruction for working of program

             ;int write(1.instruction,instlen) 
  mov   rsi,instruction           ; address of string to print
  mov   rdx,instlen               ;the length of bytes to print
  call  write
;======== lets have the first number

             ;int write(1,enter1,enter1len) 
  mov  rsi,enter1                ; address of string to print
  mov  rdx,enter1len             ; the length of bytes to print
  call  write
            ;int read(0,a,4)

  mov   rsi,a                    ; address where the taken value is to be stored
  mov   rdx,4                    ; length of byte to read
  call  read

             ;int write(1,a,4)  ; watching if number has been taken successfully or not 
  mov  rsi,a                     ; address of string to print
  mov  rdx,4                     ; the length of bytes to print
  call  write

;======== lets have the second number

             ;int write(1,enter2,enter2len) 
  mov  rsi,enter2                ; address of string to print
  mov  rdx,enter2len             ; the length of bytes to print
  call write
           ;int read(0,b,4)
  mov  rsi,b                    ; address where the taken value is to be stored
  mov  rdx,4                    ; length of byte to read
  call read

             ;int write(1,b,4) 
  mov   rsi,b                     ; address of string to print
  mov   rdx,4                     ; the length of bytes to print
  call  write
             
;=================== compare call =============
  mov rax,[a]                   ; move the value at a to rax
  mov rbx,[b]                   ; move the value at b to rbx
  cmp rax,rbx                   ; compare
  je  equal                     ; if found equal ,jump to "equal"
  jl  less                      ; else if  a < b,jump to less
; else , execute following codes
  mov  rsi,elsemsg                            
  mov  rdx,elselen
  call write
  call exit

equal:                        ; get called if a = b 
     mov  rsi,eqlmsg
     mov  rdx,eqllen
     call write
     call exit

less:                        ; get called if a < b
    mov  rsi,lesmsg
    mov  rdx,leslen
    call write
    call exit
