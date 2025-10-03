;;ascii2Reg

.8086
.model small
.stack 100h

.data
	var db 0
	nroAscii db '159',0dh,0ah,24h
	dataMul  db 100,10,1
.code
	main proc
	mov ax, @data
	mov ds, ax

	;VERSION AUTOMÁTICA
	mov cx, 3
	mov bx, 0

ascii2reg:
	mov ah, 0
	mov al, nroAscii[bx] ; TENGO EN AL el 31h 
	sub al, 30h         ; TENGO EN AL EL 1
	mov dl, dataMul[bx]
	mul dl 
	add var, al 
	inc bx

loop ascii2reg


	;FIN VERSIÓN AUTOMÁTICA
	

	mov ah, 0
	mov al, nroAscii[0] ; TENGO EN AL el 31h 
	sub al, 30h         ; TENGO EN AL EL 1
	mov dl, 100
	mul dl 
	add var, al 

	mov ah, 0
	mov al, nroAscii[1] ; TENGO EN AL el 35h 
	sub al, 30h         ; TENGO EN AL EL 5
	mov dl, 10
	mul dl 
	add var, al 

	mov ah, 0
	mov al, nroAscii[2] ; TENGO EN AL el 39h 
	sub al, 30h         ; TENGO EN AL EL 9
	mov dl, 1
	mul dl 
	
	add var, al 



	mov ax, 4c00h
	int 21h

	main endp
end