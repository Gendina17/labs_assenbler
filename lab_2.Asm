; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    13, 10,"Press Enter to Exit",0AH,0DH,0

         .DATA
ZaprosA   DB     'Input A',13,10,0
ZaprosB   DB     13,10,'Input B',13,10,0
ZaprosD   DB     13,10,'Input D',13,10,0
Result    DB     13, 10,'Result = ',0
RES       DB     16 DUP (' '),0

         .DATA?
Buffer   DB      10 DUP (?) 
A        SDWORD  ?
B        SDWORD  ?
D        SDWORD  ?
X        SDWORD  ?
inbuf    DB      100 DUP (?)

         .CODE
Start:
         Invoke StdOut,ADDR ZaprosA                 ; Ввод переменной A
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer
         Invoke atol,ADDR Buffer 
         MOV    DWORD PTR A,EAX
         
         Invoke StdOut,ADDR ZaprosB                 ; Ввод переменной B 
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer
         Invoke atol,ADDR Buffer 
         MOV    DWORD PTR B,EAX
         
         Invoke StdOut,ADDR ZaprosD                 ; Ввод переменной D
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer
         Invoke atol,ADDR Buffer 
         MOV    DWORD PTR D,EAX

         MOV    EAX, 3      ; EAX = 3
         IMUL   A           ; EDX:EAX = 3*A
         MOV    ECX, EAX    ; ECX = 3*A
         INC    ECX         ; ECX = 3*A + 1  окончательный знаменатель
         
         SBB    D, 2        ; D = D - 2
         MOV    EAX, 2      ; EAX = 2
         IMUL   D           ; EDX:EAX = EAX*D = 2*(d-2)
         MOV    EBX, EAX    ; EBX = 2*(d-2)
         MOV    EAX, B      ; EAX = B
         IMUL   B           ; EDX:EAX = B*B
         SBB    EAX, EBX    ; EAX = EAX - EBX = B*B - 2*(d-2)  окончательный числитель
         CDQ                ; EAX -> EDX:EAX
         IDIV   ECX         ; EAX = EDX:EAX / ECX = ( B*B - 2*(d-2) ) / ( 3*A + 1 )
         
         MOV    X, EAX 
         Invoke dwtoa,X,ADDR RES        ; Вывод результата
         Invoke StdOut,ADDR Result
         Invoke StdOut,ADDR RES
         
         XOR    EAX, EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

