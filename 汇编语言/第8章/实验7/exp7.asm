assume cs:codesg

data segment
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'
    ; 以上是表示 21 年的 21 个字符串

    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
    ; 以上是表示 21 年公司总收入的 21 个 dword 型数据

    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800
    ; 以上是表示 21 年公司雇员人数的 21 个 word 型数据
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

codesg segment
start:  mov ax, data
        mov ds, ax
        mov di, 0           ; data 段 “年份” 和 “公司总收入” 的下标 index
        mov si, 0           ; data 段 “雇员人数” 的下标 index
        mov bx, 0           ; data 段的

        mov ax, table
        mov es, ax
        mov bp, 0           ; table 段的

        mov cx, 21          ; 循环次数为 21 次
    s:
        ; 年份的操作
        mov ax, ds:[bx + 0H + di]
        mov es:[bp + 0H], ax
        mov ax, ds:[bx + 2H + di]
        mov es:[bp + 2H], ax

        ; 公司总收入的操作
        mov ax, ds:[bx + 54H + di]           ; ds:[bx + 54H + 0H + di]
        mov es:[bp + 5H], ax
        mov ax, ds:[bx + 56H + di]           ; ds:[bx + 54H + 2H + di]
        mov es:[bp + 7H], ax

        ; 雇员人数的操作
        mov ax, ds:[bx + 0a8H + si]           ; ds:[bx + 54H + 54H + si]
        mov es:[bp + 0aH], ax

        ; 除法操作
        mov ax, ds:[bx + 54H + di]
        mov dx, ds:[bx + 56H + di]
        div word ptr ds:[bx + 0a8H + si]

        ; 人均收入的操作
        mov es:[bp + 0dH], ax

        add di, 4
        add si, 2
        add bp, 10H

        loop s

        mov ax, 4c00H
        int 21H
codesg ends

end start