
/**********************************************************
3-wire spi
**********************************************************/

#include<spi.h>
#include<CMT2300drive.h>

/**********************************************************
**Name: 	vSpi3Init
**Func: 	Init Spi-3 Config
**Note: 	
**********************************************************/
void vSpi3Init(void)
{
	PC_DDR|=0X60;  // PC1 PC5 PC6  //输出低
	PC_CR1|=0X60;
	PC_ODR&=~0X60;
	PD_DDR|=0X01;  //PD0 //输出低
	PD_CR1|=0X01;
	PD_ODR&=~0X01;
	PB_DDR|=0X10;  //PB4 //输出低
	PB_CR1|=0X10;
	PB_ODR&=~0X10;
	
	SetCSB();
	SetFCSB();
	SetSDIO();
	ClrSDCK();
}

/**********************************************************
**Name: 	vSpi3WriteByte
**Func: 	SPI-3 send one byte 发送一位
**Input:    
**Output:  
**********************************************************/
void vSpi3WriteByte(unsigned char dat)
{

 	unsigned char bitcnt;	
 
	SetFCSB();				//FCSB = 1;
 
 	OutputSDIO();			//SDA output mode
 	OutputSDIO();			//SDA output mode
 	SetSDIO();				//    output 1
 
 	ClrSDCK();				
 	ClrCSB();

 	for(bitcnt=8; bitcnt!=0; bitcnt--)
 		{
		ClrSDCK();	
		delay_us(SPI3_SPEED);
 		if(dat&0x80)
 			SetSDIO();
 		else
 			ClrSDIO();
		SetSDCK();
 		dat <<= 1; 		
 		delay_us(SPI3_SPEED);
 		}
 	ClrSDCK();		
 	SetSDIO();
}

/**********************************************************
**Name: 	bSpi3ReadByte
**Func: 	SPI-3 read one byte 读取一位
**Input:
**Output:  
**********************************************************/
unsigned char bSpi3ReadByte(void)
{
	unsigned char RdPara = 0;
 	unsigned char bitcnt;
  
 	ClrCSB(); 
 	InputSDIO();			
  	InputSDIO();		
 	for(bitcnt=8; bitcnt!=0; bitcnt--)
 		{
 		ClrSDCK();
 		RdPara <<= 1;
 		delay_us(SPI3_SPEED);
 		SetSDCK();
 		delay_us(SPI3_SPEED);
 		if(SDIO_H())
 			RdPara |= 0x01;
 		else
 			RdPara |= 0x00;
 		} 
 	ClrSDCK();
 	OutputSDIO();
	OutputSDIO();
 	SetSDIO();
 	SetCSB();			
 	return(RdPara);	
}

/**********************************************************
**Name:	 	vSpi3Write
**Func: 	SPI Write One word
**Input: 	Write word写一个字（16位）高7位是地址，低8位是数据
**Output:	none
**********************************************************/
void vSpi3Write(unsigned int dat)
{
 	vSpi3WriteByte((unsigned char)(dat>>8)&0x7F);
 	vSpi3WriteByte((unsigned char)dat);
 	SetCSB();
}

/**********************************************************
**Name:	 	bSpi3Read
**Func: 	SPI-3 Read One byte
**Input: 	readout addresss   （8位） 首位是读标志，后7位是地址
**Output:	readout byte
**********************************************************/
unsigned char bSpi3Read(unsigned char addr)
{
  	vSpi3WriteByte(addr|0x80);
 	return(bSpi3ReadByte());
}

/**********************************************************
**Name:	 	vSpi3WriteFIFO
**Func: 	SPI-3 send one byte to FIFO 
**Input: 	one byte buffer
**Output:	none
**********************************************************/
void vSpi3WriteFIFO(unsigned char dat)
{
 	unsigned char bitcnt;	
 
 	SetCSB();	
	OutputSDIO();	
	ClrSDCK();
 	ClrFCSB();			//FCSB = 0
	delay_us(SPI3_SPEED);		//Time-Critical  jia
 	delay_us(SPI3_SPEED);		//Time-Critical  jia
	for(bitcnt=8; bitcnt!=0; bitcnt--)
	{
 		ClrSDCK();
 		
 		if(dat&0x80)
			SetSDIO();		
		else
			ClrSDIO();
		delay_us(SPI3_SPEED);
		SetSDCK();
		delay_us(SPI3_SPEED);
 		dat <<= 1;
	}
 	ClrSDCK();	
 	delay_us(SPI3_SPEED);		//Time-Critical
 	//delay_us(SPI3_SPEED);		//Time-Critical
	//delay_us(SPI3_SPEED);		//Time-Critical  jia
 	SetFCSB();
	delay_us(SPI3_SPEED);		//Time-Critical  jia
	SetSDIO();
 	//delay_us(SPI3_SPEED);		//Time-Critical
 	//delay_us(SPI3_SPEED);		//Time-Critical
	//delay_us(SPI3_SPEED);		//Time-Critical  jia 
 	//delay_us(SPI3_SPEED);		//Time-Critical  jia
}

/**********************************************************
**Name:	 	bSpi3ReadFIFO
**Func: 	SPI-3 read one byte to FIFO
**Input: 	none
**Output:	one byte buffer
**********************************************************/
unsigned char bSpi3ReadFIFO(void)
{
	unsigned char RdPara;
 	unsigned char bitcnt;	
 	
 	SetCSB();
	InputSDIO();
 	ClrSDCK();
	ClrFCSB();
	delay_us(SPI3_SPEED);		//Time-Critical  jia
 	delay_us(SPI3_SPEED);		//Time-Critical  jia	
 	for(bitcnt=8; bitcnt!=0; bitcnt--)
 		{
 		ClrSDCK();
 		RdPara <<= 1;
 		delay_us(SPI3_SPEED);
		SetSDCK();
		delay_us(SPI3_SPEED);
 		if(SDIO_H())
 			RdPara |= 0x01;		//NRZ MSB
 		else
 		 	RdPara |= 0x00;		//NRZ MSB
 		}
 	
 	ClrSDCK();
  delay_us(SPI3_SPEED);		//Time-Critical
 	//delay_us(SPI3_SPEED);		//Time-Critical
	//delay_us(SPI3_SPEED);		//Time-Critical  jia
 	SetFCSB();
	delay_us(SPI3_SPEED);		//Time-Critical  jia
	OutputSDIO();
	SetSDIO();
 	//delay_us(SPI3_SPEED);		//Time-Critical
 	//delay_us(SPI3_SPEED);		//Time-Critical
	//delay_us(SPI3_SPEED);		//Time-Critical  jia
	//delay_us(SPI3_SPEED);		//Time-Critical  jia
 	return(RdPara);
}

/**********************************************************
**Name:	 	vSpi3BurstWriteFIFO
**Func: 	burst wirte N byte to FIFO
**Input: 	array length & head pointer
**Output:	none
**********************************************************/
void vSpi3BurstWriteFIFO(unsigned char ptr[], unsigned char length)
{
 	unsigned char i;
 	if(length!=0x00)
	 	{
 		for(i=0;i<length;i++)
 			vSpi3WriteFIFO(ptr[i]);
 		}
 	return;
}

/**********************************************************
**Name:	 	vSpiBurstRead
**Func: 	burst wirte N byte to FIFO
**Input: 	array length  & head pointer
**Output:	none
**********************************************************/
void vSpi3BurstReadFIFO(unsigned char ptr[], unsigned char length)
{
	unsigned char i;
 	if(length!=0)
 		{
 		for(i=0;i<length;i++)
 			ptr[i] = bSpi3ReadFIFO();
 		}	
 	return;
}
  