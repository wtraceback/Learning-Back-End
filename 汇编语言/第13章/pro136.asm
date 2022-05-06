assume cs:code

; 在屏幕的 5 行 12 列显示 3 个红底高亮闪烁绿色的 'a'
; int 10h 中断例程是 BIOS 提供的中断例程，其中包含了多个和屏幕输出相关的子程序。
code segment
    start:
        ; int 10h 中断例程的设置光标位置功能（BIOS 提供的中断例程）
        mov ah, 2           ; 调用第 10h 号中断例程的 2 号子程序，功能为设置光标位置
        mov bh, 0           ; 第 0 页
        mov dh, 5           ; dh 中存放行号
        mov dl, 12          ; dl 中存放列号
        int 10h

        ; int 10h 中断例程在光标位置显示字符功能（BIOS 提供的中断例程）
        mov ah, 9           ; 调用第 10h 号中断例程的 9 号子程序，功能为在光标位置显示字符
        mov al, 'a'         ; 字符
        mov bl, 11001010b   ; 颜色属性
        mov bh, 0           ; 第 0 页
        mov cx, 3           ; 字符重复个数
        int 10h

        mov ax, 4c00h
        int 21h
code ends

end start