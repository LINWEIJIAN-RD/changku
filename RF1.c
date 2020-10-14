#include<CMT2300drive.h>
#include<rf1.h>
#include"my_define.h"


unsigned char str[4];//= {'H','A','B','C',};
unsigned char getstr[4];//getstr[LEN+1];
extern Bool FixedPktLength;						//false: for contain packet length in Tx message, the same mean with variable lenth
 		                                            //true : for doesn't include packet length in Tx message, the same mean with fixed length
extern unsigned int PayloadLength;						//unit: byte  range: 1-2047                                      
		
extern unsigned char PktRssi;


void setup_Tx(void)
{

	FixedPktLength    = True;				
	PayloadLength     = LEN;	

	vInit();
	vCfgBank(CMTBank,12);
	vCfgBank(SystemBank,12);
	vCfgBank(FrequencyBank, 8);
	vCfgBank(DataRateBank, 24);
	vCfgBank(BasebandBank, 29);
	vCfgBank(TXBank, 11);
	vEnableAntSwitch(0);  //设置天线切换_IO口切换
	//vGpioFuncCfg(GPIO1_INT1+GPIO2_INT2+GPIO3_INT2+GPIO4_DOUT); //IO口的映射????????????????????????GPIO1
  vGpioFuncCfg(GPIO1_INT1+GPIO2_INT2+GPIO3_DOUT+GPIO4_DOUT);//gai
	vIntSrcCfg(INT_TX_DONE, INT_FIFO_NMTY_TX);    //IO口中断的映射????????????????????
	vIntSrcEnable(TX_DONE_EN);           //中断使能        
	
	vClearFIFO();  //清除FIFO
	bGoSleep();    //进入睡眠
}

void setup_Rx(void)
{
	FixedPktLength	= True;			   
	PayloadLength 	= LEN; 
	
	vInit();
	vCfgBank(CMTBank, 12);
	vCfgBank(SystemBank, 12);
	vCfgBank(FrequencyBank, 8);
	vCfgBank(DataRateBank, 24);
	vCfgBank(BasebandBank, 29);
	vCfgBank(TXBank, 11);
	vEnableAntSwitch(0);
	
	vGpioFuncCfg(GPIO1_INT1+GPIO2_INT2+GPIO3_INT2+GPIO4_DOUT);	
	vIntSrcCfg(INT_PREAM_PASS , INT_PKT_DONE);
	vIntSrcEnable(PKT_DONE_EN+PREAMBLE_PASS_EN);   //中断使能 ，使能后相应flag才能置1//此函数只执行最后一次的操作
	vClearFIFO();
	bGoSleep();
}
void loop_Tx(void)
{
	unsigned char Intflag;
	bSendMessage(str, LEN);//bGoTx();//jia
	while(GPO3_L());   // 判断GPIO中断 为低等 为高运行下面代码   中断被我关闭了！！！！！！！！！！
	//bIntSrcFlagClr();
	//vClearFIFO(); 
	while(1);
	//delay_ms(200);
}
char loop_Rx1(void)
{
	if((bSpi3Read(CMT23_INT_FLG) & RX_DONE_FLAG )!=0)   //{bIntSrcFlagClr(); ;}   /*///if(GPO3_H())
	{
	  //getstr[0]=getstr[1]=getstr[2]=getstr[3]=getstr[4]=0;
		RSSI_val=bSpi3Read(CMT23_RSSI_DBM);//加  收RSSI
		bGoStandby();     //锁住fifo，降低功耗?
		bGetMessage(getstr);  //仿真到此能看到getstr收到的数据包 等于 0x48
		bIntSrcFlagClr();
		vClearFIFO(); 
		//ledflash(red,1,300,300);//JIA
		return 1;
	}
	else return 0;
}