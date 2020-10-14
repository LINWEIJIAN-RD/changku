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
/**********���Ѷ�ʱ������***********/
void sleep(void)
{
  CLK_PCKENR2|=0X04;	     //����RTCʱ��
	CLK_CRTCR=0x04;       //ѡ��LSI��ΪRTCʱ��Դ38KHZ
	RTC_WPR=0xca;       //ȥRTC�Ĵ���д����
	RTC_WPR=0x53;				//ȥRTC�Ĵ���д����
	RTC_CR2 &=0xfb;     //���WUTE����RTC��ʱ�� 
	while((RTC_ISR1 & 0x04)!=0x04); //ֱ��WUTWF��־λΪ1��������װ�ؼ���ֵ
	RTC_CR1=0X00;        //RTCʱ�ӷ�Ƶѡ��2  38KHZ/2=19KHZ
	RTC_CR2 |=0x40;      //��RTC�ж�
	RTC_WUTRH=0X36;       //װ�ؼ���ֵ��λ364b
	RTC_WUTRL=0X4B;       //װ�ؼ���ֵ��λ    6S
	RTC_CR2 |=0X04;       //�ٴ�ʹ��RTC��ʱ��
	RTC_WPR=0X66;       //д����key�ؿ�д����
}
void CLK_INIT(void)
{
	CLK_SWCR =0X02;        //�л�ʱ��
  CLK_SWR  =0X01;        //HSE 0X04 HSI 0X01 LSI 0X02  4MHz
	CLK_CKDIVR=0x00;       //1��Ƶ����ѡ
	//CLK_PCKENR1=0X00;      //�ر�����ʱ��
  CLK_PCKENR2|=0X01;	     //����ADC1ʱ��//CLK_PCKENR2=0X00;	     //Ĭ��״̬��1000 0000
}
char Test_Device(void)//�޸�Ƶ�ʣ���ֹ���š�
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
				if( True==RF_Receive() ) //�յ� 
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
							for(i=0;i<2;i++)//12s~140  2600��3250
							{
								loop_Tx();
							}
							GPO3IT();
							setup_Rx();
							if( True==RF_Receive() ) //�յ� 
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
	bIntSrcFlagClr();  //jia ���Է���stanby�����TX_DONE�жϣ����Լ�������жϱ�־
	vEnableWrFifo();	
	//vClearFIFO(); //��ȷ��
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
  
	setup_Rx();//��ʼ��ΪRX  ����һ�����󣬼�bGoRx(); while(1); ��ֻ���ϵ�ǰ�з��䣬���ܽ�����ա��Ժ���ԭ��,��rf1.h�й�
	//bGoRx();
	//while(1);
	
  while(1)
  {
/***************************key scan********����241.88MS*******************/
    key();
/************************power check*********����241.8ms****************/
    pow_check();
/*********************Receive alarm msg*********����241.740ms*************/
    for(i=0;i<1;i++)   //��
    {
      if( True==RF_Receive() ) //�յ� û��ȷ���յ����ݰ�
      {
        //RAM_read();����
        //if( (getstr[0]==0x11) && (getstr[1]==0x22) )
				/*
				if(RSSI_val<35)//���浽3¥���м������
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
					
				  //ledflash(red,3,5,5); //5=44.730ms   //����    **********************************test
          get_msg_alarm=getstr[2];//����
          hush=getstr[3];//����
          break;
        }
      }
    }
/*****************************check************����785.3us***************/ 
    if(True==check_one())
    {
      for(if_alarm=9;if_alarm>1;)	      //8��
      {
        ledflash(red,1,10,10);
        delay(30);
        if_alarm--;
        check_one();
        if(IR_val<cal_val) break;
      }
    }
/***************************����****************����5.5us***************/
    if(if_alarm==1)//����
    {
      unsigned char k=20,tem=1;
			hush_change_flag=all_ring;
      hush=all_ring;
      hush_flag=1;//test
			silence_time=0;//����ʱ������
      T1_Middle_for_ledbuz_EN();  //�������
/************************���ͱ���״̬**************************/
      str[2]=alarm_code;
      str[3]=hush;
	    TX_fuction(30);//9������
/**************************************************************/
      while(IR_val>cal_val)
      {
/************************���ͱ���״̬**************************/
        if((k==0)&&(RF_work_state==Sleep_state))
        {
          str[2]=alarm_code+tem;
          //str[3]=hush;//�����ˣ������������״̬
					TX_fuction(5);//1.5������
          tem++;
          if(tem==10)tem=0;
          k=20;//60��20
					while(RF_work_state==TX_state);//��ֹ���RX
        }
/**********************��������״̬****************************/
				if(RF_work_state==Sleep_state)
				{					
					for(i=0;i<3;i++)   //��
					{
						if( True==RF_Receive() ) //�յ�
						{
							if( (getstr[0]==str[0]) && (getstr[1]==str[1]) && (getstr[2]!=alarm_code_test) )
							{
								if(getstr[3]!=all_ring) hush=getstr[3]; //
								break;
							}
						}
					}
				}
				if(hush==all_silence)      //��������ģʽ
        {
          buz_state(OFF);
          hush_flag=0;
        }
/************************��������״̬**************************/ 
        while( hush!=hush_change_flag )
        {
          str[3]=hush;
			    TX_fuction(20);//6������
          hush_change_flag=hush;
        } 
/***********************���һ��*******************************/
        if(k==10)//30��10
        {
          check_one();
        }
/*************�����⵽������������ͱ�������ź�*************/
        if(IR_val<=cal_val)
        {
          buz_state(OFF);  //�رշ�����
          T1_for_ledbuz_DIS();//�ض�ʱ���жϣ��Ӷ��ر���
					red_OFF;  //�رպ��
          str[2]=dis_alarm_code;
					TX_fuction(20);//6������
					while(RF_work_state==TX_state);
					break;
        }
/**************************************************************/
        k--;
      }
      if_alarm=0;
    }
/***************************************************����յ������ź�********************************************/
    if((get_msg_alarm & 0xF0)==alarm_code)//����
    {
		  unsigned int n=0;
      unsigned char get_msg_alarm_flag=alarm_code;
			hush_change_flag=hush;
      hush_flag=1;//��Ҫ����Ȼ�ᱣ���ϴα����ľ���
			silence_time=0;//����ʱ������
			/************************����״̬**************************/
			if( (hush==all_silence)||(hush==slave_silence) )      //���豸����ģʽ
			{
				buz_state(OFF);
				hush_flag=0;
			}
      T1_Slow_for_ledbuz_EN();  //�����ź����
/************************���ͱ���״̬**************************/
      if(RSSI_val<RSSI_val_set)//���浽3¥���м������
			{
				repeater=1;
				str[2]=get_msg_alarm;
				str[3]=hush;
				TX_fuction(20);//6������
			}
			else delay_ms(6000);//yu��ͬ����test
/**************************************************************/
      while(get_msg_alarm!=dis_alarm_code)//while(get_msg_alarm==alarm_code)//1)//
      {
/************************���ͱ���������״̬************************/
        //if(((RSSI_val_tam>0)&&(RSSI_val_tam<35))&&(RF_work_state==Sleep_state))
				if((repeater==1)&&(RF_work_state==Sleep_state))
        { ledflash(brue,6,20,5);//test����RSSI������������������������������������������������������������������������
          str[2]=get_msg_alarm;
          str[3]=hush;//����״̬ 
					TX_fuction(5);//1.5������
					while(RF_work_state==TX_state);//��ֹ���RX
        }
/*********************���ձ����Ƿ���������״̬*************************/
        if(RF_work_state==Sleep_state)
				{
				  repeater=0;
					for(i=0;i<3;i++)   //��
					{ 
						if( True==RF_Receive() ) //�յ�
						{
							if( (getstr[0]==str[0]) && (getstr[1]==str[1]) && (getstr[2]!=alarm_code_test) )
							{
								get_msg_alarm=getstr[2];  //���±���״̬
								if(getstr[3]!=all_ring) hush=getstr[3]; //��Ȼ����ľ����źű����յ�ˢ����
								GET_repeater();
								break;
							}
						}
					}
					/*********************�ж��Ƿ�ʱ�˳�����״̬*************************/
					if(get_msg_alarm_flag==get_msg_alarm)//���ź�
					{
						n++;
					}
					else /*if(get_msg_alarm_flag!=get_msg_alarm) */   //���źţ����������ź�  60��160
					{
						get_msg_alarm_flag=get_msg_alarm;
						n=0;
					}
				  if(n>2000) {get_msg_alarm=dis_alarm_code; }     //��ʱδ���յ�����Ϣ�����˳����� 10��5
        }
/************************����״̬**************************/
        if( (hush==all_silence)||(hush==slave_silence) )      //���豸����ģʽ
        {
          buz_state(OFF);
          hush_flag=0;
        }
/************************��������״̬***************************/    
        //if(((hush!=hush_change_flag)&&(Button_down_flag==1))||((hush!=hush_change_flag)&&(RSSI_val<35)))
				if(((hush!=hush_change_flag)&&(Button_down_flag==1))||((hush!=hush_change_flag)&&(repeater==1)))//����Ҫ�ȴ�֮ǰ�ķ��ͽ�����Ϊ�˸��쾲��
				{
				  str[2]=get_msg_alarm;
          str[3]=hush;
					TX_fuction(20);//6������
          hush_change_flag=hush;
					Button_down_flag=0;
        }
/************������յ�������������ͱ�������ź�*************/     
        if(get_msg_alarm==dis_alarm_code)      //�������
        {
          buz_state(OFF); //�رշ�����
					T1_for_ledbuz_DIS();//�ض�ʱ���жϣ��Ӷ��ر���
					red_OFF;  //�رպ��
          if((repeater==1)&&(RF_work_state==Sleep_state))
					{
						str[2]=get_msg_alarm;
						TX_fuction(20);//6������
						while(RF_work_state==TX_state);
					}
          break;
        }
      }
      get_msg_alarm=0;
    }
/************************���յ�����*****************************/
		if((get_msg_alarm==alarm_code_test)&&(Test_mode_flag==0))
		//if(0)//
    {
			T1_Middle_for_ledbuz_EN();//ʵ��95.3ms
			//***********************************************/
			if(RSSI_val<RSSI_val_set)//
			{
				TX_fuction(30);//9������
				while(RF_work_state==TX_state);
		  }
			else delay_ms(9000);
			buz_state(OFF);  //�رշ�����
			T1_for_ledbuz_DIS();//�ض�ʱ���жϣ��Ӷ��ر���
			red_OFF;  //�رպ��
			get_msg_alarm=0;
			Test_mode_flag=3;
    }	
/************************����ģʽ*****************************/ 
    if((get_msg_alarm==master_test)&&(Test_mode_flag==0))//Test_mode_flag���Թ���12S��ֹ����                
    //if((1)&&(Test_mode_flag==0))
		{
			T1_Middle_for_ledbuz_EN();
			RAM_read();
			str[2]=alarm_code_test;
			TX_fuction(30);//9������
			while(RF_work_state==TX_state);
			buz_state(OFF);  //�رշ�����
			T1_for_ledbuz_DIS();//�ض�ʱ���жϣ��Ӷ��ر���
			red_OFF;  //�رպ��
			get_msg_alarm=0;
			Test_mode_flag=3;
    }
		get_msg_alarm=0;//��ֹ���յ��ϴ�����ǰ�Ĳ����źţ�����¼����һ�λ���
	  keydelay=0;//������������İ���ֵ 
/************************sleep����*****************************/
    CLK_PCKENR1&=~0X01;//���ӹ��ĸߣ�������������
		IOconfig();
    sleep();
		_asm("halt"); 
	}
}
/********************�����жϳ���PC1*************************/
@far @interrupt void button_interrupt(void)
{
  IntDisable;
  EXTI_SR1|=0x02;   //����жϱ�־
	
	RTC_CR2 &=0xfb;     //��RTC��ʱ������ 
  RTC_CR2 &=0xbf;     //��RTC�ж�
	
  if((PC_IDR & 0X02)==0X02)
  { 
    delay_ms(3);
    if((PC_IDR & 0X02)==0X02) //�ĳɱ�������ܽ�ȥ������������
    { 
		  Button_down_flag=1;
		  //keydelay=0;//���ط�test
			if(if_alarm==0) //�ж��Ƿ���豸
			{
				buz_state(OFF);
				hush_flag=0;
			  //i=0;//�����ȷ�������㹻��ʱ��
				str[3]=slave_silence;
				hush=slave_silence;
			}
      if(if_alarm==1) //�ж��Ƿ����豸
			{
				buz_state(OFF);
				hush_flag=0;
				//i=0;//�����ȷ�������㹻��ʱ��
				hush=all_silence;
			}
      while((PC_IDR & 0X02)==0X02)
      {
        delay_ms(10);
        keydelay++;
        
        if((keydelay>250)&&(keydelay%100)==0)//��100��
        {
          ledflash(brue,1,20,0);
        }
      }
    }
  }
  IntEnable;
}
/*******���Ѷ�ʱ���жϺ���*******/
@far @interrupt void wakeup_interrupt(void)
{
	RTC_WPR=0xca;       //ȥRTC�Ĵ���д����
	RTC_WPR=0x53;				//ȥRTC�Ĵ���д���� 
	RTC_CR2 &=0xfb;     //��RTC��ʱ������ 
  RTC_CR2 &=0xbf;     //��RTC�ж�
	RTC_WPR=0X66;       //д����key�ؿ�д����
  RTC_ISR2 &=~0x04;   //��������ʱ�־λ
	
	if(Test_mode_flag>0)Test_mode_flag--;
  pow_check_time_flag--;
}
/*******��ʱ��2�жϺ���*******/
@far @interrupt void time1_interrupt(void)
{
	TIM2_SR1&=~0x01;//д0�������
  red_change();
  if( (hush_flag==1)||(get_msg_alarm==alarm_code_test)||(get_msg_alarm==master_test) ) buz_change();//buz=!buz;//�Ǿ���ģʽ
  if(hush_flag==0)
  { 
	  silence_time++;
		if(if_alarm==0) //�ж��Ƿ���豸
		{
	    if(silence_time==4615){ hush_flag=1; hush=all_ring;silence_time=0;}
		}
		if(if_alarm==1) //�ж��Ƿ����豸
		{
			if(silence_time==6315){ hush_flag=1; hush=all_ring;silence_time=0;}
		}
	}
}
/*******GPIO1�жϺ���PC0******
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
/*******GPIO1�жϺ���PC0*******/
@far @interrupt void GPIO1_interrupt(void)
{
	if(RF_work_state==TX_state)
	{
		vSpi3Write(((unsigned int)CMT23_INT_CLR1<<8)+TX_DONE_CLR);	//Clear TX_DONE flag 
		vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TX);		//bGoTx();
		TX_num_temp++;
		if(TX_num_temp>TX_num)
		{
			setup_Rx();//�л����Ժ�ɾ������
			bGoSleep();    //����˯��
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