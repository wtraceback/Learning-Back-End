assume cs:code

code segment
    start:
        mov al, 2
        out 70h, al         ; 将 al 送入端口 70h
        mov al, 0
        out 71h, al         ; 将 al 送入端口 71h

        mov ax, 4c00h
        int 21h
code ends

end start