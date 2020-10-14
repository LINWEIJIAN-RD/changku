#include<my_define.h>
#include<spi.h>
Bool FixedPktLength;						//false: for contain packet length in Tx message, the same mean with variable lenth
 		                                            //true : for doesn't include packet length in Tx message, the same mean with fixed length
unsigned int PayloadLength;						//unit: byte  range: 1-2047                                      
		
unsigned char PktRssi;
Bool RssiTrig;

Bool bGoTx(void)
{
	unsigned char tmp, i;
	 
	vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TFS);	
	for(i=0; i<50; i++)
	{
		tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
		if(tmp==MODE_STA_TFS)
			break;
		//delay_us(2);	
	}
	if(i>=50)
		return(False);
	
	vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TX);		
	for(i=0; i<50; i++)
	{
		tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
		if(tmp==MODE_STA_TX)
			break;
		//delay_us(2);	
	}
	if(i>=50)
		return(False);
	else
		return(True);
}

/**********************************************************
**Name:     bGoRx
**Function: Entry Rx Mode
**Input:    none
**Output:   none
**********************************************************/

unsigned char vReadIngFlag1(void)
{
	return(bSpi3Read((unsigned char)(CMT23_INT_FLG>>8)));

}

unsigned char vReadIngFlag2(void)
{
	return(bSpi3Read((unsigned char)(CMT23_INT_CLR1	>>8)));

}


Bool bGoRx(void)//1.27ms
{
 unsigned char tmp, i;
 RssiTrig = False;
 vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_RFS);	
 for(i=0; i<50; i++)
 	{
 	delay_us(200);	
	tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
	if(tmp==MODE_STA_RFS)
		break;
	}
 if(i>=50)
 	return(False);
  
 vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_RX);		
 for(i=0; i<50; i++)
 	{
 	delay_us(200);	
	tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
	if(tmp==MODE_STA_RX)
		break;
	}
 if(i>=50)
 	return(False);
 else
 	return(True);
}

/**********************************************************
**Name:     bGoSleep
**Function: Entry Sleep Mode
**Input:    none
**Output:   none
**********************************************************/
Bool bGoSleep(void)
{
 unsigned char tmp;
 
 vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_SLEEP);	
 //delay_ms(100);		//我注释 没去89.8ms 去掉后0.3136ms  //enough?
 tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
 if(tmp==MODE_STA_SLEEP)
 	return(True);
 else
 	return(False);
}

/**********************************************************
**Name:     bGoStandby
**Function: Entry Standby Mode
**Input:    none
**Output:   none
**********************************************************/
Bool bGoStandby(void)
{
 unsigned char tmp, i;	
 
 RssiTrig = False;
 vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_STBY);	
 for(i=0; i<50; i++)
 {
 	delay_us(400);	
	tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
	if(tmp==MODE_STA_STBY)
		break;
	}
 if(i>=50)
 	return(False);
 else
 	return(True);
}

/**********************************************************
**Name:     vSoftReset
**Function: Software reset Chipset
**Input:    none
**Output:   none
**********************************************************/
void vSoftReset(void)
{
 vSpi3Write(((unsigned int)CMT23_SOFTRST<<8)+0xFF); 
 delay_us(1000);				//enough?
}

/**********************************************************
**Name:     bReadStatus
**Function: read chipset status
**Input:    none
**Output:   none
**********************************************************/
unsigned char bReadStatus(void)
{
 return(MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));		
}

/**********************************************************
**Name:     bReadRssi
**Function: Read Rssi
**Input:    true------dBm;
            false-----Code;
**Output:   none
**********************************************************/
unsigned char bReadRssi(Bool unit_dbm)
{
 if(unit_dbm)
 	return(bSpi3Read(CMT23_RSSI_DBM));
 else		
 	return(bSpi3Read(CMT23_RSSI_CODE));
}

