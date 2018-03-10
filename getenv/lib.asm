; Coded by Mohit Kumar For more information check out github.com/mahakal001

BITS 64       ; telling assembler that this is 64 bit code 

;GLOBAL means that this file should expect that the function specified can be called by some external files.
GLOBAL write 
GLOBAL feedline
GLOBAL exit
GLOBAL strToNum

section .data
      ten   dq 10        ; These two will be used by the.  
      rem   dq 0         ; function strToNum.    

     newline: db 0xa     ; Will be used in the feedline.
     len: equ $-newline

section .bss
     num resq 1          ; declaring uninitialized var.

section .text

;============= FUNCTIONS STARTS FROM HERE ===============
 strToNum:
     mov  [num],rax  ; The caller func has passed the no. to print by storing it in rax.
     xor  rcx,rcx   ; Initialising the loop counter.

    .while:                ; The "." make label local for strToNum (not necessary).
      cmp   qword [num],0  ; If number == 0  break out of the loop.
      je    .print         ; Print the number 'num'  if whole digit has been processed.
      mov   rax,[num]      ; Moving 'num' to rax for division.
      xor   rdx,rdx        ; Rax:rdx is dividend 4 division & 0 out unnecessary space.
      idiv  qword [ten]    ; Divide rax:rdx by 10.
      mov   [num],rax      ; Moving quotient to num (for next loop). 
      add   rdx,48         ; Addd 48 to remainder to have equ ascii code of that digit.
      mov   [rem],rdx      ; Storing the above obtained ascii code  in 'rem'.
      push  qword [rem]    ; Pushing the ascii code on stack.
      inc   rcx            ; Incrementing the loop counter.
      jmp   .while         ; Iterate.

    .print:                ; The leading "." makes label local.
      cmp  rcx,0           ; Check if all numbers have been printed or not.
      je   return          ; If the number has been printed ,exit the loop.
      mov  [num],rcx       ; The next syscall may affect rcx,so storing the ...
      pop  qword [rem]     ; Pop a quad word from stack into [rem].
      mov  rsi,rem         ; Pass the address in rsi.
      mov  rdx,8           ; Number of bytes to be printed.
      mov  rdi,1           ; Code for STDOUT file descriptor.
      mov  rax,1           ; Code for write syscall.
      syscall              ; Make the call.
      mov  rcx,[num]       ; Restoring our rcx register.
      dec  rcx             ; Decrementing counter.
      jmp  .print          ; Call print again.

; ==  The above two procedure named .print and .while constitute the logic for function strToNum ===========
; The next functions are independent and can be used freely by anyfile 

feedline:                  ; Feed the line with newchar.
      mov  rax,1           ; The next five line puts a newline char '\n'.
      mov  rdi,1           ; To fascilitate the command prompt ..
      mov  rsi,newline     ; You can uncomment them to see the difference...
      mov  rdx,len         ; If you are on command line.
      syscall
      ret

write:                     ; Write will get its argument via rsi,rdx.
      mov rax,1
      mov rdi,1
      syscall
      ret

return:
      ret

exit:
      mov  rax,0x3c        ; Code for exit syscall.
      mov  rsi,1           ; 1 => operation successfull .
      syscall              ; Make the call.

;============= strToNum ==============================
; The value returned by getpid() or getppid() are numbers like 54335
; to print them we have to retrieve each digit's code and then print it
; example: 5d (d mean decimal 5) maps to ENQ(enquiry) in the ascii format
; but after adding 48 to it we get 53
; 48d + 5d = 53d
; 53d is ascii code for char 5 ..and we then print this
; Two loops in this fuction does the job
; one loop convert them in required codes
; while other print them 
;=========================================================
