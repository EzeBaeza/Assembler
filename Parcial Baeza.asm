.8086
.model small
.stack 100h

.data
    cartel1     db "Ingrese un texto de hasta 20 caracteres:", 0dh, 0ah, 24h
    cartel2     db 0dh, 0ah, "Ingrese la PRIMERA letra a reemplazar:", 0dh, 0ah, 24h
    cartel3     db 0dh, 0ah, "Ingrese la SEGUNDA letra a reemplazar:", 0dh, 0ah, 24h
    cartel4     db 0dh, 0ah, "Texto modificado:", 0Dh, 0Ah, 24h
    cartel5     db 0dh, 0ah, "Cantidad de reemplazos: ", 24h
    cartel6     db 0dh, 0ah, "Largo del texto: ", 24h
    cartelErr   db 0dh, 0ah, "Error: Maximo 20 caracteres, vuelva a intentarlo", 0dh, 0ah, 24h
    texto       db 21 dup (24h)
    letra1      db 0
    letra2      db 0


.code
    main proc
    mov ax, @data
    mov ds, ax

inicio:

    mov cx, 20
    mov si, offset texto

    mov ah, 9
    mov dx, offset cartel1
    int 21h

    mov bx, 0

carga:
    mov ah, 1
    int 21h

    cmp al, 0dh
    je fincarga

    cmp bx, 20
    ja error

    mov texto[bx], al
    inc bx
    jmp carga

error:

    mov ah, 9
    mov dx, offset cartelErr
    int 21h
    jmp inicio

fincarga:
 
    mov texto[bx], 24h



    mov ah, 9
    mov dx, offset cartel2
    int 21h

    mov ah, 1
    int 21h
    mov letra1, al

    mov ah, 9
    mov dx, offset cartel3
    int 21h

    mov ah, 1
    int 21h
    mov letra2, al

    mov si, 0
    mov cx, 0

buscar:

    cmp texto[si], 24h
    je mostrar

    mov al, texto[si]

    cmp al, letra1
    je reemplazo

    cmp al, letra2
    je reemplazo

    jmp seguir

reemplazo:
    mov texto[si], '#'
    inc cx

seguir:
    inc si
    jmp buscar
mostrar:
 
    mov ah, 9
    mov dx, offset cartel4
    int 21h

    mov ah, 9
    mov dx, offset texto
    int 21h

    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    mov ah, 9
    mov dx, offset cartel5
    int 21h

    mov al, cl
    mov bl, 10
    mov ah, 0

    div bl

    mov dl, al
    add dl, '0'
    mov ah, 02h
    int 21h

    mov dl, ah
    add dl, '0'
    mov ah, 02h
    int 21h

    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    mov ah, 9
    mov dx, offset cartel6
    int 21h

    mov al, bl
    mov bl, 10
    mov ah, 0

    div bl

    mov dl, al
    add dl, '0'
    mov ah, 02h
    int 21h

    mov dl, ah
    add dl, '0'
    mov ah, 02h
    int 21h

    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    mov ax, 4C00h
    int 21h
    main endp
end main