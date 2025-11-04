.8086
.model small
.stack 100h
.data
	var db "entre al programa principal $"
	
.code

extrn proceso:proc ;llamada a procedimiento externo

main proc

	mov ax,@data
	mov ds, ax

	;ACA VA LO QUE DEBEMOS HACER
	;entre ello podemos hacer un

	mov ah, 9
	mov dx, offset var
	int 21h
 
	call proceso
	call subproc


final:  xor ax,ax
	mov ax, 4C00h
	int 21h

main endp
end main