/**********************************************************
GPIO & Interrupt CFG
**********************************************************/
/**********************************************************
**Name:     vGpioFuncCfg
**Function: GPIO Function config
**Input:    none
**Output:   none
**********************************************************/
void vGpioFuncCfg(unsigned char io_cfg)
{
 vSpi3Write(((unsigned int)CMT23_IO_SEL<<8)+io_cfg);
}

/**********************************************************
**Name:     vIntSrcCfg
**Function: config interrupt source  
**Input:    int_1, int_2
**Output:   none
**********************************************************/
void vIntSrcCfg(unsigned char int_1, unsigned char int_2)
{
 unsigned char tmp;
 tmp = INT_MASK & bSpi3Read(CMT23_INT1_CTL);
 vSpi3Write(((unsigned int)CMT23_INT1_CTL<<8)+(tmp|int_1));
 
 tmp = INT_MASK & bSpi3Read(CMT23_INT2_CTL);
 vSpi3Write(((unsigned int)CMT23_INT2_CTL<<8)+(tmp|int_2));
}

/**********************************************************
**Name:     vEnableAntSwitch
**Function:  
**Input:    
**Output:   none
**********************************************************/
void vEnableAntSwitch(unsigned char mode)
{
 unsigned char tmp;
 tmp = bSpi3Read(CMT23_INT1_CTL);
 tmp&= 0x3F;
 switch(mode)
 	{
 	case 1:
 		tmp |= RF_SWT1_EN; break;		//GPO1=RxActive; GPO2=TxActive	
 	case 2:
 		tmp |= RF_SWT2_EN; break;		//GPO1=RxActive; GPO2=!RxActive
 	case 0:
 	default:
 		break;							//Disable	
 	}
 vSpi3Write(((unsigned int)CMT23_INT1_CTL<<8)+tmp);
}


/**********************************************************
**Name:     vIntSrcEnable
**Function: enable interrupt source 
**Input:    en_int
**Output:   none
**********************************************************/
void vIntSrcEnable(unsigned char en_int)
{
 vSpi3Write(((unsigned int)CMT23_INT_EN<<8)+en_int);				
}

/**********************************************************
**Name:     vIntSrcFlagClr
**Function: clear flag
**Input:    none
**Output:   equ CMT23_INT_EN
**********************************************************/
unsigned char bIntSrcFlagClr(void)
{
 unsigned char tmp;
 unsigned char int_clr2 = 0;
 unsigned char int_clr1 = 0;
 unsigned char flg = 0;
 
 tmp = bSpi3Read(CMT23_INT_FLG);
 if(tmp&LBD_STATUS_FLAG)		//LBD_FLG_Active
 	int_clr2 |= LBD_CLR;
 
 if(tmp&PREAMBLE_PASS_FLAG)		//Preamble Active
 	{
 	int_clr2 |= PREAMBLE_PASS_CLR;
 	flg |= PREAMBLE_PASS_EN;
	}
 if(tmp&SYNC_PASS_FLAG)			//Sync Active
 	{
 	int_clr2 |= SYNC_PASS_CLR;		
 	flg |= SYNC_PASS_EN;		
 	}
 if(tmp&NODE_PASS_FLAG)			//Node Addr Active
 	{
 	int_clr2 |= NODE_PASS_CLR;	
 	flg |= NODE_PASS_EN;
 	}
 if(tmp&CRC_PASS_FLAG)			//Crc Pass Active
 	{
 	int_clr2 |= CRC_PASS_CLR;
 	flg |= CRC_PASS_EN;
 	}
 if(tmp&RX_DONE_FLAG)			//Rx Done Active
 	{
 	int_clr2 |= RX_DONE_CLR;
 	flg |= PKT_DONE_EN;
 	}
 	
 if(tmp&COLLISION_ERR_FLAG)		//这两个都必须通过RX_DONE清除
 	int_clr2 |= RX_DONE_CLR;
 if(tmp&DC_ERR_FLAG)
 	int_clr2 |= RX_DONE_CLR;
 	
 vSpi3Write(((unsigned int)CMT23_INT_CLR2<<8)+int_clr2);	//Clear flag
 
 
 tmp = bSpi3Read(CMT23_INT_CLR1);
 if(tmp&TX_DONE_FLAG)
 	{
 	int_clr1 |= TX_DONE_CLR;
 	flg |= TX_DONE_EN;
 	}	
 if(tmp&SLEEP_TIMEOUT_FLAG)
 	{
 	int_clr1 |= SLEEP_TIMEOUT_CLR;
 	flg |= SLEEP_TMO_EN;
 	} 
 if(tmp&RX_TIMEOUT_FLAG)
 	{
 	int_clr1 |= RX_TIMEOUT_CLR;
 	flg |= RX_TMO_EN;
 	}	
 vSpi3Write(((unsigned int)CMT23_INT_CLR1<<8)+int_clr1);	//Clear flag 
 
 return(flg);
}

