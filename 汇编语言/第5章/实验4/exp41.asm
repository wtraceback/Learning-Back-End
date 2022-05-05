assume cs:code

code segment

    mov ax, 0020h
    mov ds, ax
    mov bx, 0

    mov cx, 64                  ; (cx)=64，循环 64 次

s:  mov ds:[bx], bl             ; 将一个字节送入内存单元 0020:(bx) 中
    inc bx                      ; (bx)=(bx)+1
    loop s

    mov ax, 4c00h
    int 21h

code ends

end