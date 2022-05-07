assume cs:code

code segment
    start:
        mov ah, 0           ; 0 表示清屏，1 表示设置前景色，2 表示设置背景色，3 表示向上滚动一行
        mov al, 2           ; 对于 1、2 号功能，用 al 传送颜色值，(al)∈{0, 1, 2, 3, 4, 5, 6, 7}
        int 7ch             ; 调用新的 int 7ch 中断例程

        mov ax, 4c00h
        int 21h
code ends

end