## Know the creator (Not of UNIVERSE,i didn't do that) ##

  Coder       : `Mohit Kumar`
  Tested on   : Ubuntu 14.04 x86-64 bit ( Intel Pentium Quad core )
  contact     : mkal001@cyberdude.com 
  Date of test: Monday 6 feb 2017
 

## Purpose of this software ##

   This software shows you how to access your environment variables and command line arguments 
   through `pure assembly coding` i.e without using any external std. library functions.


## What made me to write this ? ##

   Good question sir!! 
   When i read about `getenv()` function in c,i thought there would be some syscall for this too as 
   read,write,exit etc. that linux kernel provides.But when i check the `unistd_64.h` header file 
   I came to know that there was no syscall dedicated for this purpose.
   On web i also came to know that nasm provides code like (and some MACROS)

   %defstr foo $bar

   for getting value of the environment variable 'bar' in 'foo'.
   But what i wanted was to have all environment variables.Ofcourse choosing the above 
   way is not efficient.Thats where i decided to write code for this purpose.Later i 
   also add the way you can access your command line args.

## How to run ##

   Prerequiste:
    First ensure that your processor is `x86-64 bit.`
    Then make sure you have `yasm assembler` installed.
    And is your operating system 64bit linux?
    Running:
      Open terminal.
      Ensure you are in the same directory as the code file.
	     Then following sequence of command at prompt should do the job:

	     $ make
	     $./main 

      You can see a sample run that i provided in my output.txt of this repo.

## How this package works? ##

    `makefile` has assembling and linking commands in it.when you run the std. linux command `make`
     it search for file named `makefile` and execute the commands in it.You can also assemble and
     link by typing those commands in your terminal But it is very frustrating to do this again
     and again after you introduce changes in your source files.Check web for more information

     The file `main.asm` controls the behaviour of this whole software.
     It first call `get_arg_count` to print the number of arguments.
     Then it call `get_args` to print the command line arguments that `main` received.
     Finally it call `getenv` to print the environment variables.

     `lib.asm` contain some general library routines.The most important of them is `strToNum`.Check my 
     repo on `github.com/mahakal001` named `strToNum` for more information on how this works.

     `output.txt` contain one instance of run on my system. 

## Benefits ##

     Access to cmd_line_args and their count can help in same way as it does in any other language and
     If you are a linux user then you already know how important are environment variables for us.

## What more can you contribute to this code? ##

   The one thing that you can do is making it more efficeint.for example: 
   You can use register more efficiently.Making more smart algorithms for various tasks.
   For example you can make more efficient loops.
   Opcodes also matters.Sometimes a task in three instructions can be done with just one instruction.
   Check `Intel or AMD manual for more details`.

