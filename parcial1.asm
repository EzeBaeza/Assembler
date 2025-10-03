.8086
.model small
.stack 100h
.data
    cartelito db "INGRESE UN TEXTO",0dh,0ah,24h
    texto     db 255 dup (24h),0dh,0ah,24h
    textoSinC db 255 dup (24h),0dh,0ah,24h
    espejo    db 255 dup (24h),0dh,0ah,24h
    salto     db 0dh,0ah,24h
.code
   main proc
   mov ax, @data
   mov ds, ax

   
   mov ah, 9
   mov dx, offset cartelito
   int 21h

   mov bx, 0
;CAJA DE CARGA
cajaCarga:
   mov ah, 1
   int 21h
   cmp al, 0dh
   je finCarga
   mov texto[bx], al
   inc bx
   jmp cajaCarga

finCarga:
;FIN CAJA DE CARGA 

;QUITO PUNTUACIONES
   mov di, 0
   mov si, 0
proceso:
   cmp texto[di], 24h
   je finProceso
   cmp texto[di], '.'
   je esCaracter
   cmp texto[di], ','
   je esCaracter
   cmp texto[di], '?'
   je esCaracter
   cmp texto[di], '!'
   je esCaracter
   mov al, texto[di]
   mov textoSinC[si], al
   inc si
   esCaracter:
   inc di
   jmp proceso

finProceso:
;FIN QUITO PUNTUACIONES

;INVIERTE VARIABLE
    mov cx, bx
    dec bx
    mov si, 0
recorre:

    mov al, texto[bx]
    mov espejo[si], al
    inc si
    dec bx
    loop recorre



;FIN INVIERTE VARIABLE

;IMPRIMIR

   mov ah, 9
   mov dx, offset textoSinC
   int 21h

   mov ah, 9
   mov dx, offset salto
   int 21h

   mov ah, 9
   mov dx, offset espejo
   int 21h


   mov ax, 4c00h
   int 21h
   main endp
end