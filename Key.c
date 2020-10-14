#include"my_define.h"


/*******interrupt config*********/
void INT_key_Init(void)
{
	PC_DDR &=0xFD;    //PC1设为输入 xxxxxx0x
	PC_CR1 &=0xFD;    //PC1悬浮输入 xxxxxx0x
	PC_CR2 |=0x02;    //PC1使能中断 00000010
	ITC_SPR3=0xFB;    //端口PC1外部中断，优先级1
	EXTI_CR1|=0X04;     //PortC中断选为上升沿触发
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
	if((flag_key==2)||(flag_key==3) )  //进入配对状态
	{
		//STIE=0;//禁止唤醒定时器中断
		link();
		flag_key=0;
		//STIE=1;//使能唤醒定时器中断
	}
	if(flag_key==4)  //清除码
	{
		str[0]=0xFF;str[1]=0xFF;str[2]=0xFF;has_code=0xFF;  //写空数据
		RAM_write();
		delay(50);
		ledflash(brue,3,50,50);
		flag_key=0;
	}
}