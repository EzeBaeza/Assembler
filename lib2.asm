.8086
.model small
.code

PUBLIC leer_texto, contar_caracter, imprimir_num

; -----------------------------------------
; Leer texto hasta ENTER (terminador $)
; Entrada: DX = dirección del buffer
; Salida: texto almacenado con '$' al final
; -----------------------------------------
leer_texto proc
    push ax
    push si

    mov si, dx
leer_loop:
    mov ah, 1
    int 21h
    cmp al, 0Dh
    je fin_lectura
    mov [si], al
    inc si
    jmp leer_loop

fin_lectura:
    mov al, '$'
    mov [si], al

    pop si
    pop ax
    ret
leer_texto endp


; -----------------------------------------
; Contar cuántas veces aparece un carácter
; Entrada: SI = dirección del texto, AL = carácter a buscar
; Salida: BL = cantidad de apariciones
; -----------------------------------------
contar_caracter proc 
    push ax
    push si
    mov bl, 0

contar_loop:
    mov ah, [si]
    cmp ah, '$'
    je fin_contar
    cmp ah, al
    jne no_igual
    inc bl
no_igual:
    inc si
    jmp contar_loop

fin_contar:
    pop si
    pop ax
    ret
contar_caracter endp


; -----------------------------------------
; Imprimir número (0–255) en decimal
; Entrada: AL = número a imprimir
; -----------------------------------------
imprimir_num proc
    push ax
    push bx
    push cx
    push dx

    mov ah, 0
    mov bl, 10
    mov cx, 0

convertir:
    cmp al, 0
    je imprimir
    div bl
    push ax
    mov ah, 0
    mov bl, 10
    mov cx, 0

    jmp convertir

imprimir:
    cmp cx, 0
    je fin
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    dec cx
    jmp imprimir

fin:
    mov ah,9
    mov dx, offset salto
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
imprimir_num endp

salto db 0Dh,0Ah,'$'

end
