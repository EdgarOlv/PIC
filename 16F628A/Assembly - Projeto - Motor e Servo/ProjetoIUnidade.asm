#INCLUDE <p16f628a.inc>

__CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_OFF & _XT_OSC

#DEFINE BANK0 BCF STATUS,RP0 ;SETA BANK 0 DE MEM�RIA
#DEFINE BANK1 BSF STATUS,RP0 ;SETA BANK 1 DE MAM�RIA

#DEFINE VERIFICA_PARADA	BTFSC PORTA,2
	
ORG 0x00		    ;ENDERE�O INICIAL DE PROCESSAMENTO
GOTO INICIO

ORG 0x04		    ;ENDERE�O INICIAL DA INTERRUP��O
RETFIE			    ;RETORNA DA INTERRUP��O

CBLOCK	0x20		    ;ENDERE�O INICIAL DA MEM�RIA DE

	TEMP1                   
	TEMP2	    			
	MOTOR
	CONTA

ENDC
    
INICIO

BANK0			    ;ALTERA PARA O BANCO 0
MOVLW B'00000111'
MOVWF CMCON		    ;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

CLRF PORTA		    ;LIMPA O PORTA
CLRF PORTB		    ;LIMPA O PORTB

BANK1			    ;ALTERA PARA O BANCO 1
MOVLW B'11111110'
MOVWF TRISA		    ;DEFINE RA1 COMO SAIDA E DEMAIS COMO ENTRADAS
	
MOVLW B'00000000'
MOVWF TRISB		    ;DEFINE TODO O PORTB COMO SA�DA
	
MOVLW B'10000000'
MOVWF OPTION_REG	    ;PULL-UPS DESABILITADOS AS DEMAIS CONFG. S�O IRRELEVANTES

MOVLW B'00000000'
MOVWF INTCON		    ;TODAS AS INTERRUP��ES DESLIGADAS
BANK0			    ;RETORNA PARA O BANCO 0
	

MOVLW B'00011111'
MOVWF CONTA
	
	
ROTINA1
	
BCF PORTA, 0		    ;DESLIGA LED SINALIZADOR-VELOCIDADE
GOTO MARCADOR	
	
MUDAVELOCIDADE		    ;VERIFICA SE O SINALIZADOR-VELOCIDADE EST� ACIONADO
	
BTFSC PORTA, 0
CALL DELAY100ms		    ;SE SINALIZADOR-VELOCIDADE LIGADO, LOGO VELOCIDADE 2
CALL DELAY10ms		    ;SE SINALIZADOR-VELOCIDADE DESLIGADO, LOGO VELOCIDADE 1
	
RETURN	
	
MAIN
	
;===================== VERIFICA��O DA VARIAVEL =====================			
	
BTFSS MOTOR, 1		    ;VERIFICA VARIAVEL "MOTOR"
GOTO ROTINA1		    ;SE FALSE ENT�O DESLIGA SINALIZADOR-VELOCIDADE
BSF PORTA, 0		    ;SE TRUE ENT�O LIGA SINALIZADOR-VELOCIDADE
	
;===================== VERIFICA��O DOS BOT�ES =====================		

MARCADOR	
	
BTFSC PORTA, 1		    ;VERIFICA RA1 - FRENTE
GOTO BOTAO_LIB		    ;N�O
GOTO VERIFICA		    ;SIM E VERIFICA OUTRA COMBINA��O

BOTAO_LIB
    BTFSC PORTA, 2	    ;VERIFICA RA2 - PARADO
    GOTO BOTAO_LIB2	    ;N�O
    GOTO VERIFICA2	    ;SIM
    
BOTAO_LIB2		
    BTFSC PORTA, 3	    ;VERIFICA RA3 - TRAS
    GOTO BOTAO_LIB3	    ;N�O
    GOTO VELOCIDADE1A	    ;SIM - TRAS
    
BOTAO_LIB3		
    BTFSC PORTA, 4	    ;VERIFICA RA4 - MUDAR VELOCIDADE
    GOTO MAIN		    ;N�O
    COMF MOTOR,1	    ;SIM   - MUDA A VELOCIDADE  
    
    GOTO MAIN
;-----------------------    
    
VERIFICA
    
    BTFSC PORTA, 2	    ;VERIFICA RA1 E RA2
    GOTO VELOCIDADE1	    ;N�O - VERIFICA SERVO
    GOTO VELOCIDADE2	    ;SIM - ESQUERDA
        
VERIFICA2
    
    BTFSC PORTA, 3	    ;VERIFICA RA2 E RA4
    GOTO VERIFICA_SERVO	    ;N�O - PARADO
    GOTO VELOCIDADE2A	    ;SIM - DIREITA
    
VERIFICA_SERVO
    
    BTFSC PORTA, 4	    ;VERIFICA RA1 E RA3
    GOTO MAIN		    ;N�O - FRENTE
    GOTO MENU		    ;SIM - FUNCAO SERVO    
    
