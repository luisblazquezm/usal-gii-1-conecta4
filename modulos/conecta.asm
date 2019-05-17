	.module conecta

fin     	.equ  	0xFF01
pantalla	.equ  	0xFF00
teclado		.equ  	0xFF02

final1:		.ascii "!!ENHORABUENA \33[31mJugador 1(O)\33[37m!!\33[31mHas \33[33mganado \33[32mla \33[34mpartida\33[37m"
		.byte   10      
        	.byte   0       

final2:		.ascii "!!ENHORABUENA \33[33mJugador 2(X)\33[37m!! \33[31mHas \33[33mganado \33[32mla \33[34mpartida\33[37m"
		.byte   10      
        	.byte   0       
;Variables LOCALES---------------

contador:	.byte	0
indice_compr:	.byte 0		
				
;VARIABLES GLOBALES (MAIN)------

	.globl	posicion	
	.globl	ficha	
	.globl  vector_tablero	
	.globl 	pos_ficha
;ETIQUETAS GLOBALES------------

	.globl	conecta_tablero
	.globl	imprimir_mensaje

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	conecta							       ;
;	   realiza las comprobaciones oportunas de		       ;
;	   vertical,horizontal y diagonal			       ;
;								       ;
;								       ;
;	   >Entrada: posicion de la ultima ficha introducida y         ;
;		     ficha  X u O introducida			       ;
;          >Salida: mensaje_victoria o ninguno			       ;
;	   >Registros afectados: X,A,B, CC			       ;
;	   >SUBRUTINAS AUXILIARES: imprimir_mensaje		       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	conecta							       ;
;	   ultima posicion introducida= X		               ;
; Vertical	Horizontal	Diagonal Izquierda    Diagonal Derecha ;
;    X	  			   _			        _      ;
;    _	  			    _			       _       ;
;    _	  	 _ _ X _      	     X			      X	       ;
;    _      		      	      _			    _	       ;
;	   			      				       ;
;	   		      					       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


conecta_tablero:
	pshu	a,x,b
	lda	ficha
	cmpa	#'O
	beq	conecta_Jugador1
	cmpa	#'X
	beq	conecta_Jugador2

conecta_Jugador1:
	jsr	vertical
	jsr	horizontal
	jsr	diagonal

	pulu	a,x,b			
	rts							;======>REGRESA AL MODULO MAIN<=======
conecta_Jugador2:
	jsr	vertical
	jsr	horizontal
	jsr	diagonal
	
	pulu	a,x,b
	rts							;======>REGRESA AL MODULO MAIN<=======

;VERTICAL DE PLAYER 1 Y 2-------------------------
vertical:
	lda	posicion
	cmpa	#20
	bhi	horizontal					;Si es mayor que 20 no se comprueba hasta que haya fichas (por lo menos)en la fila 4 
	ldx	#vector_tablero					
	ldb	posicion					;Ultima posicion introducida por el jugador

vertical_while:	
	lda	contador
	cmpa	#4
	lbeq	terminarJuego

	clra

	lda	b,x						;Comprueba las 3 posiciones de las filas por debajo
	cmpa	ficha
	bne	vertical_salir

	addb	#7						;Baja de fila(7 posiciones por fila)
	lda	contador
	inca
	sta	contador

	bra	vertical_while

vertical_salir:
	clr	contador
	pulu	a,x,b
	rts
;FIN VERTICAL DE PLAYER 1 Y 2----------------------

;HORIZONTAL DE PLAYER 1 Y 2------------------------
horizontal:
	ldx	#vector_tablero					
	ldb	posicion
	
	lda	pos_ficha	
	sta	indice_compr					;Contador para saber cuantas posiciones hay a la derecha e izquierda de la ficha introducida
adelante:							;Desde la posicion de la ultima ficha introducida
	lda	contador					;Con un contador cuenta el numero de fichas iguales a ella que hay por delante
	cmpa	#3
	lbeq	terminarJuego

	incb

	lda	indice_compr					;7 es el numero de columnas
	cmpa	#7
	lbeq	seguir_horizontal				;Si no hay mas fichas a la derecha pasamos a comprobar cuantas fichas hay a la izquierda

	lda	indice_compr					;Incrementamos el indice para saber si hay mas fichas a la derecha en la proxima iteracion
	inca
	sta	indice_compr
	clra
	lda	b,x
	cmpa	ficha
	bne	seguir_horizontal
	
								;Avanza una posicion hacia delante cada vez
	lda	contador
	inca
	sta	contador

	clra

	bra	adelante

seguir_horizontal:
	ldx	#vector_tablero	
	ldb	posicion
	lda	#1
	sta	indice_compr					
