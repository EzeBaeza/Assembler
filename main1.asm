.8086

.model small
.stack 100h

.data
	nro db '000',0dh,0ah,24h
	texto db 255 dup (24h),0dh, 0ah,24h
	caracteresMaximos db "AaEeIiOoUu"


.code
	extrn carga:proc

	main proc
	mov ax, @data
	mov ds, ax

	;RECIBE en AH el SERVICIO A UTILIZAR 1, Nros y Bite (0-9 3 digitos), 
	;													2, texto en base a caracterees definidos en variables
	;													3, Texto Libre (Todos los caracteres posibles)

	;Recibe en AL la cantidad de digitos, si esta en 0 la carga termina con 0dh,
	;Devuelve en un OFFSET la variable leida

	lea dx, nro
	mov ah, 1
	mov al, 3
	call carga

	mov ah, 9
	mov dx, offset nro
	int 21h

	lea dx, texto
	mov ah, 2
	mov al, 0
	call carga 

	mov ah, 9
	mov dx, offset texto
	int 21h

	mov ah,4c00h
	int 21

	main endp

end