assume cs:codesg

datasg segment
    db 'welcome to masm!'
datasg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax
        mov bx, 0

        mov ax, 0b800H                      ; 显示缓冲区的段地址
        mov es, ax
        mov bp, 1760                        ; 屏幕中间，第 12 行的起始地址 11 * 80 * 2
        mov si, 0

        mov cx, 16                          ; 要显示的有 16 个字符，所以循环 16 次
    s:  mov ah, 00000010B                   ; 黑底绿色 00000010B = 02H
        mov al, ds:[bx]                     ; ax 的低位字节存储字符的 ASCII 码，高位字节存储字符的属性
        mov es:[bp + 64 + si], ax           ; 第 12 行

        mov ah, 00100100B                   ; 绿底红色 00100100B = 24H
        mov al, ds:[bx]
        mov es:[bp + 160 + 64 + si], ax     ; 第 13 行

        mov ah, 01110001B                   ; 白底蓝色 01110001B = 71H
        mov al, ds:[bx]
        mov es:[bp + 320 + 64 + si], ax     ; 第 14 行

        inc bx
        add si, 2

        loop s

        mov ax, 4c00H
        int 21H
codesg ends

end start