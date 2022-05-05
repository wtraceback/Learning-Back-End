assume cs:codesg, ds:datasg, ss:stacksg

stacksg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stacksg ends

datasg segment
    db '1. display      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify       '
datasg ends

codesg segment
start:  mov ax, stacksg
        mov ss, ax
        mov sp, 10H

        mov ax, datasg
        mov ds, ax

        mov bx, 0           ; 每一个数组（即每一行的地址）
        mov cx, 4           ; cx 设置外层循环的次数 -- 数据段 中有 4 行字符（即 4 个数组）
    s:  push cx             ; 将外层循环 cx 中的值暂存到 栈 中
        mov si, 0           ; 每一行中元素的下标，相当于数组的下标
        mov cx, 4           ; cx 设置内层循环的次数

    s0: mov al, [bx+3+si]
        and al, 11011111B   ; 将 al 中的 ASCII 码的第 5 位置为 0，小写字母变为大写字母
        mov [bx+3+si], al   ; 将转变后的 ASCII 码写回原单元
        inc si              ; si 加 1，指向下一个字母
        loop s0             ; 内层循环的 loop 指令将 cx 中的计数值减 1

        add bx, 10H         ; 将 bx 指向下一个数组
        pop cx              ; 从栈顶弹出原 cx 的值，恢复 cx
        loop s              ; 外层循环的 loop 指令将 cx 中的计数值减 1

        mov ax, 4c00H
        int 21h
codesg ends

end start