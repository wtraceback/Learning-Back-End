assume cs:code

code segment
    start:
        mov ax, cs
        mov ds, ax
        mov si, offset int7ch                       ; 设置 ds:si 指向源地址
        mov ax, 0
        mov es, ax
        mov di, 200h                                ; 设置 es:di 指向目的地址
        mov cx, offset int7chend - offset int7ch    ; 设置 cx 为传输长度
        cld                                         ; 设置传输方向为正
        rep movsb

        ; 设置中断向量表
        mov ax, 0
        mov es, ax
        cli
        mov word ptr es:[7ch * 4], 200h
        mov word ptr es:[7ch * 4 + 2], 0
        sti

        mov ax, 4c00h
        int 21h


    ; 新的 int 7ch 中断例程，实现通过逻辑扇区号对软盘进行读写
    ; 参数说明：
    ; 1. 用 ah 寄存器传递功能号：0 表示读，1 表示写；
    ; 2. 用 dx 寄存器传递要读写的扇区的逻辑扇区号；
    ; 3. 用 es:bx 指向存储读出数据或写入数据的内存区。
    int7ch:
        cmp ah, 1
        ja int7chret         ; 当 ah 传递的功能号大于 1 则转移

        push cx
        push dx
        push si
        push di             ; 保护现场，因为调用 int 13h，ax 会存储读写操作的结果，所以 ax 不需要入栈

        mov di, ax          ; 将传递进来的 功能号保存起来
        mov ax, dx          ; 将 逻辑扇区号 放到 ax 中，用于做除法操作
        mov dx, 0           ; 除数为 16 位，因此被除数为 32 位，需要 ax 和 dx
        mov si, 1440
        div si              ; 除数为 16 位，则 AX 存储除法操作的商，DX 存储除法操作的余数
        mov si, ax          ; 将商保存起来
        mov ax, dx          ; 将余数放到 ax 中，还需要做除法
        mov cl, 18
        div cl              ; 除数为 8 位，则 AL 存储除法操作的商，AH 存储除法操作的余数

        mov ch, al          ; 磁道号
        mov cl, ah
        inc cl              ; 扇区号
        mov ax, di          ; ah 为传递进来的 功能号
        add ah, 2           ; int 13h 的功能号
        mov al, 1           ; 读取的扇区数
        mov dx, si
        mov dh, dl          ; 磁头号（对软盘即面号，因为一个面用一个磁头来读写）
        mov dl, 80h         ; 驱动器号（软驱从 0 开始：0 代表软驱A，1 代表软驱B；硬盘从 80h 开始，80h 代表硬盘C，81h 代表硬盘D）

        int 13h             ; 调用 int 13h 来对磁盘进行读写

    int7chret:
        pop di
        pop si
        pop dx
        pop cx              ; 恢复现场
        iret

    int7chend:
        nop
code ends

end start