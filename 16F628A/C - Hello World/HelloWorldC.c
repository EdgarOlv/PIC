/*
 * File:   HelloWorldC.c
 * Author: edgar
 *
 * Created on 6 de Abril de 2021, 09:21
 */

#include <xc.h>
//__CONFIG(BOREN_OFF & MCLRE_OFF & CP_OFF & WDTE_OFF & FOSC_INTOSCIO);
#define _XTAL_FREQ  4000000

// CONFIG
#pragma config FOSC = INTOSCIO  // Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
#pragma config WDTE = OFF     // Watchdog Timer Enable bit (WDT enabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config MCLRE = ON       // RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is MCLR)
#pragma config BOREN = OFF      // Brown-out Detect Enable bit (BOD disabled)
#pragma config LVP = OFF        // Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data EE Memory Code Protection bit (Data memory code protection off)
#pragma config CP = OFF          // Flash Program Memory Code Protection bit (0000h to 07FFh code-protected)


void main(){

    PORTB = 0;
    PORTA = 0;
    TRISA = 0b11111111;
    TRISB = 0;
    OPTION_REG = 0b10001110;
    INTCON = 0;
    CMCON = 7;
    
    
    int i, cont;
    int vetor[4] = {1, 2, 4, 8}; 
        
   
    while(1){ 

        if( RA1 == 0 ){
        
            while( RA2 != 0 ){
            
                for(i = 0; i < 4; i++){

                    if(i < 3)
                    {
                        PORTB = vetor[i]; // atribui o valor da posição i do vetor ao PORTB
                        PORTB = vetor[i+1]; // atribui o valor da posição i do vetor ao PORTB
                    }
                    else{
                        PORTB = vetor[i]; // atribui o valor da posição i do vetor ao PORTB
                        PORTB = vetor[0]; // atribui o valor da posição i do vetor ao PORTB
                    }
                    __delay_ms(50);
                }
            }
            
        }else if( RA3 == 0 ){
            
            while( RA2 != 0 ){
            
                for(i = 3; i >= 0; i--){

                    if(i > 0)
                    {
                        PORTB = vetor[i]; // atribui o valor da posição i do vetor ao PORTB
                        PORTB = vetor[i-1]; // atribui o valor da posição i do vetor ao PORTB
                    }
                    else{
                        PORTB = vetor[i]; // atribui o valor da posição i do vetor ao PORTB
                        PORTB = vetor[3]; // atribui o valor da posição i do vetor ao PORTB
                    }

                    __delay_ms(50);

                }
            }
            
        }else if( RA4 == 0 ){

            __delay_ms(150);
            
            switch(cont){
                case 0:
                    
                    RB4 = 1;
                    __delay_ms(1);
                    RB4 = 0;
                    __delay_ms(19);
                    cont = cont + 1;
                    break;
                    
                case 1:
                    
                    RB4 = 1;
                    __delay_ms(1.25);
                    RB4 = 0;
                    __delay_ms(18.75);
                    cont = cont + 1;
                    break;
                    
                case 2:
                    
                    RB4 = 1;
                    __delay_ms(1.5);
                    RB4 = 0;
                    __delay_ms(18.5);
                    cont = cont + 1;
                    break;
                    
                case 3:    
                    
                    RB4 = 1;
                    __delay_ms(1.75);
                    RB4 = 0;
                    __delay_ms(18.25);
                    cont = cont + 1;
                    break;
                    
                case 4: 
                    
                    RB4 = 1;
                    __delay_ms(2);
                    RB4 = 0;
                    __delay_ms(18);
                    cont = 0;
                    
                    break;
            }
                      
        }
                 
    }
    
}