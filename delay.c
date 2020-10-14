/*******延时us函数*******/
void delay_us(unsigned int x)   //实测1000=872 
{
	while(x--);
}

/*******延时ms函数*******/
void delay_ms(unsigned int ms)
{
	unsigned int i;
	while(ms--)
	{  
		for(i=900;i>0;i--)
		{
			_asm("nop"); //一个asm("nop")函数经过示波器测试代表100ns
			_asm("nop");
			_asm("nop");
			_asm("nop"); 
		}
	}
}

/*******延时s函数*******/
void delay(unsigned int s)
{
	unsigned int i;
	for(i=s;i>0;i--)
	{
		delay_ms(10);
	}
}