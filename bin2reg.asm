;COSAS A BINARIO
;BINARIO A COSAS

.8086
.model small
.stack 100h

.data
	bin 	db 8 dup ('0'), 0dh, 0ah, 24h
	bin2 	db '00000000', 0dh, 0ah, 24h
	salto 	db 0dh, 0ah, 24h

.code

main proc

mov ax, @data
mov ds, ax

mov bx, 0

arriba:

	mov ah, 1 
	int 21h
	cmp al, 30h
	je esCero
	cmp al, 31h
	je esUno
	jmp arriba

esCero:


esUno:
	cmp bx, 8
	je finCarga
	mov bin[bx], al 
	inc bx
	jmp arriba

finCarga:
	xor dl, dl
	mov cx, 8
	mov bx, offset bin
	
convierte:
	cmp byte ptr [bx], 30h
	je cargueCero
	shl dl, 1
	inc dl

incrementa:
	inc bx
	loop convierte 
	jmp reg2bin

cargueCero:
	shl dl, 1 
	jmp incrementa


reg2bin:
	mov bx, offset bin2
	mov cx, 8
proceso:
	shl dl, 1
	jc eraUno
incre:
	inc bx
loop proceso

jmp fin 
eraUno:
	inc byte ptr [bx]
	jmp incre 

fin:

	mov ah,9
	lea dx, salto 
	int 21h

	mov ah,9
	lea dx, bin 
	int 21h

	mov ah, 9
	lea dx, bin2
	int 21h

	mov ax, 4c00h
	int 21h
main endp
end