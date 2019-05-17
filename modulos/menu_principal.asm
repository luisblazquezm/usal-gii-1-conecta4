	.module menu_principal


menu: 		
		.byte   10 
		.ascii "MENU PRINCIPAL DEL JUEGO"
        	.byte   10      
 		.ascii "\33[31m1)\33[37m Jugar"
        	.byte   10        
		.ascii "\33[31m2)\33[37m Instrucciones"
        	.byte   10     
		.ascii "\33[31m3)\33[37m Salir"
        	.byte   10  
		.byte   0   

seleccion: 	
		.byte   10  
		.ascii "Seleccione una opcion: "
		.byte   10      
        	.byte   0   

	.globl  menu_conecta
	.globl	imprimir_mensaje

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	menu_conecta						       ;
;	   saca por pantalla el menu principal			       ;
;	   y la peticion de una de las opciones			       ;
;								       ;
;								       ;
;	   >Entrada: ninguna					       ;
;          >Salida: mensaje del menu y seleccion		       ;
;	   >Registros afectados: X, CC				       ;
;	   >SUBRUTINAS AUXILIARES: imprimir_mensaje		       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



menu_conecta: 		
	ldx	#menu
	jsr	imprimir_mensaje
	
	ldx	#seleccion
	jsr	imprimir_mensaje

	rts
	
	









