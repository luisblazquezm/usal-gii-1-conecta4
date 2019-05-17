;Trabajo Final
;Andrés Hernández y Luis Blázquez

	.module main
				
;VARIABLES GLOBALES----------------------------------------------------------------
.globl ficha
.globl posicion
.globl vector_tablero
.globl pos_ficha
ficha:			.byte 0				;Donde se guarda una X o una O	
posicion:		.byte 0				;Donde se guarda la posicion de la ficha que se introduce

;ETIQUETAS GLOBALES (6 Subrutinas)--------------------------------------------------
           	.globl	programa			;<main.asm>
		.globl	imprime_titulo
		.globl  menu_conecta			;<menu_principal.asm>
		.globl	imprimir_mensaje		;<cadenas.asm>
		.globl  imprime_instrucciones		;<menu_instrucciones.asm>
		.globl  interfaz_tablero		;<tablero.asm>
		.globl	conecta_tablero			;<conecta.asm>

;Constantes-------------------------------------------------------------------------
fin     	.equ  	0xFF01
pantalla	.equ  	0xFF00
teclado		.equ  	0xFF02

;Variables LOCALES---------------------------------------------------------------------------
pos_ficha: 		.byte 0				;Donde se guarda la posicion de la columna introducida de teclado
pos_ocupada:		.byte 0				;Donde se guarda el nº de la columna ocupada(1,2,..7)
indice_turno:		.byte 0				;Lleva el nº de turnos que se pueden hacer en todo el tablero
opcion:			.byte 0				;Almacena la opcion(1,2 o 3) del menu
  
;Mensajes de advertencia-------------------------------------------------------------
mensaje_error:  	.asciz	"\nRango no valido, introduzca de nuevo una posicion\n"

mensaje_jugador1: 	.asciz	"Jugador 1 (\33[31mO\33[37m): \n"

mensaje_jugador2: 	.asciz	"Jugador 2 (\33[33mX\33[37m): \n"

mensaje_columna_llena: 	.asciz	"Esta columna esta llena, introduzca una ficha en una columna libre\n"

mensaje_salir: 		.asciz	"Pulsar S para volver al menu, otro para continuar\n"

mensaje_empatar:	.asciz  "El tablero esta lleno. La partida termina en EMPATE\n"

;Vector tablero (VARIABLE GLOBAL)--------------------------------------------------------------------
vector_tablero:
	.ascii "_______"
	.ascii "_______"
	.ascii "_______"
	.ascii "_______"
	.ascii "_______"
	.asciz "_______"

;Vector de comprobacion(cada byte es una columna del tablero de las 7 que hay)
;(Inicializados a 6 indicando el numero de posiciones LIBRES en cada columna)
vector_comprobacion: .byte 6 .byte 6 .byte 6 .byte 6 .byte 6 .byte 6 .byte 6		

;EMPIEZA EL PROGRAMA-------------------------------------------------------------
programa:	 	
	ldu 	#0xFF00					;Inicializamos la pila de usuario en la direccion 0xFF00
bucle_menu:
	jsr	imprime_titulo

	lda 	#'\n
	sta 	pantalla

	jsr	 menu_conecta				;<<<SUBRUTINA menu_principal.asm>>> Imprime el tablero
	
	ldb 	teclado					;Pido una opcion de teclado
	stb 	opcion
caso_juego:						;Caso 1: Jugar
	cmpb 	#'1
	blo 	bucle_menu				;Si la opcion introducida es menor que 1 vuelve al menu
	bne 	caso_instruc				;Si la opcion introducida no es menor que 1 y es distinto de 1 salta
	jsr 	empezar_juego

	bra 	bucle_menu
caso_instruc:						;Caso 2: Instrucciones
	cmpb 	#'2			
	bne 	caso_acabar

	jsr 	imprime_instrucciones
	bra 	bucle_menu
caso_acabar:						;Caso 3: Fin de juego
	cmpb    #'3
	bhi     bucle_menu				;Si la opcion introducida es mayor que 3 vuelve al menu

	lda	#'\n
	sta	pantalla
       	clra
        sta 	fin

	
;JUEGO--------------------------------------------------------------------------
empezar_juego:
;Desarrolla el turno de cada jugador--------------------
Turno_jugador:  
	pshu	a,x,b					;Guarda contenido de los registros A,X y B a donde apunta U y va decrementandose
	jsr	bucle_turno
	bra	bucle_menu
	      
bucle_turno: 
	lda 	#'\n					
	sta 	pantalla
	ldx 	#mensaje_salir
	jsr 	imprimir_mensaje		
	lda 	teclado
	cmpa	#'s
	beq 	salir_bucle_turno			;Si se introduce S o s se sale al menu
	cmpa 	#'S
	beq 	salir_bucle_turno
	lda 	#'\n					
	sta 	pantalla
	bra 	continuar_turno		

