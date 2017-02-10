=================== EXCLUSIVELY FOR YOU ==================
# Coded By : Mohit Kumar
# Tested On: x86-64bit ubuntu 14.04
# Contact  : mkal001@cyberdude.com

# STOP:  
       Have you ever used memory allocating functions like `malloc,calloc,free` etc. in c
       These function are wrapper functions provided by library.
     * A program's break address is one upto which a program can store its all desired 
       data
     * These function finally call brk() for allocating memory.The memory is allocated
       in a very simple mannner..just push the program break address to the one 
       specified in the argument to brk().
     * And to free a memory space...drop the break address to desired value

# WHAT THIS PIECE OF CODE DOES:

*WARNING:the addresses returned are printed in base 10.you can use some app. to see 
         their equivalent hexa-decimal representation

    1) when brk() is called with invalid address,it returns the initial brk address
       So we first call brk() with 0 as argument..and then we print the return value.

    2) Then we decide to allocate 2048k of memory.So,we have to get an address 
       which should be 2048k past the current brk address.To do this, we add 2048k
       to current brk address.This gives us desired address.This address is then 
       passed as argument to the brk() syscall.After execution of this call,The 
       program break is set to this desired value.

    3) Then we decide to deallocate 1024k of memory.So,we have to get this address.
       To do this we subtract 1024k from current brk address.This address is then 
       passed as arg. to brk().This sets new brk address resulting in the free up 
       of 1024k of memory from our previously allocated memory.

# WHAT FREEing A MEMORY AREA MEANS

* The kernel maintains a doubly linked list of available free space to any program.
  The addresses available here are always available for allocation to any new demand 
  made by program.
* Any memory freed with the call free(ADDR) just mov the address ADDR to this link 
  list and this is declared as available for other memory request.

# WHAT YOU SHOULD GOOGLE:

* when you call the function :  free(ADDR)
  How kernel know that what amount of bytes to free starting from ADDR 
* what if the free(ADDR) wants to free a memory area which is between memory still
  in use.Because we can't decrement the brk boundry..

  ====== BE CREATIVE MAN : LINUX IS SEXY =======
  
  ;============= JAI MAHAKAL  ===================
