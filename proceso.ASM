.8086
.model small
.stack 100h

.data
		varproc db 0dh, 0ah, "entre al programa proceso$"
		varsubproc db 0dh, 0ah, "entre al sub proceso$"
		;variables utilizadas en la libreria
.code

public proceso


proceso proc
	;aca hacemos las otras cosas
        ;tambien podemos llamar a procesos internos que no son publicos
	mov ah, 9
	mov dx, offset varproc 
	int 21h
	call subproc
        ret

proceso endp

subproc proc
	mov ah, 9
	mov dx, offset varsubproc 
	int 21h
        ret
subproc endp

end ;asi terminamos la libreria
