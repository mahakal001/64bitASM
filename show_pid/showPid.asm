;asmsyntax=nasm ; uncomment & reopen while editing/reading in vim(the giant version)
 BITS 64    0    ; Telling yasm:a 64 bit asm code

 section .data           ; Containing initialized data
     ten   dq 10        ; define qword ten having value 10   
     rem   dq 0         ; define qword rem initializing to 0

     pidMsg: db "This process's id is:  "
     pidMsgLen: equ  $-pidMsg

     ppidMsg: db "The parent process id: "
     ppidMsgLen: equ $-ppidMsg

     newline: db 0xa    ; new line feed
     len: equ $-newline

 section .bss           ; containing uninitialized data
     num resq 1        ; reserve one quad word labeled as num 

 section .text          ; instruction starts from here
     global _start     ; telling linker the starting point
     _start:              

 ;prompt for the process id
     mov rsi,pidMsg     ;moving address of string in rsi
     mov rdx,pidMsgLen  ;moving length of string in rdx
     call write
 ;pid_t getpid(void) <- get process ID
     mov rax,39        ;39 is syscall for getpid   
     syscall           ;pid is returned in rax
     call strToNum     ;WHY it is used? see bottom comments
     call feedline     ;feed the line with '\n' 

 ;prompt for the parent process id
     mov  rsi,ppidMsg
     mov  rdx,ppidMsgLen
     call write
 ;pid_t getppid(void) <- get parent process ID
     mov  rax,110       ; 110 is syscall for getppid()
     syscall            ; parent pid is returned in rax
     call strToNum      ; why this? see bottom comments
     call feedline      ; feed the line with '\n'
     jmp  exit          ; all done ..byy

;============= FUNCTIONS STARTS FROM HERE ===============
 strToNum:
    mov [num],rax
    xor  rcx,rcx        ; initialising the loop counter
    while:
      cmp  qword [num],0  ; if number == 0  break out of the loop
      je   print          ; print the number 'num'  if whole digit has been processed
      mov  rax, [num]    ; moving 'num' to rax for division
      xor  rdx, rdx      ; rax:rdx is dividend 4 division & 0 out unnecessary space
      idiv qword [ten]    ; divide rax:rdx by 10
      mov  [num],rax      ; moving quotient to num (for next loop) 
      add  rdx,48         ; addding 48 to remainder to have equ ascii code of that digit
      mov  [rem],rdx      ; storing the above obtained ascii code  in 'rem' 
      push qword [rem]    ; pushing the ascii code on stack
      inc  rcx            ; incrementing the loop counter
      jmp  while          ; iterate

    print:                   ; printing the number
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
      jmp  print           ; call print again
              
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
