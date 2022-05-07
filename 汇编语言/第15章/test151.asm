assume cs:code

stack segment
    db 128 dup (0)
stack ends

data segment
    dw 0, 0
data ends

code segment
    start:
        mov ax, stack
        mov ss, ax
        mov sp, 128

        mov ax, data
        mov ds, ax

        mov ax, 0
        mov es, ax

        push es:[9*4]
        pop ds:[0]
        push es:[9*4 + 2]
        pop ds:[2]              ; 将原来的 int 9 中断例程的入口地址保存在 ds:0、ds:2 单元中

        cli
        mov word ptr es:[9*4], offset int9
        mov es:[9*4 + 2], cs    ; 在中断向量表中设置新的 int 9 中断例程的入口地址
        sti

        mov ax, 0b800h
        mov es, ax
        mov ah, 'a'
    s:
        mov es:[160 * 12 + 32 * 2], ah
        call delay
        inc ah
        cmp ah, 'z'
        jna s               ; 字符的显示

        mov ax, 0
        mov es, ax

        push ds:[0]
        pop es:[9*4]
        push ds:[2]
        pop es:[9*4 + 2]    ; 将中断向量表中 int 9 中断例程的入口恢复为原来的地址

        mov ax, 4c00h
        int 21h

    delay:                  ; 空循环延时
        push ax
        push dx
        mov dx, 10h         ; 使用16位 dx 和16位 ax 组成一个 32 位的循环次数，dx 为高位，ax 为低位
        mov ax, 0
    s1:
        sub ax, 1
        sbb dx, 0
        cmp ax, 0
        jne s1
        cmp dx, 0
        jne s1

        pop dx
        pop ax
        ret

    ; ------ 以下为新的 int 9 中断例程 ------------------
    int9:
        push ax
        push bx
        push es

        in al, 60h

        pushf
        call dword ptr ds:[0]   ; 对 int 指令进行模拟，调用原来的 int 9 中断例程

        cmp al, 1
        jne int9ret

        mov ax, 0b800h
        mov es, ax
        inc byte ptr es:[160*12 + 32*2 + 1] ; 将属性值加 1，改变颜色

    int9ret:
        pop es
        pop bx
        pop ax
        iret
code ends

end start