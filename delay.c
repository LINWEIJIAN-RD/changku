/*******��ʱus����*******/
void delay_us(unsigned int x)   //ʵ��1000=872 
{
	while(x--);
}

/*******��ʱms����*******/
void delay_ms(unsigned int ms)
{
	unsigned int i;
	while(ms--)
	{  
		for(i=900;i>0;i--)
		{
			_asm("nop"); //һ��asm("nop")��������ʾ�������Դ���100ns
			_asm("nop");
			_asm("nop");
			_asm("nop"); 
		}
	}
}

/*******��ʱs����*******/
void delay(unsigned int s)
{
	unsigned int i;
	for(i=s;i>0;i--)
	{
		delay_ms(10);
	}
}