/**********************************************************
**Name:     bClearFIFO
**Function: clear FIFO buffer
**Input:    none
**Output:   FIFO state
**********************************************************/
unsigned char vClearFIFO(void)
{
 unsigned char tmp;	
 tmp = bSpi3Read(CMT23_FIFO_FLG);
 vSpi3Write(((unsigned int)CMT23_FIFO_CLR<<8)+FIFO_CLR_RX+FIFO_CLR_TX);
 return(tmp);
}

void vEnableWrFifo(void)
{
 unsigned char tmp;
 tmp = bSpi3Read(CMT23_FIFO_CTL);
 tmp |= (SPI_FIFO_RD_WR_SEL|FIFO_RX_TX_SEL);
 vSpi3Write(((unsigned int)CMT23_FIFO_CTL<<8)+tmp);
}

void vEnableRdFifo(void)
{
 unsigned char tmp;
 tmp = bSpi3Read(CMT23_FIFO_CTL);
 tmp &= (~(SPI_FIFO_RD_WR_SEL|FIFO_RX_TX_SEL));
 vSpi3Write(((unsigned int)CMT23_FIFO_CTL<<8)+tmp);
}

/**********************************************************
CFG
**********************************************************/
/**********************************************************
**Name:     vInit
**Function: Init. CMT2300A
**Input:    none
**Output:   none
**********************************************************/
void vInit(void)
{
 //byte i;
 unsigned char tmp;
 Bool tmp1;
 //word len;
 
 vSpi3Init();
 
 //GPO3In();
 //GPO3IT();//jia?????????????????????????????????????????????????????
 //_asm("sim");
 //EXTI_CR1|=0x01;//PC0 Rising 
 //_asm("rim");
 vSoftReset();
 //delay_ms(20);//我注释，延时太久功耗高
tmp1 = bGoStandby();
if(tmp1 == False)
{
	while(1);
}
 //	
 tmp = bSpi3Read(CMT23_MODE_STA);
 tmp|= EEP_CPY_DIS;
 tmp&= (~RSTN_IN_EN);			//Disable RstPin	
 vSpi3Write(((unsigned int)CMT23_MODE_STA<<8)+tmp);

 bIntSrcFlagClr();
 
}

void vCfgBank(unsigned int cfg[], unsigned char length)
{
 unsigned char i;
 
 if(length!=0)
 	{	
 	for(i=0; i<length; i++)	
 		vSpi3Write(cfg[i]);
 	}	
}


/******************************************************************************
**函数名称：bGetMessage
**函数功能：接收一包数据
**输入参数：无
**输出参数：非0——接收成功
**          0——接收失败
******************************************************************************/
unsigned char bGetMessage(unsigned char msg[])
{
 unsigned char i;	
 
 vEnableRdFifo();	
 if(FixedPktLength)
 	{
  	vSpi3BurstReadFIFO(msg, PayloadLength);
	i = PayloadLength;
	}
 else
 	{
	i = bSpi3ReadFIFO();	
 	vSpi3BurstReadFIFO(msg, i);
 	}
 return(i);
}

