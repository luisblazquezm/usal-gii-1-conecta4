	.module tituloASCII


encabezado:	
	.byte   10
        .ascii	"\33[32m  /$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$$  /$$$$$$  /$$$$$$$$  /$$$$$$        /$$   /$$\n"
	.ascii	" /$$__  $$ /$$__  $$| $$$ | $$| $$_____/ /$$__  $$|__  $$__/ /$$__  $$      | $$  | $$\n"
	.ascii	"| $$  \__/| $$  \ $$| $$$$| $$| $$      | $$  \__/   | $$   | $$  \ $$      | $$  | $$\n"
	.ascii	"| $$      | $$  | $$| $$ $$ $$| $$$$$   | $$         | $$   | $$$$$$$$      | $$$$$$$$\n"
	.ascii	"| $$      | $$  | $$| $$  $$$$| $$__/   | $$         | $$   | $$__  $$      |_____  $$\n"
	.ascii	"| $$    $$| $$  | $$| $$\  $$$| $$      | $$    $$   | $$   | $$  | $$            | $$\n"
	.ascii	"|  $$$$$$/|  $$$$$$/| $$ \  $$| $$$$$$$$|  $$$$$$/   | $$   | $$  | $$            | $$\n"
	.asciz	" \______/  \______/ |__/  \__/|________/ \______/    |__/   |__/  |__/            |__/\33[37m \n"
	.byte	10
 

	.globl  imprime_titulo
	.globl	imprimir_mensaje

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	imprime_titulo						       ;
;	   saca por pantalla el encabezado con			       ;
;	   simbologia de la tabla ASCII		 		       ;
;								       ;
;								       ;
;	   >Entrada: ninguna					       ;
;          >Salida: encabezado menu				       ;
;	   >Registros afectados: X, CC				       ;
;	   >SUBRUTINAS AUXILIARES: imprimir_mensaje		       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



imprime_titulo: 		
	ldx	#encabezado
	jsr	imprimir_mensaje
	
	rts
	
