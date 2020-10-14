#include<STM8L051F3.h>


extern unsigned char str[4];
extern char has_code;

extern unsigned char *q;





void RAM_write(void)
{
	q = (char *)0x1010;
	FLASH_DUKR =0XAE;
	FLASH_DUKR =0X56;
	while((FLASH_IAPSR & 0X08)==0);
	*q = str[0];
	q=q+1;
	*q = str[1];
	q=q+1;
  *q = str[2];
	q=q+1;
  *q = has_code;
	while((FLASH_IAPSR & 0X04)==0);
	FLASH_IAPSR &=~0X08;
		//  data[0]=code[0];data[1]=code[1];data[2]=code[2];data[3]=has_code;
}

void RAM_read(void)
{
	q=(char *)0x1010;
  str[0] = *q;//出厂需要连一起的要给他写个码
	q=q+1;
	str[1] = *q;//出厂需要连一起的要给他写个码
	q=q+1;
  str[2] = *q;
	q=q+1;
  has_code = *q;
	//str[0]='H';str[1]='A';
}