.8086

.model small
.stack 100h

.data
	caracteres 	db "0123456789",
				db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0A5h,0B5h,090h,092h,0E0h,09Ah
				db "abcdefghijklmnopqrstuvwxyz",0A4h,0A0h,082h,0A1h,0A2h,0A3h,081h, 01h 


.code
public carga
	;RECIBE en AH el SERVICIO A UTILIZAR 1, Nros y Bite (0-9 3 digitos), 
	;													2, texto en base a caracterees definidos en variables
	;													3, Texto Libre (Todos los caracteres posibles)

	;Recibe en AL la cantidad de digitos, si esta en 0 la carga termina con 0dh,
	;Devuelve en un OFFSET la variable leida


	carga proc
	push bx
	push dx

	mov bx, dx

	cmp ah, 1
	je leeNro
	cmp ah, 2
	je textoFijo
	cmp ah, 3
	je textoLibre
	jmp fin

	leeNro:
		add dx, 3
	nros:
		cmp dx, bx
		je finOk
		mov ah, 8
		int 21h
		cmp al, 30h
		jae casiNro
	jmp nros
	casiNro:
		cmp al, 39h
		jbe esNro
	jmp nros
	esNro:
		push dx
		push ax
			mov ah, 2
			mov dl, al 
			int 21h
		pop ax
		pop dx
		mov byte ptr[bx], al
		inc bx
		jmp nros
;SERVICIO 2 LEO CARACT FIJOS
	textoFijo:
		mov si, offset caracteres
	cargoNuevo:
		mov ah, 1
		int 21h
		cmp al, 0dh
		je finCarga
	comparoNuevo:
		cmp al, [si]
		je guardo
		cmp byte ptr[si], 01h
		je textoFijo
		inc si
	jmp comparoNuevo

	guardo: 
		push dx
		push ax

		mov ah, 2
		mov dl, al 
		int 21h

		pop ax
		pop dx
		mov [bx], al 
		inc bx
	jmp textoFijo

textoLibre: 
fin:
	mov ah, 99

finCarga:
finOk:
	pop dx
	pop bx
	ret

	carga endp

cuentac proc
	;RECIBE EN BX EL OFFSET DE UNA VARIABLE
	;DEVUELVE EN CX LA CANTIDAD DE CARACTERES QUE TIENE
push bx
	mov cx, 0
cuenta:
	cmp byte ptr[bx], 01h 
	je finCuenta
	inc cx
	inc bx
jmp cuenta
finCuenta:
pop bx
ret 

cuentac endp

end