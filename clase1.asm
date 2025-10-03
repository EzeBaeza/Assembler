.8086 
.model small
.stack 100h
.data
	menu db "Ingrese 1 para imprimir el cartel 1", 0dh, 0ah
		 db	"Ingrese 2 para imprimir el cartel 2", 0dh, 0ah
		 db	"Ingrese 3 para imprimir el cartel 3", 0dh, 0ah, 24h

	cartel1 db "Cartel 1", 0dh, 0ah, 24h
	cartel2 db "Cartel 2", 0dh, 0ah, 24h
	cartel3 db "Cartel 3", 0dh, 0ah, 24h
.code 

	main proc
	mov ax, @data
	mov ds, ax

	mov ah, 9
	mov dx, offset menu
	int 21h

	mov ah, 1 ;LLamo al servicio de lectura de teclado
	int 21h
	cmp al, "1" 
	je imprime1
	cmp al, "2" 
	je imprime2
	cmp al, "3" 
	je imprime3

imprime1:
	mov ah, 9
	mov dx, offset imprime1
	int 21h
jmp fin

imprime2:
	mov ah, 9
	mov dx, offset imprime2
	int 21h
jmp fin

imprime3:
	mov ah, 9
	mov dx, offset imprime3
	int 21h
jmp fin

fin:
	mov ax, 4c00h
	int 21h
	main endp
end