;-----------------------    
   
MENU

   CALL DELAY100ms
   CALL DELAY100ms
   CALL DELAY100ms
   CALL DELAY100ms
   
   BTFSC CONTA,0
   GOTO SERV0 ;
   GOTO CONTA1;

CONTA1
   BTFSC CONTA,1
   GOTO SERV45 ;
    GOTO CONTA2;

CONTA2
   BTFSC CONTA,2
   GOTO SERV90 ;
    GOTO CONTA3;

CONTA3
   BTFSC CONTA,3
   GOTO SERV135 ;
    GOTO CONTA4;

CONTA4
   BTFSC CONTA,4
   GOTO SERV180 ;
   MOVLW B'00011111';
   MOVWF CONTA ;
   GOTO MENU;

 SERV0
	CALL SERVO0
	MOVLW B'00011110' 
	MOVWF CONTA
	GOTO MAIN

 SERV45
	CALL SERVO45
	 MOVLW B'00011100' 
	MOVWF CONTA
	GOTO MAIN

 SERV90
	CALL SERVO90
	 MOVLW B'00011000' 
	MOVWF CONTA
	GOTO MAIN

 SERV135
	CALL SERVO135
	MOVLW B'00010000' 
	MOVWF CONTA
	GOTO MAIN

 SERV180
	CALL SERVO180
	MOVLW B'00000000' 
	MOVWF CONTA
	GOTO MAIN

;===================== ENCERRAMENTO VERIFICA��O DOS BOT�ES =====================    
    
VELOCIDADE1	

    BCF	PORTB,0	
    BSF	PORTB,3
    BSF	PORTB,2 	
    ;--
    BCF	PORTB,4	
    BSF	PORTB,7
    BSF	PORTB,6
    
    CALL MUDAVELOCIDADE

    BCF	PORTB,3
    BSF	PORTB,1	
    ;--
    BCF	PORTB,7
    BSF	PORTB,5	
    
    CALL MUDAVELOCIDADE	

    BCF	PORTB,2	
    BSF	PORTB,0	
    ;--
    BCF	PORTB,6	
    BSF	PORTB,4

    CALL MUDAVELOCIDADE

    BCF	PORTB,1
    BSF	PORTB,3	
    ;--
    BCF	PORTB,5
    BSF	PORTB,7	

    CALL MUDAVELOCIDADE

VERIFICA_PARADA
GOTO VELOCIDADE1	    ;N�O, ENT�O TRATA BOT�O LIBERADO
GOTO MAIN		    ;SIM, ENT�O TRATA BOT�O PRESSIONADO

;----------------
 
VELOCIDADE1A	
	
    BCF	PORTB,3		
    BSF	PORTB,0
    BSF	PORTB,1 
    ;--
    BCF	PORTB,7		
    BSF	PORTB,4
    BSF	PORTB,5

    CALL MUDAVELOCIDADE

    BCF	PORTB,0	
    BSF	PORTB,2	
    ;--
    BCF	PORTB,4	
    BSF	PORTB,6	

    CALL MUDAVELOCIDADE

    BCF	PORTB,1	
    BSF	PORTB,3	
    ;--
    BCF	PORTB,5
    BSF	PORTB,7

    CALL MUDAVELOCIDADE

    BCF	PORTB,2
    BSF	PORTB,0	
    ;--
    BCF	PORTB,6
    BSF	PORTB,4	

    CALL MUDAVELOCIDADE
    
VERIFICA_PARADA
GOTO VELOCIDADE1A	    ;N�O, ENT�O TRATA BOT�O LIBERADO
GOTO MAIN		    ;SIM, ENT�O TRATA BOT�O PRESSIONADO

VELOCIDADE2	

    BCF	PORTB,0	
    BSF	PORTB,3
    BSF	PORTB,2 	
    ;--
    BCF	PORTB,7		
    BSF	PORTB,4
    BSF	PORTB,5
    
    CALL MUDAVELOCIDADE

    BCF	PORTB,3
    BSF	PORTB,1	
    ;--
    BCF	PORTB,4	
    BSF	PORTB,6		
    
    CALL MUDAVELOCIDADE	

    BCF	PORTB,2	
    BSF	PORTB,0	
    ;--
    BCF	PORTB,5
    BSF	PORTB,7

    CALL MUDAVELOCIDADE

    BCF	PORTB,1
    BSF	PORTB,3	
    ;--
    BCF	PORTB,6
    BSF	PORTB,4	

    CALL MUDAVELOCIDADE
    
VERIFICA_PARADA
GOTO VELOCIDADE2	    ;N�O, ENT�O TRATA BOT�O LIBERADO
GOTO MAIN		    ;SIM, ENT�O TRATA BOT�O PRESSIONADO

;-----------------------------------------------------------------------    

