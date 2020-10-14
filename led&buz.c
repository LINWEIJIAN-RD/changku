#include"my_define.h"

/*函数名：led_state(char led, char state)
*   作用：用于设置灯状态
*   参数：led ：brue/red  state：ON/OFF
*   red PC4   brue  PB0
*/
void led_state(char led, char state)
{
	if(led==red)
	{
		if(state==ON)
		{
			PC_ODR |= 0x01<<led;//P1&=~(1<<led);
		}
		if(state==OFF)
		{
			PC_ODR &= ~(0x01<<led);//P1|=(1<<led);
		}
	}
	if(led==brue)
	{
		if(state==ON)
		{
			PB_ODR |= 0x01<<led;//P1&=~(1<<led);
		}
		if(state==OFF)
		{
			PB_ODR &= ~(0x01<<led);//P1|=(1<<led);
		}
	}
}
/*函数名：ledflash1(char led, int num, int time)
*   作用：用于配置灯闪烁状态
*   参数：led ：brue/red  num：闪烁次数  time_ON：亮时长  time_OFF；灭时长
*/
void ledflash(char led, unsigned int num, unsigned int time_ON, unsigned int time_OFF)//5=44.730ms
{
  for(;num>0;num--)
  {
    led_state(led,ON);
    delay(time_ON);
    led_state(led,OFF);
    delay(time_OFF);
  }
}


void red_change(void)
{
  if((PC_ODR & 0x10)==0x10)
  {
	  PC_ODR &= ~0x10;//red = 0;
  }
  else
  {
    PC_ODR |= 0x10;//red = 1;
  }
}



/*函数名：buz_state(char state)
*   作用：用于设置蜂鸣器状态
*   参数：  state：ON/OFF
*   buzzer   PB1
*/
void buz_state(char state)
{
  if(state==ON)
  {
    PB_ODR |= 0x02;//buz = 1;
  }
  if(state==OFF)
  {
    PB_ODR &= ~0x02;//buz = 0;
  }
}

void buz_change(void)
{
  if((PB_ODR & 0x02)==0x02)
  {
	  PB_ODR &= ~0x02;//buz = 0;
  }
  else
  {
    PB_ODR |= 0x02;//buz = 1;
  }
}