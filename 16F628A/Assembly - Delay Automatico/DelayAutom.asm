#INCLUDE <p16f628a.inc>

__CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC

#DEFINE BANK0 BCF STATUS,RP0 ;SETA BANK 0 DE MEM�RIA
#DEFINE BANK1 BSF STATUS,RP0 ;SETA BANK 1 DE MAM�RIA


ORG 0x00 ;ENDERE�O INICIAL DE PROCESSAMENTO
GOTO INICIO


ORG 0x04 ;ENDERE�O INICIAL DA INTERRUP��O
RETFIE ;RETORNA DA INTERRUP��O

CBLOCK	0x20		;ENDERE�O INICIAL DA MEM�RIA DE

	TEMP1                   
	TEMP2
	PA_TEMP		    
	W_TEMP		
	STATUS_TEMP	

ENDC
    
	
INICIO

BANK0 ;ALTERA PARA O BANCO 0
MOVLW B'00000111'
MOVWF CMCON ;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

CLRF PORTA ;LIMPA O PORTA
CLRF PORTB ;LIMPA O PORTB

BANK1 ;ALTERA PARA O BANCO 1
MOVLW B'00000000'
MOVWF TRISA 
MOVLW B'00000000'
MOVWF TRISB ;DEFINE TODO O PORTB COMO SA�DA
MOVLW B'10000000'
MOVWF OPTION_REG ;PULL-UPS DESABILITADOS
;AS DEMAIS CONFG. S�O IRRELEVANTES

MOVLW B'00000000'
MOVWF INTCON ;TODAS AS INTERRUP��ES DESLIGADAS
BANK0 ;RETORNA PARA O BANCO 0
	
MAIN
	
BSF  PORTB,0
CALL DELAY300ms	
BCF  PORTB,0 
CALL DELAY300ms
GOTO MAIN
		
	
DELAY500us

	MOVLW .125
	MOVWF TEMP1

DL0

	NOP
	DECFSZ TEMP1, F
	GOTO DL0

	RETURN

;------------------------------------------------------------------------------
	
DELAY1ms  ;

	MOVLW .250	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP1	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR

DL1

	NOP		    ; 1 CICLO DE MAQUINA
	DECFSZ TEMP1, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL1	    ; 2 CICLO DE MAQUINA
	
	;TEMPO = 4 (CICLOS DE MAQUINA) * 250(QUANTIDADE DO REGISTRADOR)
	;250 * 4 = 1000us = 1ms
	
	RETURN		  

;------------------------------------------------------------------------------
	
DELAY100ms ; OK

	MOVLW .100	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP1	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 1
	
DL1A
	MOVLW .100	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP2	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 2

	DECFSZ TEMP1, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2A
	RETURN	
	
DL2A
	NOP		    ; 1 CICLO DE MAQUINA   |  = 5 Ciclos
	NOP		    ; 1 CICLO DE MAQUINA   |
	DECFSZ TEMP2, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2A	    ; 2 CICLO DE MAQUINA
	GOTO DL1A
	
	;TEMPO = 5 (CICLOS DE MAQUINA)* 100 (QUANTIDADE DO REGISTRADOR)
	;100(TEMP2) * 5(CICLOS) * 2(CICLOS DL1B)* 100(TEMP1
	RETURN

;------------------------------------------------------------------------------

DELAY300ms ; OK

	MOVLW .250	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP1	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 1
	MOVLW .120	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP2	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 2

DL1B
	DECFSZ TEMP1, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2B
	RETURN	
	
DL2B
	NOP		    ; 1 CICLO DE MAQUINA   |  = 5 Ciclos
	NOP		    ; 1 CICLO DE MAQUINA   |
	DECFSZ TEMP2, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2B	    ; 2 CICLO DE MAQUINA
	GOTO DL1B
	
	;TEMPO = 10 (CICLOS DE MAQUINA) 250 ()QUANTIDADE DO REGISTRADOR
	;120(TEMP2) * 5(CICLOS) * 2(CICLOS DL1B)* 250(TEMP1
	RETURN	

END
    