VELOCIDADE2A	
    
    BCF	PORTB,3		
    BSF	PORTB,0
    BSF	PORTB,1 	
    ;--
    BCF	PORTB,4	
    BSF	PORTB,7
    BSF	PORTB,6
    
    CALL MUDAVELOCIDADE

    BCF	PORTB,0	
    BSF	PORTB,2	
    ;--
    BCF	PORTB,7
    BSF	PORTB,5	
    
    CALL MUDAVELOCIDADE	

    BCF	PORTB,1	
    BSF	PORTB,3	
    ;--
    BCF	PORTB,6	
    BSF	PORTB,4

    CALL MUDAVELOCIDADE

    BCF	PORTB,2
    BSF	PORTB,0		
    ;--
    BCF	PORTB,5
    BSF	PORTB,7	

    CALL MUDAVELOCIDADE
    
VERIFICA_PARADA
GOTO VELOCIDADE2A	    ;N�O, ENT�O TRATA BOT�O LIBERADO
GOTO MAIN		    ;SIM, ENT�O TRATA BOT�O PRESSIONADO
    

;=============================== FUN��ES DE TEMPO =============================
    
DELAY20ms ; OK

	MOVLW .100	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP1	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 1
	
DL1A4
	MOVLW .19	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP2	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 2

	DECFSZ TEMP1, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2A4
	RETURN	
	
DL2A4
	NOP		    ; 1 CICLO DE MAQUINA   |  = 5 Ciclos
	NOP		    ; 1 CICLO DE MAQUINA   |
	DECFSZ TEMP2, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2A4	    ; 2 CICLO DE MAQUINA
	GOTO DL1A4
	
	;TEMPO = 5 (CICLOS DE MAQUINA)* 100 (QUANTIDADE DO REGISTRADOR)
	;100(TEMP2) * 5(CICLOS) * 2(CICLOS DL1B)* 100(TEMP1
	RETURN	  
	
;------------------------------------------------------------------------------    
    
    
    DELAY10ms ; OK

	MOVLW .100	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP1	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 1
	
DL1A
	MOVLW .10	    ; PASSA VALOR PARA ACUMULADOR
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
	
DELAY100ms ; OK

	MOVLW .100	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP1	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 1
	
DL1A1
	MOVLW .100	    ; PASSA VALOR PARA ACUMULADOR
	MOVWF TEMP2	    ; PASSA VALOR ACUMULADOR PARA REGISTRADOR 2

	DECFSZ TEMP1, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2A1
	RETURN	
	
DL2A1
	NOP		    ; 1 CICLO DE MAQUINA   |  = 5 Ciclos
	NOP		    ; 1 CICLO DE MAQUINA   |
	DECFSZ TEMP2, F	    ; 1 CICLO DE MAQUINA   - DECREMENTA REGISTRADOR
	GOTO DL2A1	    ; 2 CICLO DE MAQUINA
	GOTO DL1A1
	
	;TEMPO = 5 (CICLOS DE MAQUINA)* 100 (QUANTIDADE DO REGISTRADOR)
	;100(TEMP2) * 5(CICLOS) * 2(CICLOS DL1B)* 100(TEMP1
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

DELAY500us

	MOVLW .125
	MOVWF TEMP1

DL0

	NOP
	DECFSZ TEMP1, F
	GOTO DL0

	RETURN

;------------------------------------------------------------------------------		
	
DELAY250us

	MOVLW .63
	MOVWF TEMP1

DL0W

	NOP
	DECFSZ TEMP1, F
	GOTO DL0W

	RETURN

;============================= FIM FUN��ES DE TEMPO ===========================

SERVO0
	
	BSF PORTA,0
	CALL DELAY1ms
	;CALL DELAY1ms ;Tempo para posi��o 90�
	BCF PORTA,0
	CALL DELAY20ms

	RETURN

SERVO45
	
	BSF PORTA,0
	CALL DELAY1ms
	CALL DELAY250us
	;CALL DELAY1ms ;Tempo para posi��o 90�
	BCF PORTA,0
	CALL DELAY20ms

	RETURN	
	
SERVO90
	
	BSF PORTA,0
	CALL DELAY1ms
	CALL DELAY500us
	;CALL DELAY1ms ;Tempo para posi��o 90�
	BCF PORTA,0
	CALL DELAY20ms

	RETURN

SERVO135
	
	BSF PORTA,0
	CALL DELAY1ms
	CALL DELAY500us
	CALL DELAY250us
	;CALL DELAY1ms ;Tempo para posi��o 90�
	BCF PORTA,0
	CALL DELAY20ms

	RETURN	
	
SERVO180
	
	BSF PORTA,0
	CALL DELAY1ms
	CALL DELAY1ms
	;CALL DELAY1ms ;Tempo para posi��o 90�
	BCF PORTA,0
	CALL DELAY20ms

	RETURN	
	
END
   
