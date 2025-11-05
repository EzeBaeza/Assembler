	.8086
	.model small
	.stack 100h
	.data
		errorCarga db "***Error en la carga***" ,0dh,0ah,24h
		cantidadCaracteres db 0                     ;variable para carga
		caracteres 	   db ("0123456789ABCDEF")  ;variable para carga
		ok 		   db 0 		    ;variable para carga
		direccionTexto 	   dw 00 		    ;variable para checkCaracter
		modo 		   db 0; 0, TEXTO           ;variable para carga y checkCaracter
				       ; 1, DEC
				       ; 2, HEX
				       ; 3, BIN
		dataMul db 100,10,1 		;variable para asciitoReg
		vecMul db 128,64,32,16,8,4,2,1  ;variable para binToReg
		sumoBin db 0                    ;variable para binToReg 

	.code

	public carga ; Carga caracteres en RAM 
				 ; Carga Finita DL= CANTIDAD o Infinita DL=0
				 ; Caracter de Finalizacion DH=CARACTER
				 ; 
				 ; RESTRICCIONES POR TIPO DE CARGA (BIN, HEX, DEC, TEXTO)
				 ; AH=0, TEXTO
				 ; AH=1, DEC
				 ; AH=2, HEX
				 ; AH=3, BIN
				 ;
				 ; BX offset variable a llenar

	public reinicioCarga 	 ;  
				 ; DH = Caracter para replicar (Ej: 0dh, 24h)
				 ; DL= Cantidad de caracteres a reiniciar:
				 ; 255, TEXTO
				 ; 3, DEC
				 ; 2, HEX
				 ; 8, BIN
				 ;
				 ; BX offset variable a llenar ("reiniciar")
	public limpiaPantalla ;"cls"
	public regtoascii     ;de variable (registro) a decimal en texto
	public regtoHex	      ;de variable (registro) a hexa en texto
	public regtobin       ;de variable (registro) a binario en texto
	public asciitodec     ;decimal en texto a un valor de reg (para montar en una variable)
	public binToReg       ;binario en texto a un valor de reg (para montar en una variable)
	public asciitoReg     ;idem asciitodec pero con loop	
	public imprimir       ;printeo
	public largoCadena    ;suma los caracteres ingresados hasta el '$'
	public cifrar	      ;suma un ascii seleccionado y lo modifica en la cadena
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;FUNCIONES 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cifrar proc
		;OJO con este que tiene que recibir 3 pusheos antes
		;recibe por stack offsets  texto    , textoCif y cantidad 
		;                 		   ss:[bp+8], ss:[bp+6], ss:[bp+4], 
		; suma al contenido de cantidad al caracter en texto
		; y guarda en textoCif

		push bp
		mov bp, sp
		push bx
		push si 
		push ax

			mov bx, ss:[bp+8]
			mov si, ss:[bp+4]
			mov al, byte ptr [si]
			mov si, ss:[bp+6]

		cifrando:
			cmp byte ptr[bx], 24h
			je finCifrado
			mov ah, [bx]
			add ah, al 
			mov [si],ah 
			inc si
			inc bx

		jmp cifrando

	finCifrado:
		pop ax
		pop si
		pop bx
		pop bp
		ret 6
	cifrar endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
carga proc
	;caja de carga super ninja

			push cx
			push bx
			mov cantidadCaracteres, dl
			mov direccionTexto, bx
			mov modo, ah
	comienzaCarga:
			xor cx, cx
			cmp dl,0
			je infinita
			mov cl, cantidadCaracteres
	finita:
		mov ah, 1
		int 21h
		call checkCaracter
		cmp al, 3
		je limpia
		mov byte ptr[bx],al 
		inc bx
	loop finita
		jmp finCarga

	infinita:
		mov ah, 1
		int 21h
		cmp al, dh	
		je finInfinita
		call checkCaracter
		cmp al, 3
		je limpia
		mov byte ptr[bx],al 
		inc bx
		jmp infinita

	finInfinita:
	jmp finCarga

	limpia:
		push dx
		push ax
		mov ah, 9
		mov dx, offset errorCarga
		int 21h
		pop ax 
		pop dx

		mov bx, direccionTexto
	procLimpieza:
		cmp byte ptr[bx], 24h
		je finLimpia
		mov byte ptr[bx], 24h
		inc bx
	jmp procLimpieza
	finLimpia:
		mov bx, direccionTexto
		jmp comienzaCarga

	finCarga:
		
		mov ah, 08h
		int 21h
		
		pop bx
		pop cx

		ret

	carga endp


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
checkCaracter proc 
	;RECIBE EN AL UN CARACTER y DEPENDIENDO DEL VALOR DE LA VARIBLE
	;MODO CHEQUEA SI ES CORRECTO EL MISMO 

			push cx 
			push si

			mov ok, 0

			cmp modo, 0 
			je finCheckCaracter
			cmp modo, 1 
			je esDec
			cmp modo, 2 
			je esHex
			cmp modo, 3 
			je esBin
		esDec:
			mov si, 0
			mov cx, 10
		checkDec:	
			cmp al, caracteres[si]
			je encontre
			inc si
		loop checkDec
			mov al, 3
			jmp finCheckCaracter

		esHex:
			mov si, 0
			mov cx, 16
		checkHex:	
			cmp al, caracteres[si]
			je encontre
			inc si
		loop checkHex
			mov al, 3
			jmp finCheckCaracter
		esBin:
			mov si, 0
			mov cx, 2
		checkBin:	
			cmp al, caracteres[si]
			je encontre
			inc si
		loop checkBin
			mov al, 3
			jmp finCheckCaracter

		encontre:
			mov ok, 1
			jmp finCheckCaracter

	finCheckCaracter:
		pop si
		pop cx

		ret
	checkCaracter endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
