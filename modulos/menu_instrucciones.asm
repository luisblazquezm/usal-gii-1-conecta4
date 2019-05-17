	.module menu_instrucciones


instrucciones:		
		.byte   10 
		.ascii "\33[32mOBJETIVO\33[37m: Alinear cuatro fichas en vertical/diagonal u horizontal\n"    
		.ascii "\33[32mJUGADORES\33[37m: 2 con 21 fichas X y O \n"    
		.ascii "\33[32mCOLUMNA\33[37m: se introduciran las fichas en las columnas que se quieran: \n"    
		.ascii "-----> No se puede introducir una ficha en una columna llena\n"
		.ascii "-----> Caera en la posicion mas baja\n"
		.asciz "-----> Si todas las columnas estan llenas significara EMPATE\n"
    

	.globl  imprime_instrucciones
	.globl	imprimir_mensaje

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	imprime_instrucciones					       ;
;	   saca por pantalla las instrucciones del juego	       ;
;	   		                                               ;
;								       ;
;								       ;
;	   >Entrada: ninguna					       ;
;          >Salida: cadena de instrucciones		               ;
;	   >Registros afectados: X, CC				       ;
;	   >SUBRUTINAS AUXILIARES: imprimir_mensaje		       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


imprime_instrucciones: 		
	ldx	#instrucciones
	jsr	imprimir_mensaje
	
	rts
