#include <xc.h>
//__CONFIG(BOREN_OFF & MCLRE_OFF & CP_OFF & WDTE_OFF & FOSC_INTOSCIO);
#define _XTAL_FREQ  4000000
#define SBIT_T2CKPS1  1

// CONFIG
#pragma config FOSC = INTOSCIO  // Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
#pragma config WDTE = ON     // Watchdog Timer Enable bit (WDT enabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config MCLRE = OFF       // RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is MCLR)
#pragma config BOREN = OFF      // Brown-out Detect Enable bit (BOD disabled)
#pragma config LVP = OFF        // Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data EE Memory Code Protection bit (Data memory code protection off)
#pragma config CP = OFF          // Flash Program Memory Code Protection bit (0000h to 07FFh code-protected)

int cont = 0;
int cont2 = 0;

__interrupt(high_priority) void getData(void){
            GIE = 0;
            if (INTE && INTF){
                RA0 = !RA0;
                INTF = 0;
            }else if (T0IE && T0IF){
                //RB1 = !RB1;
                TMR0 = 5;
                cont++;
                
                if(cont == 500)  {  // Cálculo = (256 - 6)*2*0,000001*500 = 0,25 seg.
                    RB2 = !RB2;     // Troca o estado de RB1
                    cont = 0;         // Zera a variável count
                }
                
                T0IF = 0;
                
            }else if (TMR2IE && TMR2IF){   //Erro: Timer2 Não está funcionando
                cont2++;
                //RB4 = !RB4;
                if(cont2 == 10)  {  // Cálculo = (4 / 4) * 5* 4 * 250 =  5ms * 10 = 50ms
                    RB3 = !RB3;     // Troca o estado de RB1
                    cont2 = 0;         // Zera a variável count
                }
                
                TMR2IF = 0;
            }
            
            GIE = 1;    
        }

void delay10(int);

void main(){  

    PORTB = 0;
    PORTA = 0;
    TRISA = 0b11111110;
    TRISB = 0b10000001;
    OPTION_REG = 0b01000000;
    INTCON = 0;
    CMCON = 7;
    T2CON =  0b00100101;
    
    GIE = 1;
    PEIE = 1;
    T0IE = 1;
     
    TMR2IE = 1;
    
    PR2 = 250; // LIMITADOR TIMER2
    TMR0 = 6;

    while(1){ 

        RB1 = !RB1;
        delay10(50);

    }
}
    
void delay10(int a)
{
    while(a--){  
        __delay_ms(10);
        CLRWDT();
    }
}    
    