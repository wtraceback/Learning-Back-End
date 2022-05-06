assume cs:code

code segment
    start:
        mov ax, cs
        mov ds, ax
        mov si, offset lp                       ; 设置 ds:si 指向源地址
        mov ax, 0
        mov es, ax
        mov di, 200h                            ; 设置 es:di 指向目的地址
        mov cx, offset lpend - offset lp        ; 设置 cx 为传输长度
        cld                                     ; 设置传输方向为正
        rep movsb

        ; 设置中断向量表
        mov ax, 0
        mov es, ax
        mov word ptr es:[7ch * 4], 200h
        mov word ptr es:[7ch * 4 + 2], 0

        mov ax, 4c00h
        int 21h


    lp:
        push bp                     ; 将 bp 的值入栈，并且当前栈顶 sp 改变 (sp)=(sp)-2
        mov bp, sp                  ; 将当前栈顶的值送入 bp 中
        dec cx
        jcxz lpret                  ; 如果 cx 为 0，则不改变栈中的偏移地址，直接返回
        add ss:[bp + 2], bx         ; ((ss)*16 + (bp) + 2) 就是栈中的偏移地址，加上位移，就等于了 s 标号处的地址
    lpret:
        pop bp
        iret                        ; 未改变的栈中的偏移地址 或 改变了的栈中的偏移地址，此时也出栈


    lpend:
        nop
code ends

end start