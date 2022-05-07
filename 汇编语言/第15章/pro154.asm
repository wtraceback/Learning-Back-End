assume cs:code

stack segment
    db 128 dup (0)
stack ends

code segment
    start:
        mov ax, stack
        mov ss, ax
        mov sp, 128

        mov ax, 0b800h
        mov es, ax
        mov ah, 'a'
    s:
        mov es:[160 * 12 + 32 * 2], ah
        call delay
        inc ah
        cmp ah, 'z'
        jna s               ; 字符的显示

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
code ends

end start