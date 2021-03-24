; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    13, 10, "Press Enter to Exit",0AH,0DH,0
Zapros   DB    13, 10, "Input number:  ", 0
Result   DB    13, 10, "Result:", 13, 10, 0
Prob     DB    "   ", 0
Ente     DB    13, 10, 0
Msg      DB    13, 10, "Matrix: ", 13, 10, 0

         .DATA

         .DATA?
MATRIX   SBYTE  35  DUP (?)
Buffer   DB     10  DUP (?)
RES      DB     16 DUP (' '),0
inbuf    DB    100 DUP (?)

         .CODE
Start:
         MOV    EBX, 0
         MOV    ECX, 5
      cycle1_1:     push    ECX                                     ; Ввод матрицы
                    MOV     ECX, 7
      cycle1_2:     push    ECX
                    Invoke StdOut,ADDR Zapros
                    Invoke StdIn,ADDR Buffer,LengthOf Buffer
                    Invoke StripLF,ADDR Buffer
                    Invoke atol,ADDR Buffer
                    pop     ECX
                    MOV     MATRIX[EBX],AL
                    inc     EBX
                    LOOP    cycle1_2
                    pop     ECX
                    LOOP    cycle1_1
                    
         Invoke StdOut,ADDR Msg                                    ; Вывод исходной матрицы в красивом виде
         MOV    EBX, 0
         MOV    ECX, 5
      cycle2_1:     push    ECX
                    MOV     ECX, 7
      cycle2_2:     push    ECX
                    Invoke dwtoa,MATRIX[EBX],ADDR RES
                    Invoke StdOut,ADDR RES
                    Invoke StdOut,ADDR Prob
                    pop     ECX
                    inc     EBX
                    LOOP    cycle2_2
                    Invoke StdOut,ADDR Ente
                    pop     ECX
                    LOOP    cycle2_1
                    
         
         MOV        EDI, 0                                    ; Обработка матрицы
         MOV        ECX, 7
      cycle3_1:     TEST    EDI, 1                      
                    JP     end_loop
                    MOV     EBX, 0
                    MOV     DL, MATRIX[EBX+EDI]
                    XCHG    DL, MATRIX+28[EBX+EDI]
                    MOV     MATRIX[EBX+EDI],DL
                    ADD     EBX, 7
                    MOV     DL, MATRIX[EBX+EDI] 
                    XCHG    DL, MATRIX+14[EBX+EDI]
                    MOV     MATRIX[EBX+EDI],DL   
       end_loop:    INC     EDI
                    LOOP    cycle3_1
        
         
         Invoke StdOut,ADDR Result                            ; Вывод результирующей матрицы
         MOV    EBX, 0
         MOV    ECX, 5
      cycle4_1:     push    ECX
                    MOV     ECX, 7
      cycle4_2:     push    ECX
                    Invoke dwtoa,MATRIX[EBX],ADDR RES
                    Invoke StdOut,ADDR RES
                    Invoke StdOut,ADDR Prob
                    pop     ECX
                    inc     EBX
                    LOOP    cycle4_2
                    Invoke StdOut,ADDR Ente
                    pop     ECX
                    LOOP    cycle4_1
         
         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

