.8086
.model small
.stack 100h
.data

    menu1 db 0Dh,0Ah,"MENU PRINCIPAL",0Dh,0Ah,'$'
    menu2 db "1. Leer Texto",0Dh,0Ah,'$'
    menu3 db "2. Seleccionar Letra y Contar",0Dh,0Ah,'$'
    menu4 db "3. Imprimir Cantidad de Letras del ultimo texto",0Dh,0Ah,'$'
    menu5 db "4. Imprimir Cantidad de Letras Total",0Dh,0Ah,'$'
    menu6 db "5. Salir",0Dh,0Ah,'$'
    menu7 db "Seleccione una opcion: $"

    texto           db 255 dup('$')
    mensajeTexto    db 0Dh,0Ah,"Ingrese texto: $"
    mensajeChar     db 0Dh,0Ah,"Ingrese caracter a buscar: $"
    mensajeUltimo   db 0Dh,0Ah,"Cantidad de caracteres en el ultimo texto: $"
    mensajeTotal    db 0Dh,0Ah,"Cantidad total de caracteres contados: $"
    saltoLinea      db 0Dh,0Ah,"$"
    
    caracter        db ?
    cantUltimo      db 0
    cantTotal       db 0

.code

extrn leer_texto:proc
extrn contar_caracter:proc
extrn imprimir_num:proc

main proc
    mov ax, @data
    mov ds, ax

inicio:

    mov ah,9
    mov dx,offset menu1
    int 21h
    mov dx,offset menu2
    int 21h
    mov dx,offset menu3
    int 21h
    mov dx,offset menu4
    int 21h
    mov dx,offset menu5
    int 21h
    mov dx,offset menu6
    int 21h
    mov dx,offset menu7
    int 21h

    mov ah,1
    int 21h
    sub al,'0'      
    mov bl,al

    cmp bl,1
    je opcion1
    cmp bl,2
    je opcion2
    cmp bl,3
    je opcion3
    cmp bl,4
    je opcion4
    cmp bl,5
    je salir
    jmp inicio

opcion1:
    mov ah,9
    mov dx, offset mensajeTexto
    int 21h

    lea dx, texto
    call leer_texto

    ; Mostrar salto de línea
    mov ah,9
    mov dx, offset saltoLinea
    int 21h

    ; Mostrar el texto ingresado
    mov ah,9
    mov dx, offset texto
    int 21h

    jmp inicio


opcion2:
    mov ah,9
    mov dx,offset mensajeChar
    int 21h

    mov ah,1
    int 21h
    mov caracter,al

    lea si,texto
    mov al,caracter
    call contar_caracter

    mov cantUltimo,bl
    add cantTotal,bl
    jmp inicio

opcion3:
    mov ah,9
    mov dx,offset mensajeUltimo
    int 21h

    mov al,cantUltimo
    call imprimir_num
    jmp inicio

opcion4:
    mov ah,9
    mov dx,offset mensajeTotal
    int 21h

    mov al,cantTotal
    call imprimir_num
    jmp inicio

salir:
    mov ah,9
    mov dx,offset saltoLinea
    int 21h
    mov ah,9
    mov dx,offset saltoLinea
    int 21h
    mov ah,9
    mov dx,offset saltoLinea
    int 21h

    mov ah,4Ch
    int 21h
main endp
end main
