  #ifndef __SPI__
    #define __SPI__
		
  #include"my_define.h" 
  #include<CMT2300drive.h>
  #define SPI3_SPEED 1 //时钟延时取值  20gai 15  12=12uS

  //#include "stm8s.h"
  //#include "main.h"
  //#include "Delay.h"
	
  #define	SetCSB()	PD_ODR|=0X01
  #define	ClrCSB()	PD_ODR&=~0X01
          
  #define	SetFCSB()	PC_ODR|=0X20
  #define	ClrFCSB()	PC_ODR&=~0X20
          
  #define	SetSDCK()	PC_ODR|=0X40
  #define	ClrSDCK()	PC_ODR&=~0X40
          
  #define	SetSDIO()	PB_ODR|=0X10
  #define	ClrSDIO()	PB_ODR&=~0X10
          
  #define   InputSDIO()		PB_DDR&=~0X10  // PB4输入 GPIO_Init(GPIO_PORT_D,GPIO_PINS_SDIO,GPIO_MODE_IN_FL_NO_IT)
  #define	OutputSDIO()	{PB_DDR|=0X10; PB_CR1|=0X10; PB_ODR&=~0X10;} //PC0 PB4 PC5 PC6  //输出低GPIO_Init(GPIO_PORT_D,GPIO_PINS_SDIO,GPIO_MODE_OUT_PP_LOW_FAST)  
          
  #define	SDIO_H()	(((PB_IDR&0x10)==0x10) ? 1 : 0)
  #define	SDIO_L()	(((PB_IDR&0x10)==0x00) ? 1 : 0)


	void vSpi3Init(void);				/** initialize software SPI-3 **/	
	void vSpi3Write(unsigned int dat);			/** SPI-3 send one unsigned int **/
	unsigned char bSpi3Read(unsigned char addr);			/** SPI-3 read one byte **/
		
	void vSpi3WriteFIFO(unsigned char dat);		/** SPI-3 send one byte to FIFO **/
	unsigned char bSpi3ReadFIFO(void);			/** SPI-3 read one byte from FIFO **/
	void vSpi3BurstWriteFIFO(unsigned char ptr[], unsigned char length);			/** SPI-3 burst send N byte to FIFO**/
	void vSpi3BurstReadFIFO(unsigned char ptr[], unsigned char length);			/** SPI-3 burst read N byte to FIFO**/
	
	void vSpi3WriteByte(unsigned char dat);		/** SPI-3 send one byte **/
	unsigned char bSpi3ReadByte(void);			/** SPI-3 read one byte **/


                             
  #endif 

