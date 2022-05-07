assume cs:code

code segment
    start:
        mov ax, cs
        mov ds, ax
        mov si, offset setscreen                        ; 设置 ds:si 指向源地址
        mov ax, 0
        mov es, ax
        mov di, 200h                                    ; 设置 es:di 指向目的地址
        mov cx, offset setscreenend - offset setscreen  ; 设置 cx 为传输长度
        cld                                             ; 设置传输方向为正
        rep movsb

        ; 设置中断向量表
        mov ax, 0
        mov es, ax
        cli
        mov word ptr es:[7ch * 4], 200h
        mov word ptr es:[7ch * 4 + 2], 0
        sti

        mov ax, 4c00h
        int 21h


    ; 新的 int 7ch 中断例程
        org 200h                        ; 设置 200h 作为以下指令的起始地址，后面指令的偏移地址将按照设定的起始地址（偏移地址）为起点开始递增
    setscreen:
        jmp short set
        table dw sub1, sub2, sub3, sub4
    set:
        push bx
        cmp ah, 3                       ; 判断功能号是否大于 3
        ja sret
        mov bl, ah                      ; ah 寄存器传递功能号
        mov bh, 0
        add bx, bx                      ; 根据 ah 中的功能号，计算对应子程序在 table 表中的偏移（table 表使用 dw 定义字型数据，所以需要 功能号*2）
        call word ptr table[bx]         ; 调用对应的功能子程序
    sret:
        pop bx
        iret

    sub1:
        push bx
        push cx
        push es
        mov bx, 0b800h
        mov es, bx
        mov bx, 0
        mov cx, 2000
    sub1s:
        mov byte ptr es:[bx], ' '
        add bx, 2
        loop sub1s
        pop es
        pop cx
        pop bx
        ret                             ; 清屏

    sub2:
        push bx
        push cx
        push es
        mov bx, 0b800h
        mov es, bx
        mov bx, 1
        mov cx, 2000
    sub2s:
        and byte ptr es:[bx], 11111000b
        or es:[bx], al
        add bx, 2
        loop sub2s
        pop es
        pop cx
        pop bx
        ret                             ; 设置前景色（字符颜色）

    sub3:
        push bx
        push cx
        push es
        mov cl, 4
        shl al, cl
        mov bx, 0b800h
        mov es, bx
        mov bx, 1
        mov cx, 2000
    sub3s:
        and byte ptr es:[bx], 10001111b
        or es:[bx], al
        add bx, 2
        loop sub3s
        pop es
        pop cx
        pop bx
        ret                             ; 设置背景色

    sub4:
        push cx
        push si
        push di
        push es
        push ds
        mov si, 0b800h
        mov es, si
        mov ds, si
        mov si, 160                     ; ds:si 指向第 n+1 行
        mov di, 0                       ; es:di 指向第 n 行
        cld
        mov cx, 24                      ; 共复制 24 行
    sub4s:
        push cx
        mov cx, 160
        rep movsb                       ; 复制一整行，一行有 160 个字节
        pop cx
        loop sub4s
        mov cx, 80
        mov si, 0
    sub4s1:
        mov byte ptr [160*24+si], ' '   ; 最后一行清空
        add si, 2
        loop sub4s1
        pop ds
        pop es
        pop di
        pop si
        pop cx
        ret                             ; 向上滚动一行

    setscreenend:
        nop
code ends

end start