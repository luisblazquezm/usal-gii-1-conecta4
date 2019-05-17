		.module cadenas

pantalla	.equ	0xFF00

		.globl	imprimir_mensaje

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	imprimir_mensaje					       ;
;	   saca por pantalla la cadena acabada en '\0'		       ;
;	   apuntada por X					       ;
;								       ;
;								       ;
;	   >Entrada: X-direccion de comienzo de cadena		       ;
;          >Salida: ninguna					       ;
;	   >Registros afectados: X, CC				       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


imprimir_mensaje:
	pshu	a
imprimir_mensaje_print:
	lda 	,x+
	beq 	imprimir_mensaje_salir
	sta	pantalla
	bra	imprimir_mensaje_print
imprimir_mensaje_salir:
	pulu 	a
	rts

