#include"my_define.h"

extern float  pow_val;
extern float  IR_val;
extern float  cal_val;
extern float  cal_val_temp;
extern float  pow_val_temp;
extern char pow_check_time_flag;

//unsigned char AH,AL,AdH,AdL;
unsigned int temp1;
unsigned int temp;

extern float *p;

void ADC_Init(void)
{
	ADC1_CR1 |=0X04;       //改！！！12分辨率 连续转换 00000100
	ADC1_CR2 |=0X80;       //该2！！！时钟不分频 0x80
}
/*函数名：AD_VDD_val(void)
*   作用：用于转换电源电压值
* 返回值：转换的电源电压值
*/
float AD_VDD_val(void)
{ 
  delay_ms(1); //测试发现必须加，不然电压不准，原因可能是时钟不稳
  PWR_CSR2&=~0X02;//0.3UA
  //ADC_Init();	
	ADC1_TRIGR1=0X10;      //使能内部比较电压
	ADC1_SQR1 =0X10;       //选择通道Vref   
	ADC1_CR1 |=0X01;       //上电使能AD转换
	delay_us(3);
	ADC1_CR1 |=0X02;       //开始AD转换	
	//temp1=0;
	pow_val=0;
	delay_us(2);      //延时等待转换完毕，后再取值  8
	while((ADC1_SR&0x01)==0x00);
	ADC1_SR&=0xFE;
	ADC1_CR1 &=~0X01;      //关ADC
	ADC1_TRIGR1=0X00;      //关闭内部比较电压，不然耗电
	ADC1_SQR1 =0X00;       //关通道Vref  

  PWR_CSR2=0X02;//0.3UA
	
	temp1=ADC1_DRH;
	temp1=temp1<<8;
	temp1=temp1|ADC1_DRL;

	pow_val=4096*1.224/temp1;     //Vdd电压值
	return pow_val;
}

/*函数名：AD_IR_val(void)
*   作用：用于转换红外接收管的电压值
* 返回值：转换的接收管电压值
*   说明：需要用到AD_VDD_val(void)的电压值
*/

float AD_IR_val(void)
{ 
 // CLK_PCKENR2|=0X01;	     //开启ADC1时钟
	//ADC_Init();
	ADC1_SQR3 =0X08;       //选择通道11 为探头通道 
	ADC1_CR1 |=0X01;       //上电使能AD转换 10
	ADC1_CR1 |=0X03;       //开始AD转换			
	delay_us(650);      //延时等待转换完毕，后再取值  65
	
	ADC1_SQR3 =0X00;       //关通道11 为探头通道 
	ADC1_CR1 &=~0X01;     //关ADC
//	CLK_PCKENR2&=~0X01;	     //关ADC1时钟
	
	//temp=0;
	IR_val=0;

	temp=ADC1_DRH;
	temp=temp<<8;
	temp=temp|ADC1_DRL;
	
	IR_val=temp*1.224/temp1;             //
	return IR_val;
}

/*函数名：calibrat(void)
*   作用：用于生成标定值
* 返回值：无
*/
void calibrat(void)
{
	PC_DDR &=~0X01;    //PC0 输入
	PC_CR1 |=0X01;
	p=(float *)0x1000;
  if((PC_IDR & 0X02)==0X02 )
  { 
    delay(3);
    if((PC_IDR & 0X02)==0X02 )
    { 
		  delay(300);
      pow_val_temp=AD_VDD_val();
      power_up_amplify
      power_up_emitter
      cal_val_temp=AD_IR_val();
      power_down_amplify
      power_down_emitter
			
			FLASH_DUKR =0XAE;
		  FLASH_DUKR =0X56;
		  while((FLASH_IAPSR & 0X08)==0);
		  *p =cal_val_temp;
		  p=p+1;//会不会有问题，关于长度？？？？？？？？？？？？？？？？？？？？？？？？
		  *p = pow_val_temp;         
		  while((FLASH_IAPSR & 0X04)==0);
		  FLASH_IAPSR &=~0X08;
			p=p-1;
    }
  }
	cal_val_temp=*p;
	p=p+1;
	pow_val_temp=*p;
	cal_val=cal_val_temp-(pow_val_temp-3)*0.097;//LM358=0.097 试用于6002   //转换为3V电池对应的值 //0.225=MCP6242   LM358=0.097
	if(cal_val_temp==0)//没有标定
	{
		while(1)
		{
			ledflash(red, 1, 100, 100);
			ledflash(brue, 1, 100, 100);
		}
	}
	if((cal_val<0.140) || (cal_val>0.670))//v3.0 190320批次
	//if((cal_val<0.2) || (cal_val>0.5))//调试暂用	
	//if((cal_val<0.372) || (cal_val>0.477))//MCP6242    //if((cal_val<0.203) || (cal_val>0.377))  //(LM358 0.29  ±30% 0.203  0.377)因不同电压下标定值不一致，需转换为3V时的值 (MCP6242  0.465  ±20%  0.372  0.558)
	{
		while(1)
		{
			led_state(red, ON);
		}
	}
	//cal_val=0.8;//！！！！！！！！！！！！！！！测试
	ledflash(brue,3,70,70);
	Test_Device();
}

/*函数名：check_one(void)
*   作用：用于检测探头当前电压值
* 返回值：探头值是否达到报警状态 1：报警 0：不报警
*/
char check_one(void)//4.7R的电阻2020.3
{
 // AD_VDD_val();里面加了延时，不能每次采集
  power_up_amplify
  power_up_emitter
  AD_IR_val();
  power_down_amplify
  power_down_emitter
  cal_val=cal_val_temp-(pow_val_temp-3)*0.097; //0.097=LM358试用于6002  转换为3V电池对应的值  0.225=MCP6242
	cal_val=cal_val-(3-pow_val)*0.111+0.08;   //后面姚工0.03测出1.8%左右  //0.03用于6002（烟箱0.02测出2.5左右，0.03测出3.0%，0.04测出3.5左右）   LM358=0.0134   cal_val=cal_val-(3-pow_val)*0.258+0.0834; //当前电压下的报警值  0.258=MCP6242         
  //2019.12.13生产中出现误报，使用新的迷宫，6002，测试得出358数据比较接近，故修改。没测灵敏度！！！
  if(IR_val>cal_val)
  {
    return 1;
  }
  else return 0;
}


void pow_check(void)
{
  if(pow_check_time_flag==0)
  {
    AD_VDD_val();//有空测试一下准确否
    if(pow_val<2.6)
    {
      ledflash(red,1,20,20);
      buz_state(ON);
      delay(5);
      buz_state(OFF);
    }
    else 
    {
      ledflash(brue,1,1,0);//10ms左右
    }
    pow_check_time_flag=10;
  }
}