		.module tablero

pantalla	.equ  	0xFF00
teclado		.equ  	0xFF02

;Variables LOCALES--------------

pos_inicial:	.byte	0		;El contador del recorrido de la matriz empieza en 0
count:		.byte	0		;Contador interno para iterar y llevar la cuenta del contorno del tablero
count_tablero:	.byte	0		;Contador que lleva el numero de filas del vector_tablero principal
siete:		.byte   0		;Contador que se incrementa cada 7 y lleva la cuenta de cada fila del tablero
numero:		.byte  48		;Representa en codigo ASCII el 0 y sirve para poner el numero de cada columna en el tablero
numero_aux:	.byte   0		;Guarda el contenido de los numeros en codigo ASCII sin tener que cambiar el contenido de "numero"

;VARIABLES GLOBALES (MAIN)------

	.globl  vector_tablero	

;ETIQUETAS GLOBALES------------

	.globl	interfaz_tablero
	.globl	imprimir_mensaje

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	interfaz_tablero				               ;
;	   saca por pantalla el menu principal			       ;
;	   y la peticion de una de las opciones			       ;
;								       ;
;								       ;
;	   >Entrada: vector_tablero			               ;
;          >Salida: contorno del tablero de juego		       ;
;	   >Registros afectados: X,A,B, CC		               ;
;	   >SUBRUTINAS AUXILIARES: imprimir_mensaje		       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								       ;
;		  * 0  1  2  3  4  5  6*			       ;
;		  * 7  8  9 10 11 12 13*			       ;
;	          *14 15 16 17 18 19 20*			       ;
;	          *21 22 23 24 25 26 27*			       ;
;	          *28 29 30 31 32 33 34*			       ;
;	          *35 36 37 38 39 40 41*			       ;
;	          **********************                               ;
;	          *1ª|2ª|3ª|4ª|5ª|6ª|7ª*			       ;					  
;				                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


interfaz_tablero:
	pshu	a,x,b	
	lda	#'\n
	sta	pantalla
							;Crea el contorno o interfaz grafica del tablero con los asteriscos
	ldb	pos_inicial
	ldx	#vector_tablero
	lda	siete					
	adda	#7
	sta	siete					;Variable inicializada a 6 representando el limite de columnas de cada fila(nCOL-1)
empieza_tablero:
	lda	count_tablero				;Contador que imprime las 6 filas del tablero original
	cmpa	#6
	beq	mitad_tablero

	lda	#'*					
	sta	pantalla
bucle_seguir:	
	lda 	b,x					;Imprime lo que hay en las posiciones de la fila
	sta	pantalla
	lda	#' 				
	sta	pantalla
	incb
	cmpb	siete					;B hasta 6(1ª iteracion),13(2ª iteracion),...
	beq	seguir_bucle
	bra	bucle_seguir
seguir_bucle:	
	lda	#'*
	sta	pantalla
	lda	#'\n
	sta	pantalla
	
	clra
	
	lda	count_tablero
	inca
	sta	count_tablero
	
	clra

	lda	siete					;Al aumentar la variable cada 7 voy representando todas las columnas
	adda	#7
	sta	siete

	bra	empieza_tablero				;Al final de cada iteracion deberia representar esto: *_______* hasta llegar a 6 iteraciones
mitad_tablero:
	clr	count					;Liberamos el contenido de la variable count para asegurarnos que no queda nada para el siguient bucle

bucle_mitad:						;Bucle que imprime "**********" debajo del tablero
	lda	count
	cmpa	#16
	beq	final_tablero
	
	lda	#'*
	sta	pantalla

	lda	count
	inca
	sta	count

	bra	bucle_mitad

final_tablero:						;Funcion y bucle que imprime "*1234567*"
	lda	#'\n
	sta	pantalla		
	
	lda	#'*
	sta	pantalla
	clr	count
	ldb	numero
	stb	numero_aux				;Guardamos 48 en una variable auxiliar para que en el siguiente turno el contenido de numero no cambie

buclefinal_tablero:
	lda	count
	cmpa	#7
	beq	retorno_tablero

	clra

	lda	numero_aux				;Variable que contiene el valor 48 incial que en la tabla ASCII se corresponde con el 0
	inca
	sta	numero_aux
	sta	pantalla				;Imprimimos 48,49,50,... y su correspondiente en la tabla ASCII 1,2,3,... hasta 7
	
	lda	#' 
	sta	pantalla
	clra
	
	lda	count
	inca
	sta	count

	bra	buclefinal_tablero

retorno_tablero:
	lda	#'*
	sta	pantalla

	clra

	lda	#'\n
	sta	pantalla
	

	clr	count
	clr	count_tablero
	clr	siete	
	pulu	x,a,b
	rts



