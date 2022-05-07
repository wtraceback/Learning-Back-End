assume cs:code

code segment
    start:
        ; 从 CMOS RAM 的 8 号单元读出当前月份的 BCD 码
        mov al, 8
        out 70h, al                                     ; 向地址端口 70h 写入要访问的单元的地址
        in al, 71h                                      ; 从数据端口 71h 中取得指定单元中的数据

        ; 将读取到的 BCD 码经过一系列的转换，转为对应的 ASCII 码字符（显存中识别的是 ASCII 码）
        mov ah, al                                      ; al 中为从 CMOS RAM 的 8 号单元中读出的数据
        mov cl, 4
        shr ah, cl                                      ; ah 中为月份的十位数码值（右移后得到数值）
        and al, 00001111b                               ; al 中为月份的个位数码值（逻辑与运算后得到数值）
        add ah, 30h                                     ; 月份的十位数对应的 ASCII 码字符（BCD码值 + 30h = 十进制数对应的 ASCII 码）
        add al, 30h                                     ; 月份的个位数对应的 ASCII 码字符

        ; 将二进制数送到显存缓冲区（显卡上的显存中），显卡会用 ASCII 码的规则解释显存中的内容，会立即在显示器上显示出来
        mov bx, 0b800h
        mov es, bx
        mov byte ptr es:[160 * 12 + 40 * 2], ah         ; 显示月份的十位数码
        mov byte ptr es:[160 * 12 + 40 * 2 + 2], al     ; 接着显示月份的个位数码

        mov ax, 4c00h
        int 21h
code ends

end start