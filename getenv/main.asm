;asmsyntax=nasm ;while editing in vim,uncomment to get the color 

BITS 64         ;Telling assembler that it is 64bit code

section .data  ;this section contain the initialized data

     coder: db "-------------- By mahakal001, Live to Learn -------------------",0xa,0xa
     len0: equ $-coder

     disp_arg_count: db "Count of given argument: "
     len1: equ $-disp_arg_count

     disp_args: db "given cmd line args are: "
     len2: equ $-disp_args

     disp_env: db 0xa," *=*=*=*=*=*=*=*=*=* YOUR SEXY ENVIRONMENT IS *=*=*=*=*=*=*=*=*=*=*=*=*",0xa,0xa
     len3: equ $-disp_env

section  .bss
      ;This section is empty. 

                       ;Declaring various functions that can be called from external files.
EXTERN getenv
EXTERN count
EXTERN feedline
EXTERN write
EXTERN exit
EXTERN get_args


section  .text          ; Section containing  instructions to be executed.
global _start   
_start:

                         ; Building the stack frame.
 push rbp                ; As rbp=0,so pushing a null value on the stack.
 mov  rbp,rsp            ; Storing initial stack poiner in rbp.This points to base of stack.
 sub  rsp,32             ; Building space for the expected data(stack grow downward).

			 
 mov rsi,coder
 mov rdx,len0
 call write
                         ; Printing the prompt "Count of given argument" .
 mov rsi,disp_arg_count  ; Passing address of first char of string in rsi.
 mov rdx,len1            ; Passing length of string.
 call write              ; Calling write to print the string.

                         ; Calling function for printing the number of cmd argument received.
 call count              ; Function "count" is in get_args_count.asm ..call this.

                         ; Printing the prompt "Given cmd line args are".
 mov rsi,disp_args  
 mov rdx,len2
 call write
 mov r15,rdx             ; Reserving length of above string.Will be use to print args at proper margin.
 call feedline           ; Feed line with "\n".

 call get_args           ; Calling get_args to print the given cmd arguments.

                         ; Printing the prompt "your sexy env. is".
 mov rsi,disp_env
 mov rdx,len3
 call write

 call getenv              ; calling for display the environment variable

 call exit
