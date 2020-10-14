#include"my_define.h"

void GPIO_INIT(void)
{
	GPO3In();
  GPO3IT();
  EXTI_CR1|=0x01;//PC0 Rising 
	
  PC_DDR|=0x10;//LED
	PC_CR1|=0x10;
	
	PB_DDR|=0x03;
	PB_CR1|=0x03;
}

void IOconfig(void)
{
  PB_DDR |=0X7F;   //OUT 0111 1111  PB7 AD
	PB_CR1 |=0X7F;   //TW  0111 1111
	PB_CR2 &=~0XFF;   //DS
	PB_ODR=0X00;     //    0001 0000
	
	PC_DDR=0XFC;   //OUT 1111 1100  PC1=key  PC0=GPIO1 (有待考虑是否一直打开会有影响)
	PC_CR1=0XFC;   //TW  1111 1100
	PC_CR2=0X03;   //DS
	PC_ODR=0X20;   //    0010 0000
	
	PA_DDR |=0XFD;    //OUT 1111 1101
	PA_CR1 |=0XFD;    //TW
	PA_CR2 &=~0XFD;   //DS
	PA_ODR=0X00;      //00
	
	PD_DDR=0XFF;   //OUT
	PD_CR1=0XFF;   //TW
	PD_CR2=0X00;   //DS
	PD_ODR=0X01;   //00
}