#include"my_define.h"
void TIM2_INIT_Slow(void)//�ӱ�����
{
	CLK_PCKENR1|=0X01;      //��TIM2ʱ��
  
	TIM2_CR1 =0X80;   //Ԥ �� �� ������ ����
	TIM2_PSCR =0X05; //��Ƶ4=mhz T=us
	
	TIM2_ARRH =0Xff;
	TIM2_ARRL =0Xff;   //8MHz 32Div 
	
	TIM2_SR1&=~0x01;
}

void TIM2_INIT_Middle(void)//��������
{
	CLK_PCKENR1|=0X01;      //��TIM2ʱ��
  
	TIM2_CR1 =0X80;   //Ԥ �� �� ������ ����
	TIM2_PSCR =0X05; //��Ƶ4=mhz T=us
	
	TIM2_ARRH =0Xbb;
	TIM2_ARRL =0Xbb;   //8MHz 32Div 
	
	TIM2_SR1&=~0x01;
}

void TIM2_INIT_Fast(void)//���ʱ��
{
	CLK_PCKENR1|=0X01;      //��TIM2ʱ��
  
	TIM2_CR1 =0X80;   //Ԥ �� �� ������ ����
	TIM2_PSCR =0X05; //��Ƶ4=mhz T=us
	
	TIM2_ARRH =0Xa2;
	TIM2_ARRL =0X0f;   //8MHz 32Div a20f==0.1646s
	
	TIM2_SR1&=~0x01;
}

void T1_Slow_for_ledbuz_EN(void)
{
  TIM2_INIT_Slow();
	TIM2_IER |=0x01;//TIM2_IER |=0x40;//ʹ���ж�
  TIM2_CR1 |=0X01;
}
void T1_Middle_for_ledbuz_EN(void)
{
  TIM2_INIT_Middle();
	TIM2_IER |=0x01;//TIM2_IER |=0x40;//ʹ���ж�
  TIM2_CR1 |=0X01;
}
void T1_Fast_for_ledbuz_EN(void)
{
  TIM2_INIT_Fast();
	TIM2_IER |=0x01;//TIM2_IER |=0x40;//ʹ���ж�
  TIM2_CR1 |=0X01;
}
void T1_for_ledbuz_DIS(void)
{
  TIM2_CR1 &=~0X01;
	TIM2_IER &=~0x40;//ʹ���ж�
	CLK_PCKENR1&=~0X01;      //�ر�TIM2ʱ��
}