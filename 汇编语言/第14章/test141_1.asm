assume cs:code

code segment
    start:
        mov al, 2
        out 70h, al         ; 将 al 送入端口 70h
        in al, 71h          ; 从端口 71h 处读出端口内容，送入到 al 中

        mov ax, 4c00h
        int 21h
code ends

end start