continuar_turno:
	clra
							;TURNO JUGADOR 1
	ldx 	#mensaje_jugador1			;Imprime el mensaje del jugador 1: "Jugador 1(O):"
	jsr 	imprimir_mensaje			;<<<SUBRUTINA cadenas.asm>>> Imprime cualquier cadena de caracteres	
	lda 	#'O
	sta 	ficha
	jsr 	pedir_columna				;<<<SUBRUTINA EN ESTE MODULO>>> Pide la columna 

							;TURNO JUGADOR 2
	ldx 	#mensaje_jugador2			;Imprime el mensaje del jugador 2: "Jugador 2(X):"
	jsr 	imprimir_mensaje			
	lda 	#'X	
	sta 	ficha
	jsr 	pedir_columna				;<<<SUBRUTINA EN ESTE MODULO>>>
						
	ldb 	indice_turno				;Contador del numero de turnos que se realizan
	incb						
	stb 	indice_turno				
	cmpb	#21					;Numero de turnos(21 fichas por jugador)	
	beq	empate
	lbra 	bucle_turno				

empate:							;Si el numero de turnos llega a 21 en uno de los 2 jugadores significa
	ldx	#mensaje_empatar			;que el tablero esta lleno y por lo tanto es EMPATE
	jsr	imprimir_mensaje
				
salir_bucle_turno:
	pulu 	x,a,b						
	rts		
;Fin funcion---------------------------------
	  
;SUBRUTINA que pide al jugador introducir una ficha
pedir_columna:	
	lda	teclado
	suba	#48					;El numero de columna que se introduce es pasado a decimal
	sta	pos_ficha	
	lda 	#'\n					
	sta 	pantalla			
	bra 	comprobacion_rango				
;Fin funcion----------------------------------

;SUBRUTINA a poner en otro modulo que comprueba que la posicion sea >1 y <7
comprobacion_rango:	 
        lda 	pos_ficha				;Columna de 1 a 7
	cmpa 	#1					;Comprobar (columna introducida) entre 1 y 7
	blo 	pos_erronea				
	
	cmpa 	#7					
	bhi 	pos_erronea					
						
	lbra  	guardar_ficha				
	puls 	pc					

;Fin SUBRUTINA--------------------------------

;Imprime mensaje de rango no valido----------	
pos_erronea:
	ldx	#mensaje_error
	jsr	imprimir_mensaje			
	bra	pedir_columna
;Fin funcion---------------------------------

;Funcion que guarda la posicion de la ficha introducida en el vector_tablero
guardar_ficha:			
	ldx 	#vector_comprobacion			;Carga el vector para llevar la cuenta de cuantas posiciones estan ocupadas en cada columna
	ldb 	pos_ficha				;Columna introducida de teclado(1-7)
	decb						;Maximo valor de B=6 y minimo B=0
	lda 	b,x					;Carga en A el nº de posiciones de la columna B del vector X
	deca						;Maximo valor de A=6 y minimo A=0
	cmpa 	#0					
	blt 	columna_llena				;Si alguno de los byte del vector es 0 es que no hay posiciones libres en esa columna
        sta 	b,x 					;Guarda el nº de posiciones ocupadas en ese columna
	sta 	pos_ocupada				;Guarda el nº de fila en la que hay que poner la ficha(Si es 6 sera la primera fila, si es 1 la ultima)
	ldb 	#0 					;Lleva la cuenta del nº de posiciones que se salta
	lda 	#0	
	lbra	bucle_ficha
			
columna_llena:
	ldx 	#mensaje_columna_llena
	jsr 	imprimir_mensaje		
	lbra 	pedir_columna

bucle_ficha:						
	addb 	#7					;Suma 7(Cada 7 es una fila hacia abajo que se salta empezando desde la primera)
	inca						
	cmpa 	pos_ocupada				;Compara A con el valor del numero de posiciones ocupadas segun vector_comprobacion en una columna
	beq 	salir_bucle_ficha			
	bra 	bucle_ficha			
	
salir_bucle_ficha:
	addb 	pos_ficha				;Numero de posiciones saltadas(7 por fila)+fila introducida=POSICION EFECTIVA
	decb						;----->EJEMPLO: 28(Fila 4) + 3(Columna 3) = 31
	stb	posicion
	lda 	ficha					;Carga en A la ficha (X o O) introducida
	ldx 	#vector_tablero				;Carga en X el tablero
	sta  	b,x					;Almacena en la posicion[X][B] que se ha indicado la ficha que hay en A (X o O)

	jsr	interfaz_tablero			;<<<SUBRUTINA tablero.asm>>> Imprime el tablero
	jsr	conecta_tablero				;<<<SUBRUTINA conecta.asm>>> Realiza las comprobaciones vertical,horizontal y diagonal	
	puls	pc				
;Fin funcion---------------------------------
	.area FIJA(ABS)
	.org 0xFFFE     			
        .word programa	
;Fin JUEGO------------------------------------------------
	




	
