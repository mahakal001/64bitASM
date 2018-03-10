BITS 64              ; Hey assembler,This is 64bit code

GLOBAL get_args      ; Hey assembler, get_args is available for its service to external function


; POINT TO BE NOTED: The function feedline is not called externally because it is in a loop
; so calling it externally will not be feasible/efficient.

section .data        
     newline: db 0xa    
     len: equ $-newline
     insert_space: db "                                                            ";  spaces

section .text
nop

get_args:
        mov rax,rbp     ; Get pointer to base of stack.
        add rax,16      ; Get the pointer to < array of pointers > of arguments strings.
        mov rcx,rax     ; Copy this pointer to rcx.

       .while:
             xor  r11,r11      ; Making r11 null so that it can be use for comparison against null pointer.
             cmp  [rcx],r11    ; Testing if referencing pointer is NULL or not.
	     je   .return      ; IF  it is NULL,return.
             mov  r9,rcx       ; ELSE, store our current pointer in register r9 and 
	     call .print       ;       print the argument it points to.
	     mov  rcx,r9       ; restore our pointer
             add  rcx,8        ; update pointer so that it can point to next arg string
             jmp  .while       ; loop

      .print:            ; we dont know the len of str we want to print... Here is my logic to do.
	  mov  r10,[rcx+8]     ; Get the address of next arg str that we will print in next loop.
          mov  r13,[rcx]       ; Get the address of current str that we have to print now
          sub  r10,r13         ; Subtract addrs &  get len. of current str (As args r stored in contiuous mem addr)
          cmp  r10,0           ; Compare the length with 0.
          jl  .last            ; If it is -ve => we are on last argument.So call .last to deal with it.
	  call .insert_spaces  ; Insert space to output to increase readablity.
	  mov rdx,r10          ; Get length of str to print in rdx.
	  mov rax,1            
	  mov rdi,1
	  mov rsi,r13          ; Get address of str in rsi
	  syscall              ; make call
	  call .feedline       ; feed  the line with '\n'
	  ret                  ; return to while loop

     .return:
          ret

     .feedline:
           mov  rax,1           ; the next five line puts a newline char '\n'
           mov  rdi,1           ; to fascilitate the command prompt ..
           mov  rsi,newline     ; you can comment them to see the difference...
           mov  rdx,len         ; if you are on command line
           syscall
           ret

     .last:        ; How to know the length of last argument string?...see bottom of this file
           mov r10,[rcx+16]     ; get address to next string in stack
           sub r10,r13          ; subtract this from last arg string's address to get its length
           call .insert_spaces  ; Readablity
           mov rax,1            
	   mov rdi,1
	   mov rsi,r13
	   mov rdx,r10
	   syscall
           call .feedline
           ret	   

     .insert_spaces:
          mov rsi,insert_space
          mov rdx,r15
	  mov rax,1
	  mov rdi,1
	  syscall 
	  ret

; HOW TO GET LENGTH OF LAST ARG STRING
; The state of value on stack at this instance is as
;    < 1.Adddr_to_last_arg > < 2.NULL VALUE > < 3.Addr_to_first_env_var >
;    Now subtracting 3 entity from 1 gives us the length of first arg.
;
;    *REMEMBER rcx contain address of some point on stack.At this address there can be direct values 
;              or addresses.Here,at address in rcx contain addresses to strings.So,
;	      rcx+16 : represents the address at stack while
;	      [rcx+16] : references to something  that is located at rcx+16 AND this something at
;	                 rcx+16 is  address.So,
;	      mov r10,[rcx+16] : mov this address to r10
