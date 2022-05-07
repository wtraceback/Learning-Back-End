assume cs:code

stack segment
    db 1024 dup (0)                                 ; charstack 的子程序中使用 dw 定义字型数据，所以这里应该写 2^16 = 65536
stack ends

code segment
    start:
        mov ax, stack
        mov ds, ax
        mov si, 0                                   ; ds:si 指向字符栈空间
        mov dh, 13                                  ; 字符串在屏幕上显示的行数
        mov dl, 32                                  ; 字符串在屏幕上显示的列数

        call getstr                                 ; 调用子程序，获取字符串的输入

        mov ax, 4c00h
        int 21h


    ; 接收字符串输入的子程序
    getstr:
        push ax
    getstrs:
        mov ah, 0
        int 16h                                     ; 将数据从键盘缓冲区中读出，读取出的数据默认写到 ax 寄存器中，(ah)=扫描码，(al)=ASCII码
        cmp al, 20h
        jb nochar                                   ; ASCII 小于 20h，说明不是字符
        mov ah, 0
        call charstack                              ; 字符入栈
        mov ah, 2
        call charstack                              ; 显示栈中的字符
        jmp getstrs
    nochar:
        cmp ah, 0eh                                 ; 退格键的扫描码
        je backspace
        cmp ah, 1ch                                 ; Enter 键的扫描码
        je enter
        jmp getstrs
    backspace:
        mov ah, 1
        call charstack                              ; 字符出栈
        mov ah, 2
        call charstack                              ; 显示栈中的字符
        jmp getstrs
    enter:
        mov al, 0
        mov ah, 0
        call charstack                              ; 0 入栈
        mov ah, 2
        call charstack                              ; 显示栈中的字符

        pop ax
        ret


    ; 子程序：字符栈的入栈、出栈和显示
    ; 参数说明：(ah)=功能号，0 表示入栈，1 表示出栈，2 表示显示
    ;           ds:si 指向字符栈空间
    ;           对于 0 号功能：(al)=入栈字符
    ;           对于 1 号功能：(al)=返回字符
    ;           对于 2 号功能：(dh)、(dl)=字符串在屏幕上显示的行、列位置
    charstack:
        jmp short charstart
        table dw charpush, charpop, charshow
        top dw 0                                    ; 栈顶

    charstart:
        push bx
        push dx
        push di
        push es

        cmp ah, 2
        ja sret                                     ; 大于 2，则跳转返回
        mov bl, ah
        mov bh, 0
        add bx, bx                                  ; table 使用 dw 定义数据，所以需要 *2
        jmp word ptr table[bx]

    charpush:
        mov bx, top
        mov [si][bx], al
        inc top
        jmp sret

    charpop:
        cmp top, 0
        je sret
        dec top
        mov bx, top
        mov al, [si][bx]
        jmp sret

    charshow:
        mov bx, 0b800h
        mov es, bx
        mov al, 160
        mov ah, 0
        mul dh                                      ; 8 位乘法，结果放在 ax 中
        mov di, ax
        add dl, dl
        mov dh, 0
        add di, dx                                  ; 行*160 + 列*2

        mov bx, 0

    charshows:
        cmp bx, top
        jne noempty
        mov byte ptr es:[di], ' '
        jmp sret
    noempty:
        mov al, [si][bx]
        mov es:[di], al
        mov byte ptr es:[di+2], ' '
        inc bx
        add di, 2
        jmp charshows

    sret:
        pop es
        pop di
        pop dx
        pop bx
        ret
code ends

end start