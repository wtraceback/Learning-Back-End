assume cs:codesg

datasg segment
    db "Beginner's All-purpose Symbolic Instruction Code.", 0
datasg ends

codesg segment
    begin:
        mov ax, datasg
        mov ds, ax
        mov si, 0
        call letterc

        mov ax, 4c00h
        int 21h

    ; 名称：letterc
    ; 功能：将以 0 结尾的字符串中的小写字母转变成大写字母
    ; 参数：ds:si 指向字符串首地址
    letterc:
        push si
        push cx
        mov cx, 0
    s:
        mov cl, ds:[si]
        jcxz ok                             ; 判断是否到达字符串的结尾 0
        cmp byte ptr ds:[si], 'a'
        jb s0                               ; 小于 'a' 则跳转到 s0
        cmp byte ptr ds:[si], 'z'
        ja s0                               ; 大于 'z' 则跳转到 s0
        and byte ptr ds:[si], 11011111b     ; 将小写字母变为大写字母
    s0:
        inc si
        jmp short s
    ok:
        pop cx
        pop si
        ret
codesg ends

end begin