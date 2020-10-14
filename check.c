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
	ADC1_CR1 |=0X04;       //�ģ�����12�ֱ��� ����ת�� 00000100
	ADC1_CR2 |=0X80;       //��2������ʱ�Ӳ���Ƶ 0x80
}
/*��������AD_VDD_val(void)
*   ���ã�����ת����Դ��ѹֵ
* ����ֵ��ת���ĵ�Դ��ѹֵ
*/
float AD_VDD_val(void)
{ 
  delay_ms(1); //���Է��ֱ���ӣ���Ȼ��ѹ��׼��ԭ�������ʱ�Ӳ���
  PWR_CSR2&=~0X02;//0.3UA
  //ADC_Init();	
	ADC1_TRIGR1=0X10;      //ʹ���ڲ��Ƚϵ�ѹ
	ADC1_SQR1 =0X10;       //ѡ��ͨ��Vref   
	ADC1_CR1 |=0X01;       //�ϵ�ʹ��ADת��
	delay_us(3);
	ADC1_CR1 |=0X02;       //��ʼADת��	
	//temp1=0;
	pow_val=0;
	delay_us(2);      //��ʱ�ȴ�ת����ϣ�����ȡֵ  8
	while((ADC1_SR&0x01)==0x00);
	ADC1_SR&=0xFE;
	ADC1_CR1 &=~0X01;      //��ADC
	ADC1_TRIGR1=0X00;      //�ر��ڲ��Ƚϵ�ѹ����Ȼ�ĵ�
	ADC1_SQR1 =0X00;       //��ͨ��Vref  

  PWR_CSR2=0X02;//0.3UA
	
	temp1=ADC1_DRH;
	temp1=temp1<<8;
	temp1=temp1|ADC1_DRL;

	pow_val=4096*1.224/temp1;     //Vdd��ѹֵ
	return pow_val;
}

/*��������AD_IR_val(void)
*   ���ã�����ת��������չܵĵ�ѹֵ
* ����ֵ��ת���Ľ��չܵ�ѹֵ
*   ˵������Ҫ�õ�AD_VDD_val(void)�ĵ�ѹֵ
*/

float AD_IR_val(void)
{ 
 // CLK_PCKENR2|=0X01;	     //����ADC1ʱ��
	//ADC_Init();
	ADC1_SQR3 =0X08;       //ѡ��ͨ��11 Ϊ̽ͷͨ�� 
	ADC1_CR1 |=0X01;       //�ϵ�ʹ��ADת�� 10
	ADC1_CR1 |=0X03;       //��ʼADת��			
	delay_us(650);      //��ʱ�ȴ�ת����ϣ�����ȡֵ  65
	
	ADC1_SQR3 =0X00;       //��ͨ��11 Ϊ̽ͷͨ�� 
	ADC1_CR1 &=~0X01;     //��ADC
//	CLK_PCKENR2&=~0X01;	     //��ADC1ʱ��
	
	//temp=0;
	IR_val=0;

	temp=ADC1_DRH;
	temp=temp<<8;
	temp=temp|ADC1_DRL;
	
	IR_val=temp*1.224/temp1;             //
	return IR_val;
}

/*��������calibrat(void)
*   ���ã��������ɱ궨ֵ
* ����ֵ����
*/
void calibrat(void)
{
	PC_DDR &=~0X01;    //PC0 ����
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
		  p=p+1;//�᲻�������⣬���ڳ��ȣ�����������������������������������������������
		  *p = pow_val_temp;         
		  while((FLASH_IAPSR & 0X04)==0);
		  FLASH_IAPSR &=~0X08;
			p=p-1;
    }
  }
	cal_val_temp=*p;
	p=p+1;
	pow_val_temp=*p;
	cal_val=cal_val_temp-(pow_val_temp-3)*0.097;//LM358=0.097 ������6002   //ת��Ϊ3V��ض�Ӧ��ֵ //0.225=MCP6242   LM358=0.097
	if(cal_val_temp==0)//û�б궨
	{
		while(1)
		{
			ledflash(red, 1, 100, 100);
			ledflash(brue, 1, 100, 100);
		}
	}
	if((cal_val<0.140) || (cal_val>0.670))//v3.0 190320����
	//if((cal_val<0.2) || (cal_val>0.5))//��������	
	//if((cal_val<0.372) || (cal_val>0.477))//MCP6242    //if((cal_val<0.203) || (cal_val>0.377))  //(LM358 0.29  ��30% 0.203  0.377)��ͬ��ѹ�±궨ֵ��һ�£���ת��Ϊ3Vʱ��ֵ (MCP6242  0.465  ��20%  0.372  0.558)
	{
		while(1)
		{
			led_state(red, ON);
		}
	}
	//cal_val=0.8;//����������������������������������
	ledflash(brue,3,70,70);
	Test_Device();
}

/*��������check_one(void)
*   ���ã����ڼ��̽ͷ��ǰ��ѹֵ
* ����ֵ��̽ͷֵ�Ƿ�ﵽ����״̬ 1������ 0��������
*/
char check_one(void)//4.7R�ĵ���2020.3
{
 // AD_VDD_val();���������ʱ������ÿ�βɼ�
  power_up_amplify
  power_up_emitter
  AD_IR_val();
  power_down_amplify
  power_down_emitter
  cal_val=cal_val_temp-(pow_val_temp-3)*0.097; //0.097=LM358������6002  ת��Ϊ3V��ض�Ӧ��ֵ  0.225=MCP6242
	cal_val=cal_val-(3-pow_val)*0.111+0.08;   //����Ҧ��0.03���1.8%����  //0.03����6002������0.02���2.5���ң�0.03���3.0%��0.04���3.5���ң�   LM358=0.0134   cal_val=cal_val-(3-pow_val)*0.258+0.0834; //��ǰ��ѹ�µı���ֵ  0.258=MCP6242         
  //2019.12.13�����г����󱨣�ʹ���µ��Թ���6002�����Եó�358���ݱȽϽӽ������޸ġ�û�������ȣ�����
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
    AD_VDD_val();//�пղ���һ��׼ȷ��
    if(pow_val<2.6)
    {
      ledflash(red,1,20,20);
      buz_state(ON);
      delay(5);
      buz_state(OFF);
    }
    else 
    {
      ledflash(brue,1,1,0);//10ms����
    }
    pow_check_time_flag=10;
  }
}