regtoascii proc  
	;recibe en bx el offset de una variable de 3 bytes, y el numero a convertir por dl no mayor a 255

	        push ax
	        push dx

		add bx,2
		xor ax,ax
		mov al, dl
		mov dl, 10
		div dl
		add [bx],ah

		xor ah,ah
		dec bx
	        div dl
		add [bx],ah

		xor ah,ah
		dec bx
	        div dl
		add [bx],ah

	        pop dx
	        pop ax

	        ret
	regtoascii endp


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

regtoHex proc  
	;recibe en bx el offset de una variable de 2 bytes, y el numero a convertir por dl no mayor a 255
	        push ax
	        push dx

		add bx,1
		xor ax,ax
		mov al, dl
		mov dl, 16
		div dl
		cmp ah, 9
		ja esLetra
		add [bx],ah

	prox:
		xor ah,ah
		dec bx
	    div dl
	    cmp ah, 9
		ja esLetra2    
		add [bx],ah
		jmp finRegHex

		esLetra:
			mov [bx], ah
			add byte ptr [bx], 55
		jmp prox
		esLetra2:
			mov [bx], ah
			add  byte ptr[bx], 55


	finRegHex:
	        pop dx
	        pop ax

	        ret
	regtoHex endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asciitodec proc 
	;RECIBE EN BX EL OFFSET DE UNA VARIABLE DE 3 DIGITOS ASCII Y DEVUELVE EN CX LA CANTIDAD NUMERICA

	        push ax
	        push bx
	        push dx

	        mov cx, 0
	        sub byte ptr [bx], 30h ;30h
	        mov al, [bx]  ;0
	        mov dl, 100
	        mul dl 
	        add cx, ax 

	        inc bx
	        sub byte ptr [bx], 30h
	        mov al, [bx]
	        mov dl,10
	        mul dl
	        add cx,ax

	        inc bx
	        sub byte ptr [bx], 30h
	        add cl, [bx]

	        pop dx
	        pop bx
	        pop ax

	        ret
	asciitodec endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprimir proc
	;printeo

		push bp
		mov bp, sp
		push dx
		push ax
		mov dx, ss:[bp+4]

		mov ah,9
		int 21h

		pop ax
		pop dx
		pop bp
		ret 2

	imprimir endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

largoCadena proc
	;recibe en bx el offset de una variable devuelvo cantidad de caracteres hasta encontrar $ en cx

		xor cx, cx 
		push bx
	largo:
		cmp byte ptr [bx], 24h 
		je fin
		inc bx
		inc cx 
		jmp largo

	fin:
	 	pop bx
	 ret
	largoCadena endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



reinicioCarga proc 
	;reinicio variables de tipo texto

		push bp
		mov bp, sp
		push cx
		push si
		push dx

		mov si, ss:[bp+4]

		mov cl, dl
	cargaX:
		mov byte ptr[si], dh
		inc si
	loop cargaX
		
		pop dx 
		pop si 
		pop cx 
		pop bp 

		ret 2

	reinicioCarga endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

limpiaPantalla proc 
		
		push ax

		mov ah, 0fh	
		int 10h		
		mov ah, 0	
		int 10h

		pop ax

		ret 

	limpiaPantalla endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

regtobin proc
	;recibe en DX un numero en hexa, y en BX una variable de 8 ceros

		push bp
		mov bp, sp

		push dx
		push cx
		push bx

		mov bx, ss:[bp+4]
		mov cx, 8

		shiftea:
			shl dl, 1
			jc esUno
			mov byte ptr [bx],30h
			jmp incre

		esUno:
			mov byte ptr [bx], 31h
		
		incre:
			inc bx
		loop shiftea

		pop bx
		pop cx
		pop dx
		pop bp
		ret 2
	regtobin endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

binToReg proc
	;recibe un binario por BX y lo cambia a ascii por CL

		push ax
		push dx
		push bx

		xor di, di
		mov cx,8
	aca:
		mov al, byte ptr[bx] ;muevo a AL el primer ascii binario a multiplicar
		sub al, 30h ;le resto 30h al "1" o "0"
		mov dl,  vecMul [di] ;muevo a DL el primer 128 para hacer la multiplicacion
		mul dl
		add sumoBin, al
		inc bx
		inc di
	loop aca
		
		mov ch, 0
		mov cl, sumoBin
		pop bx
		pop dx
		pop ax
		ret

	binToReg endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asciitoReg proc
	;como asciitodec pero son loop - 
	;recibe un valor decimal por BX y emite un ascii por CL

		push bx
		;push cx 
		push ax 

		xor si,si
		xor cx, cx
	proceso:						 
		mov ah, 0 				
		mov al, byte ptr[bx]		
		sub al, 30h					
		mov dl, dataMul[si] 	
		mul dl 				
		add cl, al 				
								;
		inc bx
		inc si					
		cmp si,3 

		je finProceso		
	jmp proceso 			

	finProceso:
		
		pop ax
		;pop cx 
		pop bx

		ret 2
	asciitoReg endp

end