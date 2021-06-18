
/*************************************************************************
                           HEADER FILES
**************************************************************************/
#include<pic18.h>    
 
/*************************************************************************
                       FUNCTION DECLARATIONS
**************************************************************************/
void Delay_us(char Delay);
void Delay_100us(unsigned long int Delay); 
void Data(int Value);           
void Cmd(int Value);           
void Send2LCD(const char Adr, const char *Lcd);
 
/*************************************************************************
                       VARIABLE DECLARATIONS
**************************************************************************/ 
int k,ADC_Value;
char ADC_Array[5];
 
/*************************************************************************
                           MAIN FUNCTION
**************************************************************************/
void main()                     
{
 TRISA = 0XFF;                  /* Set PORTA as input for channel 0      */
 TRISC = 0X00;                  /* PORTC(control lines) configured as o/p*/
 TRISD = 0X00;                  /* PORTD(data lines) configured as o/p   */
 Delay_us(30);                      
 Cmd(0X30);                     /* LCD Specification Command             */
 Delay_us(30);  
 Cmd(0X30);                     /* LCD Specification Command             */
 Delay_us(30);  
 Cmd(0X30);                     /* LCD Specification Command             */
 Delay_us(30);  
 Cmd(0X38);                     /* Double Line Display Command           */
 Cmd(0X06);                     /* Auto Increment Location Address Cmmnd */
 Cmd(0X0C);                     /* Display ON Command                    */
 Cmd(0X01);                     /* Clear Display Command                 */
 Delay_100us(100);              
 Send2LCD(0x80,"ADC Result: "); 
 ADCON0 = 0x03;              
 ADCON1 = 0x0d;              
 ADCON2 = 0x92;
 Delay_100us(30);
 
 while(1)
 {
  GO = 1;                       /* Set A/D conversion status bit
                                   (conversion in progress)              */
  while(GO==1);                 /* Wait until A\D conversion completes   */
  ADC_Value = ADRESH;           /* Copy the 2 bits in ADRESH to ADC_Value*/
  ADC_Value = ADC_Value<<8;     /* Shift it 8 bits to left               */
  ADC_Value = ADC_Value+ADRESL; /* Add left shifted value to ADRESL      */
 
  for(k=0; k<=3; k++)           /* Convert the result into ASCII         */
  {                             /* Separate each digit of the integer    */
   ADC_Array[k] = ADC_Value%10+'0'; 
   ADC_Value    = ADC_Value/10;
  }
  Cmd(0X8C);
  for(k=3; k>=0; k--)
  {
   Data(ADC_Array[k]);          /* Display the result on LCD             */
  }
 }
}
 
/*************************************************************************
* Function    : Cmd                                                      *
*                                                                        *
* Description : Function to send a command to LCD                        *
*                                                                        *
* Parameters  : Value - command to be sent                               *
**************************************************************************/
void Cmd(int Value)
{
 PORTD = Value;                 /* Write the command to data lines       */
 RC0   = 0;                     /* RS-0(command register)                */
 RC1   = 1;                     /* E-1(enable)                           */
 Delay_us(100);             
 RC1   = 0;                     /* E-0(enable)                           */
}    
 
/*************************************************************************
* Function    : Data                                                     *
*                                                                        *
* Description : Function to display single character on LCD              *
*                                                                        *
* Parameters  : Value - character to be displayed                        *
**************************************************************************/
void Data(int Value)
{
 PORTD = Value;                 /* Write the character to data lines     */
 RC0   = 1;                     /* RS-1(data register)                   */
 RC1   = 1;                     /* E-1(enable)                           */
 Delay_us(100);             
 RC1   = 0;                     /* E-0(enable)                           */
}
 
/*************************************************************************
* Function    : Send2LCD                                                 *
*                                                                        *
* Description : Function to display string on LCD                        *
*                                                                        *
* Parameters  : loc - location                                           *
*               String to be displayed                                   *
**************************************************************************/
void Send2LCD(const char Adr, const char *Lcd)
{
 Cmd(Adr);                      /* Address of location to display string */
 while(*Lcd!='\0')              /* Check for termination character       */
 {    
  Data(*Lcd);                   /* Display the character on LCD          */
  Lcd++;                        /* Increment the pointer                 */
 }
}
 
/*************************************************************************
* Function    : Delay_us                                                 *
*                                                                        *
* Description : Function for 1 microsecond delay                         *
*                                                                        *
* Parameter   : Delay - delay in microseconds                            *
**************************************************************************/
void Delay_us(char Delay)    
{        
 while((--Delay)!=0);    
}
 
/*************************************************************************
* Function    : Delay_100us                                              *
*                                                                        *
* Description : Function for delay                                       *
*                                                                        *
* Parameter   : Delay - delay in microseconds                            *
**************************************************************************/
void Delay_100us(unsigned long int Delay)
{
 Delay=Delay*15;
 while((--Delay)!=0);
}
 
/***************************  END OF PROGRAM  ****************************/