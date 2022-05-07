assume cs:code

data segment
    db 'yy/MM/dd HH:mm:ss'
    db 9,8,7,4,2,0
data ends

code segment
    start:
        mov ax, data
        mov ds, ax
        mov si, 0
        mov di, 17                  ; CMOS RAM 中地址信息的索引

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


        mov ax, data
        mov ds, ax
        mov si, 0
        mov cx, 17

        mov ax, 0b800h
        mov es, ax
        mov di, 160 * 13 + 32 * 2   ; 将二进制数送到显存缓冲区（显卡上的显存中），显卡会用 ASCII 码的规则解释显存中的内容，会立即在显示器上显示出来

    show_str:
        mov al, ds:[si]
        mov ah, 02h                 ; 字符属性
        mov es:[di], ax

        inc si
        add di, 2
        loop show_str

        mov ax, 4c00h
        int 21h
code ends

end start