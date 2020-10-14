
#include"my_define.h"

extern char has_code,hush_flag;
char randum_val0,randum_val1;
extern unsigned char str[4];
extern unsigned char getstr[4];
extern unsigned char flag_key;
extern unsigned int keydelay;
extern unsigned char RF_work_state;
char RSSI_val=0;
unsigned char repeater=0;

void RAM_write(void);
void RAM_read(void);
void randum(void);
void ledflash(char led, unsigned int num, unsigned int time_ON, unsigned int time_OFF);

void randum(void)
{
  //AD_VDD_val();
	//randum_val0=1+(int)(pow_val*0x5F5E100)%1000000;
  //pow_val=pow_val*0x5F5E100;
  randum_val1= RTC_SSR;//第一次才会变，需改善
}

char RF_Receive(void)
{
	char PKT_OK=0;
	RSSI_val=0;
	RF_work_state=RX_state;
	//setup_Rx();//应该去掉，改到其他地方
	//ledflash(brue,3,1,1); //test测试RSSI！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
	bGoRx();
	delay_us(800);//800=697.6 
	//delay_us(700);//  化简发射后测1.0863ms   //delay_us(1270);   //实测应该是1180  //前包末8pream到后包首8pream        
	if(RF_work_state==RX_pream_pass)
	{//ledflash(brue,2,100,10);//test!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		delay_us(1200);// 化简发射后测1.0996ms  实测1100大概才1094   //delay_us(1130);//实测应该是1130  //首8个pream到数据结束       
	  PKT_OK=loop_Rx1();
  }
	bGoSleep();
	RF_work_state=Sleep_state;
	return PKT_OK;
}
/************************link***************************/
char link(void)
{
  unsigned int n,i,j;
  if(flag_key==2)
	{
		RAM_read();
		if((has_code==True))  //有码
		{
			ledflash(red,3,20,20);
			return LINKDONE;  //有码
		}
		else
		{
			for(j=0;j<(2600);j++)//for(j=0;j<(randum_val0);j++)   //收  for(j=0;j<(randum_val0/20);j++) 
			{
			  ledflash(red,1,20,20);
				if( True==RF_Receive() ) //收到
				{
					if((getstr[2]==(getstr[0]+0x23))&&((getstr[0]!=0)&&(getstr[1]!=0)))
					{
						str[0]=getstr[0];str[1]=getstr[1];  //存储接收的码 
						has_code=True;           //标记本设备有码
						RAM_write();             //码存在RAM
						ledflash(brue,3,100,100);    //配对成功 闪灯
						return SUCCESS;//n=65534;break;  //退出函数
					}
				}
				if(keydelay>1){keydelay=0; break;}
			}
			return FAIL;  //超时未配对，退出
		}
	}
	if(flag_key==3)
  {
	  hush_flag=0;
		T1_Fast_for_ledbuz_EN();
		RAM_read();
		if((has_code!=True))  //无码
		{
			randum();  //自己生成码
			has_code=True;           //标记本设备有码
			str[0]=randum_val1;str[1]=randum_val1&0xDD; 
		  RAM_write();             //码存在RAM
		}
		str[2]=str[0]+0x23;
		TX_fuction(190);//60秒左右
		while(RF_work_state==TX_state)
		{
		  if(keydelay>1)
			{
			  keydelay=0;
				break;
			}
		}
	  T1_for_ledbuz_DIS();//关定时器中断     jia
		red_OFF;  //关闭红灯     jia
	}
}

void GET_repeater(void)
{
	if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
	{ 
		if( True==RF_Receive() ) 
		{
			if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
			{
				if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
				{
					if( True==RF_Receive() ) 
					{
						if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
						{
							if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
							{
								repeater=1;
							}
						}
					}
				}
			}
		}
	}
}