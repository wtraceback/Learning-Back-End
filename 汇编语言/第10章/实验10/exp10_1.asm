assume cs:code

data segment
    db 'Welcome to masm!', 0
data ends

code segment
start:  mov dh, 8               ; 行号
        mov dl, 3               ; 列号
        mov cl, 2               ; 颜色

        mov ax, data
        mov ds, ax
        mov si, 0

        call show_str
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

change: mov ch, 0
        mov cl, ds:[si]
        jcxz ok                 ; 条件转移，如果 cx 为 0 则跳转

        mov es:[di], cl
        mov es:[di + 1], al
        inc si
        add di, 2
        jmp short change

ok:     pop es
        pop di
        pop si
        pop dx
        pop cx
        pop ax                 ; 将子程序中使用的寄存器出栈

        ret
code ends

end start