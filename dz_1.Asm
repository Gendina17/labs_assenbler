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
Strr     DB    "aeiouyAEIOUY", 0
Zapros   DB    "Input string:   "
Prob     DB    20h, 20h, 0
Dvoetoch DB    "  consonantal:  ", 0
Ent      DB    13, 10, 0
VLV      DB    "  vowels  ", 0

         .DATA
Buffer   DB    100  DUP(0)

         .DATA?
inbuf    DB    100 DUP (?)
ResMass  DB    100  DUP (?)
RES      DB    100  DUP (?)
COUNTER  DWord    ?
CURRENT  DWord    ?
CUR  DWord    ?


         .CODE
Start:
         Invoke StdOut,ADDR Zapros
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer            ; Вводим нашу строку


        LEA ESI,    Buffer                     ; Находим смещение нашей строки, чтоб двигаться по ней
        MOV EBX,    0                          ; Зануляем счетчик гласных
        MOV ECX,    0                          ; Зануляем счетчик букв в слове
        LEA EDI,    Strr                       ; Загружаем нашу страку с гласными в приемник
        MOV EDX,    0
        CLD                                    ; Зануляем смещение в массиве результатов с глас. и согл.
        LODSB

    cycle:  cmp EAX,    0                      ; Проверяем не конец ли строки
            je end_cycle                       ; Если конец выходим из цикла
                cmp     EAX, 20h               ; Если он равен пробелу, идем в соответствующуюветку
                je probel
                    inc BL                     ; Увеличиваем счетчик букв в слове
                    cld
                    push    ECX                ; Загружаем в стек счетчик гласных, чтоб использовать его для цикла
                    MOV     ECX, 12            ; Устанавливаем длину строки гласных
                    REPNE SCASB
                    LEA     EDI, Strr          ; Сравниваем строку с текущим символом в EAX, пока не равен,если да, значит присутствует гласная
                    pop     ECX                ; Забираем из стека текущий счетчик гласных
                    jne no_glas                ; Проверяем является ли данная буква гласной, то есть мы завершили цикл досрочно
                        inc CL
                    no_glas: jmp continue
                probel: cmp     EBX, 0
                je no_write
                    MOV     ResMass[EDX], CL   ; Если пробел, то записываем в массив кол-во гласных
                    SUB     BL, CL
                    inc     EDX
                    MOV     ResMass[EDX], BL   ; И согласных
                    inc     EDX
                    MOV     EBX, 0             ; Обнуляем счетчики
                    MOV     ECX, 0
                    inc     COUNTER
                no_write:
               continue: CLD
               LODSB
               jmp      cycle
            end_cycle:
            MOV     ResMass[EDX], CL           ; Если пробел, то записываем в массив кол-во гласных
            SUB     BL, CL
            inc     EDX
            MOV     ResMass[EDX], BL           ; И согласных
            inc     COUNTER
             
             
             
             
             mov    EAX, 0                                    
             mov    EDX, 0   
             mov    EBX, 0                     ; Очищаем регистры, и устанавливаем счетчик
             mov    ECX, COUNTER   
             inc    CURRENT                  
              
  cycle2:  mov      EBX, 0                     ; Проверка на то, не выводились ли слова ранее
           cmp      ResMass[EDX], BL
           jne      no_z
                cmp     ResMass+1[EDX], BL
                je no_wr
           no_z:    push    ECX
           push     EDX
           mov      EBX, 0
           mov      BL, ResMass[EDX]           ; Вывод количества гласных и согласных
           Invoke dwtoa,EBX,ADDR RES
           Invoke StdOut,ADDR RES 
           Invoke StdOut,ADDR VLV
           pop      EDX
           push     EDX
           mov      BL, ResMass+1[EDX]
           Invoke dwtoa,EBX,ADDR RES
           Invoke StdOut,ADDR RES
           Invoke StdOut,ADDR Dvoetoch          
           Invoke dwtoa,CURRENT,ADDR RES
           Invoke StdOut,ADDR RES
           pop      EDX
           mov      ax, word ptr ResMass[EDX] 
           push     EDX  
           mov      ECX, COUNTER
           sub      ECX, CURRENT   
           inc      CURRENT
           mov      ebx, CURRENT
           mov      CUR, ebx 
           cmp      ECX, 0    
           je       end_2                
           cycle_in:    add     EDX, 2
                        cmp     ax, word ptr ResMass[EDX]         ; Вывод слова с равным количеством гласых и согласных
                        jne     ne_ravn
                            push        ECX
                            push        EDX
                            push        EAX
                            Invoke StdOut,ADDR Prob  
                            Invoke dwtoa,CUR,ADDR RES
                            Invoke StdOut,ADDR RES
                            pop     EAX
                            pop     EDX                         
                            pop     ECX
                            mov     ResMass[EDX], 0
                            mov     ResMass+1[EDX], 0
                            jmp     end_in
                       ne_ravn: 
                       end_in:   inc    CUR
          loop      cycle_in
          Invoke StdOut,ADDR Ent
          pop       EDX
          pop       ECX  
          jmp       cnt
              no_wr:inc     CURRENT
          cnt:    add      EDX, 2
          dec       ECX
          end_2:
   jne cycle2
         
         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

