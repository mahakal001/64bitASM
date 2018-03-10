# 64bit_shellcodes

================  SHELLCODES ====================================
@ if this name does not thrill your soul then you should stop reading right now and
  make some google search for this term

=====================================================================
@ Shellcoder : mahakal
@ date : Nov , 2016
@ why  : I love this concept
@ TESTED ON : UBUNTU 14.04  x86-64
======================================================================

@ A SHORT GUIDE ( or intro ? )
   step 1 :
            get the shellcode and execute follwoing command on your machine (x86-64) 

	    $ yasm -o <name_you_want_to_give> <source_file_name>

  step 2 : 
           get the function popularly named  "s-proc.c" from web and compile it
	   using follwing command

	   $ gcc -z execstack -fno-stack-protector -o s-proc s-proc.c

  step 3 : To make sure your stack is executable for this program ,  run

          $ readelf -a s-proc |  grep -A 4 GNU_STACK*
     
          you will see "RWE" at end of line GNU_STACK if it will be executable else  
          There is one more way if your stack is still not-executable

	        install execstack
	       $ sudo apt-get install execstack   ( or google for installing )
            and then to make stack executable run:

	        $ /usr/sbin/execstack -s s-proc 

	        now verify your stack again.if it is still not executable ...google....

  step 4 : run follwing
         $ s-proc -e shellcode
                    THis should run your shellcode
	  
  step 5 : extract your shellcode in a file 
          $ s-proc -p shellcode  > realShellCodeIsHere
	  
                        !!!! WISH YOU LOTS OF SHELL !!!!
                        
============ Thanks Sir Dennis Ritchie : YOU will never be forgotten ==========