atras:								;Regresa a la ultima posicion que se introdujo
	lda	contador					;Con un contador cuenta el numero de fichas iguales a ella que hay por detras de la posicion
	cmpa	#3						
	lbeq	terminarJuego
	
	
	lda	indice_compr					;Comprobamos cuantas posiciones hay a la izquierda de la ficha introducida
	cmpa	pos_ficha
	
	lbeq	horizontal_salir				;Si no hay salimos de la comprobacion horizontal
	inca							;Incrementamos el indice para saber si hay mas fichas a la izquierda en la proxima iteracion
	sta	indice_compr
	clra
								
	decb							;Retrocede una posicion hacia atras cada vez
	lda	b,x
	cmpa	ficha
	bne	horizontal_salir

	lda	contador
	inca
	sta	contador

	clra

	bra	atras

horizontal_salir:
	clr	contador
	pulu	a,x,b
	rts
;FIN HORIZONTAL DE PLAYER 1 Y 2------------------------

;DIAGONAL DE PLAYER 1 Y 2------------------------------
diagonal:	
	ldx	#vector_tablero					;<----------------DIAGONAL DE PLAYER 1 Y 2 
	ldb	posicion					;Desde la posicion de la ultima ficha introducida
	
	lda	#1
	sta	indice_compr
diagon_izquierdaAdelante:					;>>>>DIAGONAL POR LA IZQUIERDA
	lda	contador					;Con un contador cuenta el numero de fichas iguales a ella que hay por delante hacia el lado izquierdo
	cmpa	#3
	lbeq	terminarJuego

	lda	indice_compr					
	cmpa	pos_ficha
	lbeq	seguir_diagonal_izquierdaAdelante
	inca
	sta	indice_compr
	clra
	subb	#8
	lda	b,x
	cmpa	ficha
	bne	seguir_diagonal_izquierdaAdelante

								;Retrocede una posicion y una fila hacia atras cada vez
	lda	contador
	inca
	sta	contador

	clra

	bra	diagon_izquierdaAdelante

seguir_diagonal_izquierdaAdelante:
	ldx	#vector_tablero		
	ldb	posicion						
	lda	pos_ficha
	sta	indice_compr
diagon_izquierdaAtras:				
	lda	contador					;Con un contador cuenta el numero de fichas iguales a ella que hay por detras hacia el lado izquierdo
	cmpa	#3
	lbeq	terminarJuego

	lda	indice_compr
	cmpa	#7
	lbeq	seguir_diagonal_derecha
	inca
	sta	indice_compr
	clra
	addb	#8						;Retrocede una posicion y una fila hacia adelante cada vez

	lda	b,x
	cmpa	ficha
	bne	seguir_diagonal_derecha

	lda	contador
	inca
	sta	contador

	clra

	bra	diagon_izquierdaAtras

seguir_diagonal_derecha:
	clr	contador
	ldx	#vector_tablero						
	ldb	posicion					;Regresa a la ultima posicion que se introdujo
	lda	pos_ficha
	sta	indice_compr	
diagon_derechaAdelante:	
	lda	contador					;>>>>DIAGONAL POR LA DERECHA
	cmpa	#3
	lbeq	terminarJuego
	lda	indice_compr
	cmpa	#7
	lbeq	seguir_diagonal_derechaAdelante
	inca
	sta	indice_compr
	clra
	subb	#6
	lda	b,x
	cmpa	ficha
	bne	seguir_diagonal_derechaAdelante

								;Avanza una posicion y retrocede una fila hacia atras cada vez
	lda	contador
	inca
	sta	contador

	clra

	bra	diagon_derechaAdelante

seguir_diagonal_derechaAdelante:
	ldx	#vector_tablero	
	ldb	posicion			
	lda	#1
	sta	indice_compr
diagon_derechaAtras:				
	lda	contador
	cmpa	#3
	lbeq	terminarJuego
	lda	indice_compr
	cmpa	pos_ficha
	lbeq	diagonal_salir
	inca
	sta	indice_compr
	clra
	addb	#6					       ;Avanza una posicion y una fila hacia adelante cada vez
	lda	b,x
	cmpa	ficha
	bne	diagonal_salir

	lda	contador
	inca
	sta	contador

	clra

	bra	diagon_derechaAtras

diagonal_salir:
	clr	contador
	pulu	a,b,x
	rts	
;FIN DIAGONAL DE PLAYER 1 Y 2------------------------------

terminarJuego:
	lda	ficha
	cmpa	#'O
	beq	victoria_Jugador1
	cmpa	#'X
	beq	victoria_Jugador2

victoria_Jugador1:
	ldx	#final1
	jsr	imprimir_mensaje

	clra
	sta	fin

victoria_Jugador2:
	ldx	#final2
	jsr	imprimir_mensaje

	clra
	sta	fin

	



