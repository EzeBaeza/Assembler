.8086
.model small
.stack 100h

.data
	textoInicio db "Bienvenido al sistema",0dh,0ah
	textoInicio2 db "Ingrese la opcion que desea ingresar",0dh,0ah
	textoInicio3 db "1/Decimal",0dh,0ah
	textoInicio4 db "2/Binario",0dh,0ah,24h

	textoError db "Ingrese una de las opciones propuestas",0dh,0ah
	textoError2 db "Presione una tecla",0dh,0ah,24h

	textoModif db "Ingrese el numero a modificar",0dh,0ah,24h

	textoModBin db "Convertir Bin en..",0dh,0ah
	textoModBin1 db "1/Hexa",0dh,0ah
	textoModBin2 db "2/Deci",0dh,0ah,24h
	
	textoModDec db "Convertir Decimal en..",0dh,0ah
	textoModDec1 db "1/Hexa",0dh,0ah
	textoModDec2 db "2/Bin",0dh,0ah,24h

	texto db 255 dup (24h),0dh,0ah,24h
	cifraAscii db "000" ,0dh,0ah,24h
	cifraBin db "00000000" ,0dh,0ah,24h

	cantidadDec db "000",0dh,0ah,24h
	cantidadHex db "00",0dh,0ah,24h
	valor       db 0

.code

extrn carga:proc ; Carga caracteres en RAM 
			 ; Carga Finita DL= CANTIDAD o Infinita DL=0
			 ; Caracter de Finalizacion DH=CARACTER
			 ; 
			 ; RESTRICCIONES POR TIPO DE CARGA (BIN, HEX, DEC, TEXTO)
			 ; AH=0, TEXTO
			 ; AH=1, DEC
			 ; AH=2, HEX
			 ; AH=3, BIN
			 ; BX offset variable a llenar

extrn regtoascii:proc
extrn regtoHex:proc
extrn asciitodec:proc
extrn imprimir:proc
extrn limpiaPantalla:proc
extrn regtobin:proc
extrn binToReg:proc

main proc
	mov ax, @data
	mov ds, ax

inicio:
;menu de seleccion de carga, bin o dec

	call limpiaPantalla
	lea dx, textoInicio
	push dx
	call imprimir

	mov ah, 1
	int 21h
	cmp al, '1'
	je cargaDec
	cmp al, '2'
	je cargaBin
jmp inicio

cargaBin:
;carga de num binario

	call limpiaPantalla

	lea bx,textoModif
	push bx
	call imprimir

	lea bx, cifraBin
	mov dl, 8
	mov ah, 3
	call carga
	cmp al, 1
	je cargaBin

;paso al binario a registro y lo vuelvo en cifra
	call binToReg
	mov valor, cl

jmp convertirEn2

cargaDec:
;carga de num decimal

	call limpiaPantalla

	lea bx,textoModif
	push bx
	call imprimir

	lea bx, cifraAscii
	mov dl, 3
	mov ah, 1
	call carga

;compara la cifra con 255, como pide el ej
;si es mayor vuelve a pedir otra cifra
	call asciitodec
	cmp cx, 255
	ja cargaDec
	mov valor, cl
jmp convertirEn1

convertirEn1:
;consulta sobre conversion de decimal a bin o hex

	lea bx, textoModDec
	push bx
	call imprimir

	mov ah, 1
	int 21h
	cmp al, '1'
	je convertirHex
	cmp al, '2'
	je convertirBin
jmp convertirEn1

convertirHex:
;conversion en hex de bin o dec (uso variable cargada desde cl)

	mov ah, 2
	mov dl, 0ah
	int 21h

;calculamos la cantidad en hex de la cadena
	mov dl, valor
	mov bx, offset cantidadHex
	call regtoHex

;imprimimos la cantidad en hex
	lea bx, cantidadHex
	push bx
	call imprimir

jmp fin

convertirBin:

	mov ah, 2
	mov dl, 0ah
	int 21h

;calculamos la cantidad en bin de la cadena
	mov dl, valor
	lea bx, cifraBin
	push bx
	call regtobin

;imprimimos la cantidad en bin
	lea bx, cifraBin
	push bx
	call imprimir
jmp fin

convertirEn2:
;consulta sobre conversion de decimal a bin o hex

	mov ah, 2
	mov dl, 0ah
	int 21h

	lea bx, textoModBin
	push bx
	call imprimir

	mov ah, 1
	int 21h
	cmp al, '1'
	je convertirHex
	cmp al, '2'
	je convertirDec
jmp convertirEn2

convertirDec:
;conversion en dec de bin

	mov ah, 2
	mov dl, 0ah
	int 21h

;calculamos la cantidad en decimal de la cadena
	mov dl, valor
	lea bx, cantidadDec
	push bx
	call regtoascii

;imprimimos la cantidad en decimal
	lea bx, cantidadDec
	push bx
	call imprimir

fin:
	mov ax, 4c00h
	int 21h
main endp

end

