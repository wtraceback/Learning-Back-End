assume cs:code

code segment
    db 'yy/MM/dd HH:mm:ss', '$'
    address: db 9,8,7,4,2,0

    start:
        mov ax, cs
        mov ds, ax
        mov si, 0
        mov di, offset address      ; CMOS RAM 中地址信息的索引

        mov cx, 6
    s:
        push cx

        mov al, ds:[di]
        out 70h, al
        in al, 71h                  ; 从 CMOS RAM 读取 BCD 码

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b
        add ah, 30h
        add al, 30h                 ; 将读取到的 BCD 码经过一系列的转换，转为对应的 ASCII 码字符（显存中识别的是 ASCII 码）

        mov ds:[si], ah
        mov ds:[si+1], al           ; 将转换后的 ASCII 码字符放入预先定义好的字符串中

        add si, 3
        inc di
        pop cx
        loop s


        mov ah, 2                   ; 置光标
        mov bh, 0                   ; 第 0 页
        mov dh, 13                  ; dh 中放行号
        mov dl, 32                  ; dl 中放列号
        int 10h

        mov dx, 0                   ; 设定要读取的字符串地址，ds:dx 指向字符串的首地址 data:0
        mov ah, 9
        int 21h                     ; 调用 BIOS 和 DOS 提供的中断例程，显示字符串

        mov ax, 4c00h
        int 21h
code ends

end start