#include"my_define.h"
extern float IR_val;         //×ª»»Öµ 
extern float  cal_val_temp;
extern float  pow_val_temp;
void fault_test(void)
{	
  AD_VDD_val();
	power_up_amplify
	power_up_emitter
	AD_IR_val();
	power_down_amplify
	power_down_emitter
  
	while(1)
	{
		if(IR_val<0.372)  
    {
	    ledflash(red, 2, 70, 70);
			pow_val_temp=AD_VDD_val();
			power_up_amplify
			power_up_emitter
			cal_val_temp=AD_IR_val();
			power_down_amplify
			power_down_emitter
			IR_val=cal_val_temp-(pow_val_temp-3)*0.225;
    }
    if(IR_val>0.477)    
    {
			ledflash(red, 3, 70, 70);
			pow_val_temp=AD_VDD_val();
			power_up_amplify
			power_up_emitter
			cal_val_temp=AD_IR_val();
			power_down_amplify
			power_down_emitter
			IR_val=cal_val_temp-(pow_val_temp-3)*0.225;
    }
		if((IR_val>=0.372)&&(IR_val<=0.477)) break;
	}
}