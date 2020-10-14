#include"my_define.h"
void TIM2_INIT_Slow(void)//从报警用
{
	CLK_PCKENR1|=0X01;      //打开TIM2时钟
  
	TIM2_CR1 =0X80;   //预 边 上 单脉冲 禁计
	TIM2_PSCR =0X05; //分频4=mhz T=us
	
	TIM2_ARRH =0Xff;
	TIM2_ARRL =0Xff;   //8MHz 32Div 
	
	TIM2_SR1&=~0x01;
}

void TIM2_INIT_Middle(void)//主报警用
{
	CLK_PCKENR1|=0X01;      //打开TIM2时钟
  
	TIM2_CR1 =0X80;   //预 边 上 单脉冲 禁计
	TIM2_PSCR =0X05; //分频4=mhz T=us
	
	TIM2_ARRH =0Xbb;
	TIM2_ARRL =0Xbb;   //8MHz 32Div 
	
	TIM2_SR1&=~0x01;
}

void TIM2_INIT_Fast(void)//配对时用
{
	CLK_PCKENR1|=0X01;      //打开TIM2时钟
  
	TIM2_CR1 =0X80;   //预 边 上 单脉冲 禁计
	TIM2_PSCR =0X05; //分频4=mhz T=us
	
	TIM2_ARRH =0Xa2;
	TIM2_ARRL =0X0f;   //8MHz 32Div a20f==0.1646s
	
	TIM2_SR1&=~0x01;
}

void T1_Slow_for_ledbuz_EN(void)
{
  TIM2_INIT_Slow();
	TIM2_IER |=0x01;//TIM2_IER |=0x40;//使能中断
  TIM2_CR1 |=0X01;
}
void T1_Middle_for_ledbuz_EN(void)
{
  TIM2_INIT_Middle();
	TIM2_IER |=0x01;//TIM2_IER |=0x40;//使能中断
  TIM2_CR1 |=0X01;
}
void T1_Fast_for_ledbuz_EN(void)
{
  TIM2_INIT_Fast();
	TIM2_IER |=0x01;//TIM2_IER |=0x40;//使能中断
  TIM2_CR1 |=0X01;
}
void T1_for_ledbuz_DIS(void)
{
  TIM2_CR1 &=~0X01;
	TIM2_IER &=~0x40;//使能中断
	CLK_PCKENR1&=~0X01;      //关闭TIM2时钟
}