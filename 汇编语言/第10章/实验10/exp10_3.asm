assume cs:code

data segment
    db 10 dup (0)
data ends

code segment
start:
    mov ax, 12666
    mov bx, data
    mov ds, bx
    mov si, 0
    call dtoc

    mov dh, 8
    mov dl, 3
    mov cl, 2
    call show_str

    mov ax, 4c00h
    int 21h

; 数值的转换
dtoc:                           ; 将 word 型数据转变为十进制的字符串，字符串以 0 位结尾符
    push si
    push di
    push ax
    push bx
    push cx
    push dx                     ; 子程序中使用的寄存器入栈
remainder:
    mov dx, 0
    mov di, 10
    div di
    mov bx, 30H
    add bx, dx                  ; 余数加上 30H
    push bx                     ; 将数值入栈 6 6 6 2 1
    inc si
    mov cx, ax                  ; 将商放入 cx 中，用于判断数值是否已经除尽
    jcxz dtoc_ok
    jmp short remainder
dtoc_ok:
    mov cx, si                  ; 将 6 6 6 2 1 出栈
    mov si, 0
s:  pop bx
    mov ds:[si], bl
    inc si
    loop s
    mov byte ptr ds:[si], 0     ; 虽然 data 段初始化的值都是 0，但是作为一个完整的子函数，还是需要在 12666 后面加 0 的

    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop si                     ; 子程序中使用的寄存器出栈
    ret

; 数值的显示
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
        jcxz show_str_ok        ; 条件转移，如果 cx 为 0 则跳转

        mov es:[di], cl
        mov es:[di + 1], al
        inc si
        add di, 2
        jmp short change
show_str_ok:
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop ax                 ; 将子程序中使用的寄存器出栈

        ret

code ends

end start