unsigned char bGetMessageByFlag(unsigned char msg[])
{
 unsigned char tmp;
 unsigned char tmp1;
 unsigned char rev = 0;
 tmp = bSpi3Read(CMT23_INT_FLG);
 if((tmp&SYNC_PASS_FLAG)&&(!RssiTrig))
 	{
 	PktRssi = bReadRssi(False);
 	RssiTrig = True;
 	}
 
 tmp1 = bSpi3Read(CMT23_CRC_CTL);
 vEnableRdFifo();	 
 if(tmp1&CRC_ENABLE)		//Enable CrcCheck
 	{
 	if(tmp&CRC_PASS_FLAG)
 		{
 		if(FixedPktLength)
 			{
  			vSpi3BurstReadFIFO(msg, PayloadLength);
			rev = PayloadLength;
			}
 		else
 			{	
			rev = bSpi3ReadFIFO();	
 			vSpi3BurstReadFIFO(msg, rev);
 			}
 		RssiTrig = False;
 		}
 	}
 else
 	{
	if(tmp&RX_DONE_FLAG) 		
		{
 		if(FixedPktLength)
 			{
  			vSpi3BurstReadFIFO(msg, PayloadLength);
			rev = PayloadLength;
			}
 		else
 			{	
			rev = bSpi3ReadFIFO();	
 			vSpi3BurstReadFIFO(msg, rev);
 			}	
 		RssiTrig = False;		
		}
 	}
 
 if(tmp&COLLISION_ERR_FLAG)			//错误处理
	rev = 0xFF;
 return(rev);
}

/******************************************************************************
**函数名称：bSendMessage
**函数功能：发射一包数据
**输入参数：无
**输出参数：
**          
******************************************************************************/
Bool bSendMessage(unsigned char msg[], unsigned char length)
{
	//mode1
	//vSetTxPayloadLength(length);
	//bGoStandby();
	//vEnableWrFifo();	
	//vSpi3BurstWriteFIFO(msg, length);
	//bGoTx();
	//mode2
	//bIntSrcFlagClr();  //清中断,调试发现这里没有中断标志可清
	vSetTxPayloadLength(length);
	bIntSrcFlagClr();  //jia 调试发现stanby会产生TX_DONE中断，所以加了清除中断标志
	vEnableWrFifo();	
	vSpi3BurstWriteFIFO(msg, length);
	bGoTx();
	while(1)
	{
		//if(GPO3_H())
		//{
		  //delay_ms(311);
			//bIntSrcFlagClr();
			//vSpi3Write(((unsigned int)CMT23_INT_CLR1<<8)+TX_DONE_CLR);	//Clear TX_DONE flag 
			//bGoTx();
			//delay_ms(310);
		//}
		//i++;
		//bGoStandby();
		/*delay_ms(300);//268ms 
		bGoTx();//每次间隔1.9ms  */
	}
	
	
	return(True);
}

void vSetTxPayloadLength(unsigned int length)
{
 unsigned char tmp;	
 unsigned char len;
 bGoStandby();//调试发现stanby会产生TX_DONE中断
 tmp = bSpi3Read(CMT23_PKT_CTRL1);
 tmp&= 0x8F;
 
 if(length!=0)
 	{
 	if(FixedPktLength)
		len = length-1;
 	else
		len = length;
	}
 else
 	len = 0;
 
 tmp|= (((unsigned char)(len>>8)&0x07)<<4);
 vSpi3Write(((unsigned int)CMT23_PKT_CTRL1<<8)+tmp);
 vSpi3Write(((unsigned int)CMT23_PKT_LEN<<8)+(unsigned char)len);	//Payload length
 //bGoSleep();
}
