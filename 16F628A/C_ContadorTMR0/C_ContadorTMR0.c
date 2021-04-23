#include <xc.h>
//__CONFIG(BOREN_OFF & MCLRE_OFF & CP_OFF & WDTE_OFF & FOSC_INTOSCIO);
#define _XTAL_FREQ  4000000


// CONFIG
#pragma config FOSC = INTOSCIO  // Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
#pragma config WDTE = OFF     // Watchdog Timer Enable bit (WDT enabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config MCLRE = OFF       // RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is MCLR)
#pragma config BOREN = OFF      // Brown-out Detect Enable bit (BOD disabled)
#pragma config LVP = OFF        // Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data EE Memory Code Protection bit (Data memory code protection off)
#pragma config CP = OFF          // Flash Program Memory Code Protection bit (0000h to 07FFh code-protected)


void main(){

    PORTB = 0;
    PORTA = 0;
    TRISA = 0b11111110;
    TRISB = 0;
    OPTION_REG = 0b10000000;
    INTCON = 0;
    CMCON = 7;

    int i;
    int cont = 0;
    int vetor[8] = {1, 2, 4, 8, 16, 32, 64, 128};
    char display1[10] = {0b11111110, 0b00111000, 0b11011101, 0b01111101, 0b00111011, 0b01110111, 0b11110111, 0b00111100, 0b11111111, 0b01111111};
        
    TMR0 = 0;
    while(1){ 
        
        if(TMR0 >= 250){
                        
            cont++;
            
            if(cont == 200){
                RA0 = !RA0;
                cont = 0;
            }
            TMR0 = 0;
        }
        
        RB0 = !RB0;
        //__delay_ms(1);
        
        //for(i = 0; i < 10; i++){
              //PORTB = display1[i]; // atribui o valor da posição i do vetor ao PORTB
            //__delay_ms(1000);
            
          //  while(RA1 == 0); //pausa a alteração do PORTB
           // }
              
    }
    
}