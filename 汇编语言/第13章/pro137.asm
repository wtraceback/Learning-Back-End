assume cs:code

data segment
    db 'Welcome to masm', '$'
data ends

; 在屏幕的 5 行 12 列显示字符串 “Welcome to masm!”
code segment
    start:
        ; int 10h 中断例程的设置光标位置功能（BIOS 提供的中断例程）
        mov ah, 2           ; 调用第 10h 号中断例程的 2 号子程序，功能为设置光标位置
        mov bh, 0           ; 第 0 页
        mov dh, 5           ; dh 中存放行号
        mov dl, 12          ; dl 中存放列号
        int 10h

        ; int 21h 中断例程在光标位置显示字符串的功能（DOS 提供的中断例程）
        mov ax, data
        mov ds, ax
        mov dx, 0           ; ds:dx 指向字符串的首地址 data:0
        mov ah, 9
        int 21h

        mov ax, 4c00h
        int 21h
code ends

end start