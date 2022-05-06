assume cs:code

code segment
    s1:     db 'Good,better,best,', '$'
    s2:     db 'Never let it rest,', '$'
    s3:     db 'Till good is better,', '$'
    s4:     db 'And better,best.', '$'
    s:      dw offset s1, offset s2, offset s3, offset s4
    row:    db 2, 4, 6, 8

    start:
        mov ax, cs
        mov ds, ax
        mov bx, offset s
        mov si, offset row
        mov cx, 4                   ; 循环 4 次
    ok:
        mov bh, 0                   ; 第 0 页
        mov dh, ds:[si]             ; dh 中放行号
        mov dl, 0                   ; dl 中放列号
        mov ah, 2                   ; ah 传递了中断例程内部子程序的编号，2 的功能为设置光标位置
        int 10h                     ; int 10h 中断例程是 BIOS 提供的中断例程，和屏幕输出有关

        mov dx, ds:[bx]             ; 获取字符串偏移地址，中断例程中 ds:dx 指向字符串，要显示的字符串需 '$' 作为结束符
        mov ah, 9                   ; ah 传递了中断例程内部子程序的编号，9 号子程序的功能为在光标位置显示字符串
        int 21h                     ; int 21h 中断例程是 DOS 提供的中断例程
        inc si                      ; si 为不同行号元素的下标
        add bx, 2                   ; bx 为不同的要显示的字符串的偏移地址的下标
        loop ok

        mov ax, 4c00h
        int 21h
code ends

end start