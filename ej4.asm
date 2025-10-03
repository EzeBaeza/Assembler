;Ingrese un texto de hasta 5 caracteres e imprima en forma de espejo.

.8086
.model small
.stack 100h
.data
	espejo db 5 dup (24h)
	;espejin db 24h,24h,24h,24h,24h
	espejaime db "$$$$$",24h
	bandera db "llegue a la 3ra resolución",0dh,0ah,24h
	;	  HOLAS
	;var2 SALOH


.code
	main proc
	mov ax, @data
	mov ds, ax

	;for (cx=1,i=5,i++)
	mov cx, 5
	mov bx, 0

carga:
		mov ah, 1
		int 21h
		mov espejo[bx], al 
		inc bx
loop carga

	mov ah, 2
	mov dl, 0dh
	int 21h

	mov ah, 2
	mov dl, 0ah
	int 21h

;RESOLUCIÓN 1 CARGA VARIABLE A MANO

	 mov al, espejo[4]
	 mov espejaime[0],al 

	 mov al, espejo[3]
	 mov espejaime[1],al 

	 mov al, espejo[2]
	 mov espejaime[2],al 

	 mov al, espejo[1]
	 mov espejaime[3],al 

	 mov al, espejo[0]
	 mov espejaime[4],al 


mov ah, 9 
mov dx, offset espejaime
int 21h

	mov ah, 2
	mov dl, 0dh
	int 21h

	mov ah, 2
	mov dl, 0ah
	int 21h

;RESOLUCION 2 (solo imprime al reves)

	mov cx, 5
	mov bx, 4

imprime:
		mov ah, 2
		mov dl, espejo[bx]
		int 21h
		dec bx
loop imprime

;LIMPIA VARIABLE CASI SEGURO LES TOMO EN EL EXAMEN
mov bx,0
limpia:                           ;HOLAS$
	cmp espejaime[bx],24h         ;$$$$$$
	je finLimpia
	mov espejaime[bx],24h
	inc bx
	jmp limpia 
finLimpia:

;RESOLUCIÓN 3 - LLENA VARIABLES AUTOMATICAMENTE 1
	mov bx, 0
	mov dx, 4
	mov cx, 5
copia:
												;BX  DX
	push bx ;GUARDO ESTADO EN STACK				;0   4
												;4   3
												;0
	mov al, espejo[bx]
	
	mov bx, dx
	mov espejaime[bx], al
	dec dx

	pop bx ; DEVUELVO ESTADO ANTERIOR
	inc bx
loop copia

	mov ah, 2
	mov dl, 0dh
	int 21h

	mov ah, 2
	mov dl, 0ah
	int 21h
	
	mov ah, 9
	mov dx , offset espejaime
	int 21h

	mov ah, 9
	mov dx, offset bandera
	int 21h

	mov ax, 4c00h
	int 21h
	main endp

end