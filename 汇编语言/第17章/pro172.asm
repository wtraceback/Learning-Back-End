assume cs:code

code segment
    start:
        mov ah, 0
        int 16h             ; 将数据从键盘缓冲区中读出，读取出的数据默认写到 ax 寄存器中，(ah)=扫描码，(al)=ASCII码

        mov ah, 1           ; 设置 ah 存放的是字符属性
        cmp al, 'r'         ; 如果对应的 ASCII 码是 r，则将屏幕上的字符设置为红色
        je red
        cmp al, 'g'
        je green
        cmp al, 'b'
        je blue
        jmp short sret

    red:
        shl ah, 1
    green:
        shl ah, 1
    blue:
        mov bx, 0b800h
        mov es, bx
        mov bx, 1
        mov cx, 2000
    s:
        and byte ptr es:[bx], 11111000b
        or es:[bx], ah
        add bx, 2
        loop s

    sret:
        mov ax, 4c00h
        int 21h
code ends

end start