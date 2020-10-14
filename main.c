#include"my_define.h"
#include<CMT2300drive.h>

float  pow_val=0;
float  cal_val=0;
float  cal_val_temp=0;
float  pow_val_temp=0;
float  IR_val=0;

unsigned char flag_key=0;
char has_code;

extern char randum_val0,randum_val1;
extern unsigned char str[4];
extern unsigned char getstr[4];
unsigned int keydelay=0;

char if_alarm=0;
char get_msg_alarm=0;
char hush=all_ring,hush_key_flag=0,hush_flag=1,hush_change_flag=all_ring;

char *q;
float *p;
char pow_check_time_flag=0;
char Test_mode_flag;
int i;
unsigned int silence_time=0;
unsigned char Button_down_flag=0;


unsigned char RF_work_state=0x00;
unsigned char TX_num_temp=0,TX_num=0;
/**********唤醒定时器配置***********/
void sleep(void)
{
  CLK_PCKENR2|=0X04;	     //开启RTC时钟
	CLK_CRTCR=0x04;       //选择LSI作为RTC时钟源38KHZ
	RTC_WPR=0xca;       //去RTC寄存器写保护
	RTC_WPR=0x53;				//去RTC寄存器写保护
	RTC_CR2 &=0xfb;     //清除WUTE禁用RTC定时器 
	while((RTC_ISR1 & 0x04)!=0x04); //直到WUTWF标志位为1，允许重装载计数值
	RTC_CR1=0X00;        //RTC时钟分频选择2  38KHZ/2=19KHZ
	RTC_CR2 |=0x40;      //开RTC中断
	RTC_WUTRH=0X36;       //装载计数值高位364b
	RTC_WUTRL=0X4B;       //装载计数值低位    6S
	RTC_CR2 |=0X04;       //再次使能RTC定时器
	RTC_WPR=0X66;       //写个错key重开写保护
}
void CLK_INIT(void)
{
	CLK_SWCR =0X02;        //切换时钟
  CLK_SWR  =0X01;        //HSE 0X04 HSI 0X01 LSI 0X02  4MHz
	CLK_CKDIVR=0x00;       //1分频，必选
	//CLK_PCKENR1=0X00;      //关闭外设时钟
  CLK_PCKENR2|=0X01;	     //开启ADC1时钟//CLK_PCKENR2=0X00;	     //默认状态是1000 0000
}
char Test_Device(void)//修改频率，防止干扰。
{
	if((PC_IDR & 0X02)==0X02 )
  { 
    delay(3);
    if((PC_IDR & 0X02)==0X02 )
    { 
		  led_state(red, ON);
			led_state(brue, ON);
			_asm("rim");
			setup_Rx();
			GPO3In();
			GPO3IT();
			EXTI_CR1|=0x01;//PC0 Rising 
			while(1)
			{
				if( True==RF_Receive() ) //收到 
				{
					if( (getstr[0]==0x09) && (getstr[1]==0x23) )
					{
						str[0]=0x09;
						str[1]=0x23;
						AD_VDD_val();
						AD_IR_val();
						str[2]=(char)(IR_val*10000)|0x00;//suiji ;
						str[2]=((char)(pow_val*10000)|0x00)+str[2];
						while(1)
						{
							setup_Tx();
							bGoTx();//jia
							for(i=0;i<2;i++)//12s~140  2600改3250
							{
								loop_Tx();
							}
							GPO3IT();
							setup_Rx();
							if( True==RF_Receive() ) //收到 
							{
								if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
								{
									if(getstr[2]==str[2])//suiji
									{
										led_state(red, OFF);
			              led_state(brue, OFF);
										return 1;
									}
								}
							}
						}
					}
				}
			}
	  }
  }//PC1
}
void TX_fuction(unsigned char num)
{
	setup_Tx();
  RF_work_state=TX_state;
	TX_num_temp=0;
	TX_num=num;
	vSetTxPayloadLength(LEN);
	bIntSrcFlagClr();  //jia 调试发现stanby会产生TX_DONE中断，所以加了清除中断标志
	vEnableWrFifo();	
	//vClearFIFO(); //不确定
	vSpi3BurstWriteFIFO(str, LEN);
	
	bGoTx();
}


