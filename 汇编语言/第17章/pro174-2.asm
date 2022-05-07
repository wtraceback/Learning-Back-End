assume cs:code

code segment
    ; 将当前屏幕的内容保存在磁盘上
    start:
        mov ax, 0b800h
        mov es, ax
        mov bx, 0           ; 当前屏幕，es:bx 指向将写入磁盘的数据

        mov ah, 3           ; int 13h 的功能号（3 号子程序表示写扇区）
        mov al, 8           ; 读取的扇区数
        mov ch, 0           ; 磁道号
        mov cl, 1           ; 扇区号
        mov dh, 0           ; 磁头号（对软盘即面号，因为一个面用一个磁头来读写）
        mov dl, 0           ; 驱动器号（软驱从 0 开始：0 代表软驱A，1 代表软驱B；硬盘从 80h 开始，80h 代表硬盘C，81h 代表硬盘D）
        int 13h

        mov ax, 4c00h
        int 21h
code ends

end start