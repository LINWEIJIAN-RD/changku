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
	vEnableAntSwitch(0);  //���������л�_IO���л�
	//vGpioFuncCfg(GPIO1_INT1+GPIO2_INT2+GPIO3_INT2+GPIO4_DOUT); //IO�ڵ�ӳ��????????????????????????GPIO1
  vGpioFuncCfg(GPIO1_INT1+GPIO2_INT2+GPIO3_DOUT+GPIO4_DOUT);//gai
	vIntSrcCfg(INT_TX_DONE, INT_FIFO_NMTY_TX);    //IO���жϵ�ӳ��????????????????????
	vIntSrcEnable(TX_DONE_EN);           //�ж�ʹ��        
	
	vClearFIFO();  //���FIFO
	bGoSleep();    //����˯��
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
	vIntSrcEnable(PKT_DONE_EN+PREAMBLE_PASS_EN);   //�ж�ʹ�� ��ʹ�ܺ���Ӧflag������1//�˺���ִֻ�����һ�εĲ���
	vClearFIFO();
	bGoSleep();
}
void loop_Tx(void)
{
	unsigned char Intflag;
	bSendMessage(str, LEN);//bGoTx();//jia
	while(GPO3_L());   // �ж�GPIO�ж� Ϊ�͵� Ϊ�������������   �жϱ��ҹر��ˣ�������������������
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
		RSSI_val=bSpi3Read(CMT23_RSSI_DBM);//��  ��RSSI
		bGoStandby();     //��סfifo�����͹���?
		bGetMessage(getstr);  //���浽���ܿ���getstr�յ������ݰ� ���� 0x48
		bIntSrcFlagClr();
		vClearFIFO(); 
		//ledflash(red,1,300,300);//JIA
		return 1;
	}
	else return 0;
}