assume cs:code

code segment
    start:
        mov ah, 0                 ; 用 ah 寄存器传递功能号：0 表示读，1 表示写
        mov dx, 0                 ; 用 dx 寄存器传递要读写的扇区的逻辑扇区号
        mov bx, 0
        mov es, bx
        mov bx, 200h              ; 用 es:bx 指向存储读出数据或写入数据的内存区

        int 7ch                   ; 调用新的 int 7ch 中断例程

        mov ax, 4c00h
        int 21h
code ends

end start