void main()
{
	CLK_INIT();
	GPIO_INIT();
	INT_key_Init();
  ADC_Init();	
	calibrat();
  _asm("rim");
  RAM_read();
  
	setup_Rx();//初始化为RX  遇到一个现象，加bGoRx(); while(1); 后，只能上电前有发射，才能进入接收。以后找原因,和rf1.h有关
	//bGoRx();
	//while(1);
	
  while(1)
  {
/***************************key scan********以下241.88MS*******************/
    key();
/************************power check*********以下241.8ms****************/
    pow_check();
/*********************Receive alarm msg*********以下241.740ms*************/
    for(i=0;i<1;i++)   //收
    {
      if( True==RF_Receive() ) //收到 没有确认收到数据包
      {
        //RAM_read();多余
        //if( (getstr[0]==0x11) && (getstr[1]==0x22) )
				/*
				if(RSSI_val<35)//桌面到3楼梯中间横梁上
					{
						ledflash(red,6,5,5);
					}
					
					else
					{				
						PC_ODR |= 0x10;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						delay(5);//delay_us(1000);//872
						PC_ODR &= 0xEF;
					}
				*/
				if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
        {
					
				  //ledflash(red,3,5,5); //5=44.730ms   //闪灯    **********************************test
          get_msg_alarm=getstr[2];//报警
          hush=getstr[3];//声音
          break;
        }
      }
    }
/*****************************check************以下785.3us***************/ 
    if(True==check_one())
    {
      for(if_alarm=9;if_alarm>1;)	      //8次
      {
        ledflash(red,1,10,10);
        delay(30);
        if_alarm--;
        check_one();
        if(IR_val<cal_val) break;
      }
    }
/***************************报警****************以下5.5us***************/
    if(if_alarm==1)//报警
    {
      unsigned char k=20,tem=1;
			hush_change_flag=all_ring;
      hush=all_ring;
      hush_flag=1;//test
			silence_time=0;//静音时长清零
      T1_Middle_for_ledbuz_EN();  //报警输出
/************************发送报警状态**************************/
      str[2]=alarm_code;
      str[3]=hush;
	    TX_fuction(30);//9秒左右
/**************************************************************/
      while(IR_val>cal_val)
      {
/************************发送报警状态**************************/
        if((k==0)&&(RF_work_state==Sleep_state))
        {
          str[2]=alarm_code+tem;
          //str[3]=hush;//不用了，以免错乱声音状态
					TX_fuction(5);//1.5秒左右
          tem++;
          if(tem==10)tem=0;
          k=20;//60改20
					while(RF_work_state==TX_state);//防止错过RX
        }
/**********************接收声音状态****************************/
				if(RF_work_state==Sleep_state)
				{					
					for(i=0;i<3;i++)   //收
					{
						if( True==RF_Receive() ) //收到
						{
							if( (getstr[0]==str[0]) && (getstr[1]==str[1]) && (getstr[2]!=alarm_code_test) )
							{
								if(getstr[3]!=all_ring) hush=getstr[3]; //
								break;
							}
						}
					}
				}
				if(hush==all_silence)      //主机静音模式
        {
          buz_state(OFF);
          hush_flag=0;
        }
/************************发送声音状态**************************/ 
        while( hush!=hush_change_flag )
        {
          str[3]=hush;
			    TX_fuction(20);//6秒左右
          hush_change_flag=hush;
        } 
/***********************检测一次*******************************/
        if(k==10)//30改10
        {
          check_one();
        }
/*************如果检测到报警解除，发送报警解除信号*************/
        if(IR_val<=cal_val)
        {
          buz_state(OFF);  //关闭蜂鸣器
          T1_for_ledbuz_DIS();//关定时器中断，从而关报警
					red_OFF;  //关闭红灯
          str[2]=dis_alarm_code;
					TX_fuction(20);//6秒左右
					while(RF_work_state==TX_state);
					break;
        }
/**************************************************************/
        k--;
      }
      if_alarm=0;
    }
/***************************************************如果收到报警信号********************************************/
    if((get_msg_alarm & 0xF0)==alarm_code)//滚动
    {
		  unsigned int n=0;
      unsigned char get_msg_alarm_flag=alarm_code;
			hush_change_flag=hush;
      hush_flag=1;//需要，不然会保留上次报警的静音
			silence_time=0;//静音时长清零
			/************************声音状态**************************/
			if( (hush==all_silence)||(hush==slave_silence) )      //从设备静音模式
			{
				buz_state(OFF);
				hush_flag=0;
			}
      T1_Slow_for_ledbuz_EN();  //报警信号输出
/************************发送报警状态**************************/
      if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
			{
				repeater=1;
				str[2]=get_msg_alarm;
				str[3]=hush;
				TX_fuction(20);//6秒左右
			}
			else delay_ms(6000);//yu主同步，test
/**************************************************************/
      while(get_msg_alarm!=dis_alarm_code)//while(get_msg_alarm==alarm_code)//1)//
      {
/************************发送报警或声音状态************************/
        //if(((RSSI_val_tam>0)&&(RSSI_val_tam<35))&&(RF_work_state==Sleep_state))
				if((repeater==1)&&(RF_work_state==Sleep_state))
        { ledflash(brue,6,20,5);//test测试RSSI！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
          str[2]=get_msg_alarm;
          str[3]=hush;//声音状态 
					TX_fuction(5);//1.5秒左右
					while(RF_work_state==TX_state);//防止错过RX
        }
/*********************接收报警是否解除和声音状态*************************/
        if(RF_work_state==Sleep_state)
				{
				  repeater=0;
					for(i=0;i<3;i++)   //收
					{ 
						if( True==RF_Receive() ) //收到
						{
							if( (getstr[0]==str[0]) && (getstr[1]==str[1]) && (getstr[2]!=alarm_code_test) )
							{
								get_msg_alarm=getstr[2];  //记下报警状态
								if(getstr[3]!=all_ring) hush=getstr[3]; //不然自身的静音信号被接收的刷新了
								GET_repeater();
								break;
							}
						}
					}
					/*********************判断是否超时退出报警状态*************************/
					if(get_msg_alarm_flag==get_msg_alarm)//旧信号
					{
						n++;
					}
					else /*if(get_msg_alarm_flag!=get_msg_alarm) */   //新信号，并发送新信号  60改160
					{
						get_msg_alarm_flag=get_msg_alarm;
						n=0;
					}
				  if(n>2000) {get_msg_alarm=dis_alarm_code; }     //超时未接收到新信息，则退出报警 10改5
        }
/************************声音状态**************************/
        if( (hush==all_silence)||(hush==slave_silence) )      //从设备静音模式
        {
          buz_state(OFF);
          hush_flag=0;
        }
/************************发送声音状态***************************/    
        //if(((hush!=hush_change_flag)&&(Button_down_flag==1))||((hush!=hush_change_flag)&&(RSSI_val<35)))
				if(((hush!=hush_change_flag)&&(Button_down_flag==1))||((hush!=hush_change_flag)&&(repeater==1)))//不需要等待之前的发送结束，为了更快静音
				{
				  str[2]=get_msg_alarm;
          str[3]=hush;
					TX_fuction(20);//6秒左右
          hush_change_flag=hush;
					Button_down_flag=0;
        }
/************如果接收到报警解除，发送报警解除信号*************/     
        if(get_msg_alarm==dis_alarm_code)      //报警解除
        {
          buz_state(OFF); //关闭蜂鸣器
					T1_for_ledbuz_DIS();//关定时器中断，从而关报警
					red_OFF;  //关闭红灯
          if((repeater==1)&&(RF_work_state==Sleep_state))
					{
						str[2]=get_msg_alarm;
						TX_fuction(20);//6秒左右
						while(RF_work_state==TX_state);
					}
          break;
        }
      }
      get_msg_alarm=0;
    }
/************************接收到测试*****************************/
		if((get_msg_alarm==alarm_code_test)&&(Test_mode_flag==0))
		//if(0)//
    {
			T1_Middle_for_ledbuz_EN();//实测95.3ms
			//***********************************************/
			if(RSSI_val<RSSI_val_set)//
			{
				TX_fuction(30);//9秒左右
				while(RF_work_state==TX_state);
		  }
			else delay_ms(9000);
			buz_state(OFF);  //关闭蜂鸣器
			T1_for_ledbuz_DIS();//关定时器中断，从而关报警
			red_OFF;  //关闭红灯
			get_msg_alarm=0;
			Test_mode_flag=3;
    }	
/************************测试模式*****************************/ 
    if((get_msg_alarm==master_test)&&(Test_mode_flag==0))//Test_mode_flag测试过后12S禁止测试                
    //if((1)&&(Test_mode_flag==0))
		{
			T1_Middle_for_ledbuz_EN();
			RAM_read();
			str[2]=alarm_code_test;
			TX_fuction(30);//9秒左右
			while(RF_work_state==TX_state);
			buz_state(OFF);  //关闭蜂鸣器
			T1_for_ledbuz_DIS();//关定时器中断，从而关报警
			red_OFF;  //关闭红灯
			get_msg_alarm=0;
			Test_mode_flag=3;
    }
		get_msg_alarm=0;//防止接收到上次休眠前的测试信号，而记录给下一次唤醒
	  keydelay=0;//清除静音产生的按键值 
/************************sleep配置*****************************/
    CLK_PCKENR1&=~0X01;//不加功耗高？？？？？？？
		IOconfig();
    sleep();
		_asm("halt"); 
	}
}
/********************按键中断程序PC1*************************/
@far @interrupt void button_interrupt(void)
{
  IntDisable;
  EXTI_SR1|=0x02;   //清除中断标志
	
	RTC_CR2 &=0xfb;     //关RTC定时器唤醒 
  RTC_CR2 &=0xbf;     //关RTC中断
	
  if((PC_IDR & 0X02)==0X02)
  { 
    delay_ms(3);
    if((PC_IDR & 0X02)==0X02) //改成报警后才能进去静音按键操作
    { 
		  Button_down_flag=1;
		  //keydelay=0;//换地方test
			if(if_alarm==0) //判断是否从设备
			{
				buz_state(OFF);
				hush_flag=0;
			  //i=0;//清除以确保发送足够的时长
				str[3]=slave_silence;
				hush=slave_silence;
			}
      if(if_alarm==1) //判断是否主设备
			{
				buz_state(OFF);
				hush_flag=0;
				//i=0;//清除以确保发送足够的时长
				hush=all_silence;
			}
      while((PC_IDR & 0X02)==0X02)
      {
        delay_ms(10);
        keydelay++;
        
        if((keydelay>250)&&(keydelay%100)==0)//逢100闪
        {
          ledflash(brue,1,20,0);
        }
      }
    }
  }
  IntEnable;
}
/*******唤醒定时器中断函数*******/
@far @interrupt void wakeup_interrupt(void)
{
	RTC_WPR=0xca;       //去RTC寄存器写保护
	RTC_WPR=0x53;				//去RTC寄存器写保护 
	RTC_CR2 &=0xfb;     //关RTC定时器唤醒 
  RTC_CR2 &=0xbf;     //关RTC中断
	RTC_WPR=0X66;       //写个错key重开写保护
  RTC_ISR2 &=~0x04;   //关允许访问标志位
	
	if(Test_mode_flag>0)Test_mode_flag--;
  pow_check_time_flag--;
}
/*******定时器2中断函数*******/
@far @interrupt void time1_interrupt(void)
{
	TIM2_SR1&=~0x01;//写0才是清除
  red_change();
  if( (hush_flag==1)||(get_msg_alarm==alarm_code_test)||(get_msg_alarm==master_test) ) buz_change();//buz=!buz;//非静音模式
  if(hush_flag==0)
  { 
	  silence_time++;
		if(if_alarm==0) //判断是否从设备
		{
	    if(silence_time==4615){ hush_flag=1; hush=all_ring;silence_time=0;}
		}
		if(if_alarm==1) //判断是否主设备
		{
			if(silence_time==6315){ hush_flag=1; hush=all_ring;silence_time=0;}
		}
	}
}
/*******GPIO1中断函数PC0******
@far @interrupt void GPIO1_interrupt(void)
{
	if(if_alarm==0)
	{
		vSpi3Write(((unsigned int)CMT23_INT_CLR1<<8)+TX_DONE_CLR);	//Clear TX_DONE flag 
		vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TX);		//bGoTx();
	}
	
	//PC_CR2&=~0x01;
	//loop_Rx();
	//bGoSleep();
	EXTI_SR1|=0x01;//clear PORTX0 IT flag
  RX_GET_RSSI=1;
}*/
/*******GPIO1中断函数PC0*******/
@far @interrupt void GPIO1_interrupt(void)
{
	if(RF_work_state==TX_state)
	{
		vSpi3Write(((unsigned int)CMT23_INT_CLR1<<8)+TX_DONE_CLR);	//Clear TX_DONE flag 
		vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TX);		//bGoTx();
		TX_num_temp++;
		if(TX_num_temp>TX_num)
		{
			setup_Rx();//切换，以后删减里面
			bGoSleep();    //进入睡眠
			RF_work_state=Sleep_state;
		}
	}
	else if(RF_work_state==RX_state)
	{
		RF_work_state=RX_pream_pass;
	}
	
	//PC_CR2&=~0x01;

	EXTI_SR1|=0x01;//clear PORTX0 IT flag
}