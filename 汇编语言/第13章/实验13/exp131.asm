assume cs:code

code segment
    start:
        mov ax, cs
        mov ds, ax
        mov si, offset show_str                         ; 设置 ds:si 指向源地址
        mov ax, 0
        mov es, ax
        mov di, 200h                                    ; 设置 es:di 指向目的地址
        mov cx, offset show_str_end - offset show_str   ; 设置 cx 为传输长度
        cld                                             ; 设置传输方向为正
        rep movsb

        ; 设置中断向量表
        mov ax, 0
        mov es, ax
        mov word ptr es:[7ch * 4], 200h
        mov word ptr es:[7ch * 4 + 2], 0

        mov ax, 4c00h
        int 21h


    show_str:
        push ax
        push cx
        push dx
        push si
        push di
        push es                 ; 将子程序中使用的寄存器入栈

        mov ax, 0b800h          ; 显存的起始地址
        mov es, ax
        mov di, 0

        mov al, 160
        mul dh
        add di, ax              ; 计算显示的位置

        mov ax, 2
        mul dl
        add di, ax              ; 计算显示的位置

        mov al, cl              ; 字符的属性值

    change:
        mov ch, 0
        mov cl, ds:[si]
        jcxz ok                 ; 条件转移，如果 cx 为 0 则跳转

        mov es:[di], cl
        mov es:[di + 1], al
        inc si
        add di, 2
        jmp short change

    ok:
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop ax                 ; 将子程序中使用的寄存器出栈
        iret


    show_str_end:
        nop
code ends

end start