#include"my_define.h"


/*******interrupt config*********/
void INT_key_Init(void)
{
	PC_DDR &=0xFD;    //PC1��Ϊ���� xxxxxx0x
	PC_CR1 &=0xFD;    //PC1�������� xxxxxx0x
	PC_CR2 |=0x02;    //PC1ʹ���ж� 00000010
	ITC_SPR3=0xFB;    //�˿�PC1�ⲿ�жϣ����ȼ�1
	EXTI_CR1|=0X04;     //PortC�ж�ѡΪ�����ش���
}

void key(void)
{
  IntDisable;
  if((0<keydelay)&&(keydelay<400))
  {
    keydelay=0;
    flag_key=1;  
  }
  if((400<=keydelay)&&(keydelay<500))
  {
    keydelay=0;
    flag_key=2;
  }
	if((500<=keydelay)&&(keydelay<600))
  {
    keydelay=0;
    flag_key=3;
  }
  if((600<=keydelay)&&(keydelay<700))
  {
    keydelay=0;
    flag_key=4; 
  }
  keydelay=0;
  IntEnable;
	if(flag_key==1)
	{
		get_msg_alarm=master_test;
		flag_key=0;
	}
	if((flag_key==2)||(flag_key==3) )  //�������״̬
	{
		//STIE=0;//��ֹ���Ѷ�ʱ���ж�
		link();
		flag_key=0;
		//STIE=1;//ʹ�ܻ��Ѷ�ʱ���ж�
	}
	if(flag_key==4)  //�����
	{
		str[0]=0xFF;str[1]=0xFF;str[2]=0xFF;has_code=0xFF;  //д������
		RAM_write();
		delay(50);
		ledflash(brue,3,50,50);
		flag_key=0;
	}
}