; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    "Press Enter to Exit",0AH,0DH,0

         .DATA
A        BYTE   10
B        BYTE   4

         .DATA?
inbuf    DB    5 DUP (?)
D        BYTE   ?


         .CODE
Start:
         mov    AL, A
         add    AL, B
         mov    D, AL
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

