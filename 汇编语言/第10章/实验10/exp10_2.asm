assume cs:code

code segment
start:  mov ax, 4240H
        mov dx, 000FH
        mov cx, 0AH
        call divdw
        mov ax, 4c00h
        int 21H

divdw:  mov si, ax      ; 将低 16 位保存到另外的寄存器中
        mov ax, dx
        mov dx, 0
        div cx          ; 执行 H/N，div 指令执行后，ax 中保存着商int(H/N)，dx 中保存着余数rem(H/N)
        mov di, ax      ; 将 int(H/N) 保存到另外的寄存器中

        mov ax, si      ; dx 中的数为 rem(H/N)*65536，ax 中的数为被除数的低 16 位
        div cx          ; [rem(H/N)*65536 + L]/N = [(dx)*65536 + (ax)] / (cx)

        mov cx, dx      ; cx 中存放余数
        mov dx, di      ; 将结果的高 16 位放入 dx 中，ax 默认保留着结果的低 16 位
        ret
code ends

end start