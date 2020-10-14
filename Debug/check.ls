   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3347                     ; 16 void ADC_Init(void)
3347                     ; 17 {
3348                     .text:	section	.text,new
3349  0000               f_ADC_Init:
3353                     ; 18 	ADC1_CR1 |=0X04;       //改！！！12分辨率 连续转换 00000100
3355  0000 72145340      	bset	_ADC1_CR1,#2
3356                     ; 19 	ADC1_CR2 |=0X80;       //该2！！！时钟不分频 0x80
3358  0004 721e5341      	bset	_ADC1_CR2,#7
3359                     ; 20 }
3362  0008 87            	retf
3395                     ; 25 float AD_VDD_val(void)
3395                     ; 26 { 
3396                     .text:	section	.text,new
3397  0000               f_AD_VDD_val:
3399  0000 5204          	subw	sp,#4
3400       00000004      OFST:	set	4
3403                     ; 27   delay_ms(1); //测试发现必须加，不然电压不准，原因可能是时钟不稳
3405  0002 ae0001        	ldw	x,#1
3406  0005 8d000000      	callf	f_delay_ms
3408                     ; 28   PWR_CSR2&=~0X02;//0.3UA
3410  0009 721350b3      	bres	_PWR_CSR2,#1
3411                     ; 30 	ADC1_TRIGR1=0X10;      //使能内部比较电压
3413  000d 3510534e      	mov	_ADC1_TRIGR1,#16
3414                     ; 31 	ADC1_SQR1 =0X10;       //选择通道Vref   
3416  0011 3510534a      	mov	_ADC1_SQR1,#16
3417                     ; 32 	ADC1_CR1 |=0X01;       //上电使能AD转换
3419  0015 72105340      	bset	_ADC1_CR1,#0
3420                     ; 33 	delay_us(3);
3422  0019 ae0003        	ldw	x,#3
3423  001c 8d000000      	callf	f_delay_us
3425                     ; 34 	ADC1_CR1 |=0X02;       //开始AD转换	
3427  0020 72125340      	bset	_ADC1_CR1,#1
3428                     ; 36 	pow_val=0;
3430  0024 ae0000        	ldw	x,#0
3431  0027 cf0002        	ldw	_pow_val+2,x
3432  002a ae0000        	ldw	x,#0
3433  002d cf0000        	ldw	_pow_val,x
3434                     ; 37 	delay_us(2);      //延时等待转换完毕，后再取值  8
3436  0030 ae0002        	ldw	x,#2
3437  0033 8d000000      	callf	f_delay_us
3440  0037               L3132:
3441                     ; 38 	while((ADC1_SR&0x01)==0x00);
3443  0037 c65343        	ld	a,_ADC1_SR
3444  003a a501          	bcp	a,#1
3445  003c 27f9          	jreq	L3132
3446                     ; 39 	ADC1_SR&=0xFE;
3448  003e 72115343      	bres	_ADC1_SR,#0
3449                     ; 40 	ADC1_CR1 &=~0X01;      //关ADC
3451  0042 72115340      	bres	_ADC1_CR1,#0
3452                     ; 41 	ADC1_TRIGR1=0X00;      //关闭内部比较电压，不然耗电
3454  0046 725f534e      	clr	_ADC1_TRIGR1
3455                     ; 42 	ADC1_SQR1 =0X00;       //关通道Vref  
3457  004a 725f534a      	clr	_ADC1_SQR1
3458                     ; 44   PWR_CSR2=0X02;//0.3UA
3460  004e 350250b3      	mov	_PWR_CSR2,#2
3461                     ; 46 	temp1=ADC1_DRH;
3463  0052 c65344        	ld	a,_ADC1_DRH
3464  0055 5f            	clrw	x
3465  0056 97            	ld	xl,a
3466  0057 cf0002        	ldw	_temp1,x
3467                     ; 47 	temp1=temp1<<8;
3469  005a c60003        	ld	a,_temp1+1
3470  005d c70002        	ld	_temp1,a
3471  0060 725f0003      	clr	_temp1+1
3472                     ; 48 	temp1=temp1|ADC1_DRL;
3474  0064 c65345        	ld	a,_ADC1_DRL
3475  0067 5f            	clrw	x
3476  0068 97            	ld	xl,a
3477  0069 01            	rrwa	x,a
3478  006a ca0003        	or	a,_temp1+1
3479  006d 01            	rrwa	x,a
3480  006e ca0002        	or	a,_temp1
3481  0071 01            	rrwa	x,a
3482  0072 cf0002        	ldw	_temp1,x
3483                     ; 50 	pow_val=4096*1.224/temp1;     //Vdd电压值
3485  0075 ce0002        	ldw	x,_temp1
3486  0078 8d000000      	callf	d_uitof
3488  007c 96            	ldw	x,sp
3489  007d 1c0001        	addw	x,#OFST-3
3490  0080 8d000000      	callf	d_rtol
3492  0084 ae001c        	ldw	x,#L3232
3493  0087 8d000000      	callf	d_ltor
3495  008b 96            	ldw	x,sp
3496  008c 1c0001        	addw	x,#OFST-3
3497  008f 8d000000      	callf	d_fdiv
3499  0093 ae0000        	ldw	x,#_pow_val
3500  0096 8d000000      	callf	d_rtol
3502                     ; 51 	return pow_val;
3504  009a ae0000        	ldw	x,#_pow_val
3505  009d 8d000000      	callf	d_ltor
3509  00a1 5b04          	addw	sp,#4
3510  00a3 87            	retf
3540                     ; 60 float AD_IR_val(void)
3540                     ; 61 { 
3541                     .text:	section	.text,new
3542  0000               f_AD_IR_val:
3544  0000 5204          	subw	sp,#4
3545       00000004      OFST:	set	4
3548                     ; 64 	ADC1_SQR3 =0X08;       //选择通道11 为探头通道 
3550  0002 3508534c      	mov	_ADC1_SQR3,#8
3551                     ; 65 	ADC1_CR1 |=0X01;       //上电使能AD转换 10
3553  0006 72105340      	bset	_ADC1_CR1,#0
3554                     ; 66 	ADC1_CR1 |=0X03;       //开始AD转换			
3556  000a c65340        	ld	a,_ADC1_CR1
3557  000d aa03          	or	a,#3
3558  000f c75340        	ld	_ADC1_CR1,a
3559                     ; 67 	delay_us(650);      //延时等待转换完毕，后再取值  65
3561  0012 ae028a        	ldw	x,#650
3562  0015 8d000000      	callf	f_delay_us
3564                     ; 69 	ADC1_SQR3 =0X00;       //关通道11 为探头通道 
3566  0019 725f534c      	clr	_ADC1_SQR3
3567                     ; 70 	ADC1_CR1 &=~0X01;     //关ADC
3569  001d 72115340      	bres	_ADC1_CR1,#0
3570                     ; 74 	IR_val=0;
3572  0021 ae0000        	ldw	x,#0
3573  0024 cf0002        	ldw	_IR_val+2,x
3574  0027 ae0000        	ldw	x,#0
3575  002a cf0000        	ldw	_IR_val,x
3576                     ; 76 	temp=ADC1_DRH;
3578  002d c65344        	ld	a,_ADC1_DRH
3579  0030 5f            	clrw	x
3580  0031 97            	ld	xl,a
3581  0032 cf0000        	ldw	_temp,x
3582                     ; 77 	temp=temp<<8;
3584  0035 c60001        	ld	a,_temp+1
3585  0038 c70000        	ld	_temp,a
3586  003b 725f0001      	clr	_temp+1
3587                     ; 78 	temp=temp|ADC1_DRL;
3589  003f c65345        	ld	a,_ADC1_DRL
3590  0042 5f            	clrw	x
3591  0043 97            	ld	xl,a
3592  0044 01            	rrwa	x,a
3593  0045 ca0001        	or	a,_temp+1
3594  0048 01            	rrwa	x,a
3595  0049 ca0000        	or	a,_temp
3596  004c 01            	rrwa	x,a
3597  004d cf0000        	ldw	_temp,x
3598                     ; 80 	IR_val=temp*1.224/temp1;             //
3600  0050 ce0002        	ldw	x,_temp1
3601  0053 8d000000      	callf	d_uitof
3603  0057 96            	ldw	x,sp
3604  0058 1c0001        	addw	x,#OFST-3
3605  005b 8d000000      	callf	d_rtol
3607  005f ce0000        	ldw	x,_temp
3608  0062 8d000000      	callf	d_uitof
3610  0066 ae0020        	ldw	x,#L3432
3611  0069 8d000000      	callf	d_fmul
3613  006d 96            	ldw	x,sp
3614  006e 1c0001        	addw	x,#OFST-3
3615  0071 8d000000      	callf	d_fdiv
3617  0075 ae0000        	ldw	x,#_IR_val
3618  0078 8d000000      	callf	d_rtol
3620                     ; 81 	return IR_val;
3622  007c ae0000        	ldw	x,#_IR_val
3623  007f 8d000000      	callf	d_ltor
3627  0083 5b04          	addw	sp,#4
3628  0085 87            	retf
3668                     ; 88 void calibrat(void)
3668                     ; 89 {
3669                     .text:	section	.text,new
3670  0000               f_calibrat:
3672  0000 5204          	subw	sp,#4
3673       00000004      OFST:	set	4
3676                     ; 90 	PC_DDR &=~0X01;    //PC0 输入
3678  0002 7211500c      	bres	_PC_DDR,#0
3679                     ; 91 	PC_CR1 |=0X01;
3681  0006 7210500d      	bset	_PC_CR1,#0
3682                     ; 92 	p=(float *)0x1000;
3684  000a ae1000        	ldw	x,#4096
3685  000d cf0000        	ldw	_p,x
3686                     ; 93   if((PC_IDR & 0X02)==0X02 )
3688  0010 c6500b        	ld	a,_PC_IDR
3689  0013 a402          	and	a,#2
3690  0015 a102          	cp	a,#2
3691  0017 2704          	jreq	L41
3692  0019 acd600d6      	jpf	L7532
3693  001d               L41:
3694                     ; 95     delay(3);
3696  001d ae0003        	ldw	x,#3
3697  0020 8d000000      	callf	f_delay
3699                     ; 96     if((PC_IDR & 0X02)==0X02 )
3701  0024 c6500b        	ld	a,_PC_IDR
3702  0027 a402          	and	a,#2
3703  0029 a102          	cp	a,#2
3704  002b 2704          	jreq	L61
3705  002d acd600d6      	jpf	L7532
3706  0031               L61:
3707                     ; 98 		  delay(300);
3709  0031 ae012c        	ldw	x,#300
3710  0034 8d000000      	callf	f_delay
3712                     ; 99       pow_val_temp=AD_VDD_val();
3714  0038 8d000000      	callf	f_AD_VDD_val
3716  003c ae0000        	ldw	x,#_pow_val_temp
3717  003f 8d000000      	callf	d_rtol
3719                     ; 100       power_up_amplify
3721  0043 721c5007      	bset	_PB_DDR,#6
3724  0047 721c5008      	bset	_PB_CR1,#6
3727  004b 721c5005      	bset	_PB_ODR,#6
3728                     ; 101       power_up_emitter
3730  004f 721a5007      	bset	_PB_DDR,#5
3733  0053 721a5008      	bset	_PB_CR1,#5
3736  0057 721a5005      	bset	_PB_ODR,#5
3737                     ; 102       cal_val_temp=AD_IR_val();
3739  005b 8d000000      	callf	f_AD_IR_val
3741  005f ae0000        	ldw	x,#_cal_val_temp
3742  0062 8d000000      	callf	d_rtol
3744                     ; 103       power_down_amplify
3746  0066 721c5007      	bset	_PB_DDR,#6
3749  006a 721c5008      	bset	_PB_CR1,#6
3752  006e 721d5005      	bres	_PB_ODR,#6
3753                     ; 104       power_down_emitter
3755  0072 721a5007      	bset	_PB_DDR,#5
3758  0076 721a5008      	bset	_PB_CR1,#5
3761  007a 721b5005      	bres	_PB_ODR,#5
3762                     ; 106 			FLASH_DUKR =0XAE;
3764  007e 35ae5053      	mov	_FLASH_DUKR,#174
3765                     ; 107 		  FLASH_DUKR =0X56;
3767  0082 35565053      	mov	_FLASH_DUKR,#86
3769  0086               L7632:
3770                     ; 108 		  while((FLASH_IAPSR & 0X08)==0);
3772  0086 c65054        	ld	a,_FLASH_IAPSR
3773  0089 a508          	bcp	a,#8
3774  008b 27f9          	jreq	L7632
3775                     ; 109 		  *p =cal_val_temp;
3777  008d ce0000        	ldw	x,_p
3778  0090 c60003        	ld	a,_cal_val_temp+3
3779  0093 e703          	ld	(3,x),a
3780  0095 c60002        	ld	a,_cal_val_temp+2
3781  0098 e702          	ld	(2,x),a
3782  009a c60001        	ld	a,_cal_val_temp+1
3783  009d e701          	ld	(1,x),a
3784  009f c60000        	ld	a,_cal_val_temp
3785  00a2 f7            	ld	(x),a
3786                     ; 110 		  p=p+1;//会不会有问题，关于长度？？？？？？？？？？？？？？？？？？？？？？？？
3788  00a3 ce0000        	ldw	x,_p
3789  00a6 1c0004        	addw	x,#4
3790  00a9 cf0000        	ldw	_p,x
3791                     ; 111 		  *p = pow_val_temp;         
3793  00ac ce0000        	ldw	x,_p
3794  00af c60003        	ld	a,_pow_val_temp+3
3795  00b2 e703          	ld	(3,x),a
3796  00b4 c60002        	ld	a,_pow_val_temp+2
3797  00b7 e702          	ld	(2,x),a
3798  00b9 c60001        	ld	a,_pow_val_temp+1
3799  00bc e701          	ld	(1,x),a
3800  00be c60000        	ld	a,_pow_val_temp
3801  00c1 f7            	ld	(x),a
3803  00c2               L7732:
3804                     ; 112 		  while((FLASH_IAPSR & 0X04)==0);
3806  00c2 c65054        	ld	a,_FLASH_IAPSR
3807  00c5 a504          	bcp	a,#4
3808  00c7 27f9          	jreq	L7732
3809                     ; 113 		  FLASH_IAPSR &=~0X08;
3811  00c9 72175054      	bres	_FLASH_IAPSR,#3
3812                     ; 114 			p=p-1;
3814  00cd ce0000        	ldw	x,_p
3815  00d0 1d0004        	subw	x,#4
3816  00d3 cf0000        	ldw	_p,x
3817  00d6               L7532:
3818                     ; 117 	cal_val_temp=*p;
3820  00d6 ce0000        	ldw	x,_p
3821  00d9 9093          	ldw	y,x
3822  00db ee02          	ldw	x,(2,x)
3823  00dd cf0002        	ldw	_cal_val_temp+2,x
3824  00e0 93            	ldw	x,y
3825  00e1 fe            	ldw	x,(x)
3826  00e2 cf0000        	ldw	_cal_val_temp,x
3827                     ; 118 	p=p+1;
3829  00e5 ce0000        	ldw	x,_p
3830  00e8 1c0004        	addw	x,#4
3831  00eb cf0000        	ldw	_p,x
3832                     ; 119 	pow_val_temp=*p;
3834  00ee ce0000        	ldw	x,_p
3835  00f1 9093          	ldw	y,x
3836  00f3 ee02          	ldw	x,(2,x)
3837  00f5 cf0002        	ldw	_pow_val_temp+2,x
3838  00f8 93            	ldw	x,y
3839  00f9 fe            	ldw	x,(x)
3840  00fa cf0000        	ldw	_pow_val_temp,x
3841                     ; 120 	cal_val=cal_val_temp-(pow_val_temp-3)*0.097;//LM358=0.097 试用于6002   //转换为3V电池对应的值 //0.225=MCP6242   LM358=0.097
3843  00fd ae0000        	ldw	x,#_pow_val_temp
3844  0100 8d000000      	callf	d_ltor
3846  0104 ae0018        	ldw	x,#L7042
3847  0107 8d000000      	callf	d_fsub
3849  010b ae0014        	ldw	x,#L7142
3850  010e 8d000000      	callf	d_fmul
3852  0112 96            	ldw	x,sp
3853  0113 1c0001        	addw	x,#OFST-3
3854  0116 8d000000      	callf	d_rtol
3856  011a ae0000        	ldw	x,#_cal_val_temp
3857  011d 8d000000      	callf	d_ltor
3859  0121 96            	ldw	x,sp
3860  0122 1c0001        	addw	x,#OFST-3
3861  0125 8d000000      	callf	d_fsub
3863  0129 ae0000        	ldw	x,#_cal_val
3864  012c 8d000000      	callf	d_rtol
3866                     ; 121 	if(cal_val_temp==0)//没有标定
3868  0130 725d0000      	tnz	_cal_val_temp
3869  0134 2629          	jrne	L3242
3870  0136               L5242:
3871                     ; 125 			ledflash(red, 1, 100, 100);
3873  0136 ae0064        	ldw	x,#100
3874  0139 89            	pushw	x
3875  013a ae0064        	ldw	x,#100
3876  013d 89            	pushw	x
3877  013e ae0001        	ldw	x,#1
3878  0141 89            	pushw	x
3879  0142 a604          	ld	a,#4
3880  0144 8d000000      	callf	f_ledflash
3882  0148 5b06          	addw	sp,#6
3883                     ; 126 			ledflash(brue, 1, 100, 100);
3885  014a ae0064        	ldw	x,#100
3886  014d 89            	pushw	x
3887  014e ae0064        	ldw	x,#100
3888  0151 89            	pushw	x
3889  0152 ae0001        	ldw	x,#1
3890  0155 89            	pushw	x
3891  0156 4f            	clr	a
3892  0157 8d000000      	callf	f_ledflash
3894  015b 5b06          	addw	sp,#6
3896  015d 20d7          	jra	L5242
3897  015f               L3242:
3898                     ; 129 	if((cal_val<0.140) || (cal_val>0.670))//v3.0 190320批次
3900  015f 9c            	rvf
3901  0160 ae0000        	ldw	x,#_cal_val
3902  0163 8d000000      	callf	d_ltor
3904  0167 ae0010        	ldw	x,#L1442
3905  016a 8d000000      	callf	d_fcmp
3907  016e 2f11          	jrslt	L5542
3909  0170 9c            	rvf
3910  0171 ae0000        	ldw	x,#_cal_val
3911  0174 8d000000      	callf	d_ltor
3913  0178 ae000c        	ldw	x,#L1542
3914  017b 8d000000      	callf	d_fcmp
3916  017f 2d0a          	jrsle	L1342
3917  0181               L5542:
3918                     ; 135 			led_state(red, ON);
3920  0181 5f            	clrw	x
3921  0182 a604          	ld	a,#4
3922  0184 95            	ld	xh,a
3923  0185 8d000000      	callf	f_led_state
3926  0189 20f6          	jra	L5542
3927  018b               L1342:
3928                     ; 139 	ledflash(brue,3,70,70);
3930  018b ae0046        	ldw	x,#70
3931  018e 89            	pushw	x
3932  018f ae0046        	ldw	x,#70
3933  0192 89            	pushw	x
3934  0193 ae0003        	ldw	x,#3
3935  0196 89            	pushw	x
3936  0197 4f            	clr	a
3937  0198 8d000000      	callf	f_ledflash
3939  019c 5b06          	addw	sp,#6
3940                     ; 140 	Test_Device();
3942  019e 8d000000      	callf	f_Test_Device
3944                     ; 141 }
3947  01a2 5b04          	addw	sp,#4
3948  01a4 87            	retf
3979                     ; 147 char check_one(void)//4.7R的电阻2020.3
3979                     ; 148 {
3980                     .text:	section	.text,new
3981  0000               f_check_one:
3983  0000 5204          	subw	sp,#4
3984       00000004      OFST:	set	4
3987                     ; 150   power_up_amplify
3989  0002 721c5007      	bset	_PB_DDR,#6
3992  0006 721c5008      	bset	_PB_CR1,#6
3995  000a 721c5005      	bset	_PB_ODR,#6
3996                     ; 151   power_up_emitter
3998  000e 721a5007      	bset	_PB_DDR,#5
4001  0012 721a5008      	bset	_PB_CR1,#5
4004  0016 721a5005      	bset	_PB_ODR,#5
4005                     ; 152   AD_IR_val();
4007  001a 8d000000      	callf	f_AD_IR_val
4009                     ; 153   power_down_amplify
4011  001e 721c5007      	bset	_PB_DDR,#6
4014  0022 721c5008      	bset	_PB_CR1,#6
4017  0026 721d5005      	bres	_PB_ODR,#6
4018                     ; 154   power_down_emitter
4020  002a 721a5007      	bset	_PB_DDR,#5
4023  002e 721a5008      	bset	_PB_CR1,#5
4026  0032 721b5005      	bres	_PB_ODR,#5
4027                     ; 155   cal_val=cal_val_temp-(pow_val_temp-3)*0.097; //0.097=LM358试用于6002  转换为3V电池对应的值  0.225=MCP6242
4029  0036 ae0000        	ldw	x,#_pow_val_temp
4030  0039 8d000000      	callf	d_ltor
4032  003d ae0018        	ldw	x,#L7042
4033  0040 8d000000      	callf	d_fsub
4035  0044 ae0014        	ldw	x,#L7142
4036  0047 8d000000      	callf	d_fmul
4038  004b 96            	ldw	x,sp
4039  004c 1c0001        	addw	x,#OFST-3
4040  004f 8d000000      	callf	d_rtol
4042  0053 ae0000        	ldw	x,#_cal_val_temp
4043  0056 8d000000      	callf	d_ltor
4045  005a 96            	ldw	x,sp
4046  005b 1c0001        	addw	x,#OFST-3
4047  005e 8d000000      	callf	d_fsub
4049  0062 ae0000        	ldw	x,#_cal_val
4050  0065 8d000000      	callf	d_rtol
4052                     ; 156 	cal_val=cal_val-(3-pow_val)*0.111+0.08;   //后面姚工0.03测出1.8%左右  //0.03用于6002（烟箱0.02测出2.5左右，0.03测出3.0%，0.04测出3.5左右）   LM358=0.0134   cal_val=cal_val-(3-pow_val)*0.258+0.0834; //当前电压下的报警值  0.258=MCP6242         
4054  0069 a603          	ld	a,#3
4055  006b 8d000000      	callf	d_ctof
4057  006f ae0000        	ldw	x,#_pow_val
4058  0072 8d000000      	callf	d_fsub
4060  0076 ae0008        	ldw	x,#L5742
4061  0079 8d000000      	callf	d_fmul
4063  007d 96            	ldw	x,sp
4064  007e 1c0001        	addw	x,#OFST-3
4065  0081 8d000000      	callf	d_rtol
4067  0085 ae0000        	ldw	x,#_cal_val
4068  0088 8d000000      	callf	d_ltor
4070  008c 96            	ldw	x,sp
4071  008d 1c0001        	addw	x,#OFST-3
4072  0090 8d000000      	callf	d_fsub
4074  0094 ae0004        	ldw	x,#L5052
4075  0097 8d000000      	callf	d_fadd
4077  009b ae0000        	ldw	x,#_cal_val
4078  009e 8d000000      	callf	d_rtol
4080                     ; 158   if(IR_val>cal_val)
4082  00a2 9c            	rvf
4083  00a3 ae0000        	ldw	x,#_IR_val
4084  00a6 8d000000      	callf	d_ltor
4086  00aa ae0000        	ldw	x,#_cal_val
4087  00ad 8d000000      	callf	d_fcmp
4089  00b1 2d04          	jrsle	L1152
4090                     ; 160     return 1;
4092  00b3 a601          	ld	a,#1
4094  00b5 2001          	jra	L22
4095  00b7               L1152:
4096                     ; 162   else return 0;
4098  00b7 4f            	clr	a
4100  00b8               L22:
4102  00b8 5b04          	addw	sp,#4
4103  00ba 87            	retf
4131                     ; 166 void pow_check(void)
4131                     ; 167 {
4132                     .text:	section	.text,new
4133  0000               f_pow_check:
4137                     ; 168   if(pow_check_time_flag==0)
4139  0000 725d0000      	tnz	_pow_check_time_flag
4140  0004 2652          	jrne	L5252
4141                     ; 170     AD_VDD_val();//有空测试一下准确否
4143  0006 8d000000      	callf	f_AD_VDD_val
4145                     ; 171     if(pow_val<2.6)
4147  000a 9c            	rvf
4148  000b ae0000        	ldw	x,#_pow_val
4149  000e 8d000000      	callf	d_ltor
4151  0012 ae0000        	ldw	x,#L5352
4152  0015 8d000000      	callf	d_fcmp
4154  0019 2e28          	jrsge	L7252
4155                     ; 173       ledflash(red,1,20,20);
4157  001b ae0014        	ldw	x,#20
4158  001e 89            	pushw	x
4159  001f ae0014        	ldw	x,#20
4160  0022 89            	pushw	x
4161  0023 ae0001        	ldw	x,#1
4162  0026 89            	pushw	x
4163  0027 a604          	ld	a,#4
4164  0029 8d000000      	callf	f_ledflash
4166  002d 5b06          	addw	sp,#6
4167                     ; 174       buz_state(ON);
4169  002f 4f            	clr	a
4170  0030 8d000000      	callf	f_buz_state
4172                     ; 175       delay(5);
4174  0034 ae0005        	ldw	x,#5
4175  0037 8d000000      	callf	f_delay
4177                     ; 176       buz_state(OFF);
4179  003b a601          	ld	a,#1
4180  003d 8d000000      	callf	f_buz_state
4183  0041 2011          	jra	L1452
4184  0043               L7252:
4185                     ; 180       ledflash(brue,1,1,0);//10ms左右
4187  0043 5f            	clrw	x
4188  0044 89            	pushw	x
4189  0045 ae0001        	ldw	x,#1
4190  0048 89            	pushw	x
4191  0049 ae0001        	ldw	x,#1
4192  004c 89            	pushw	x
4193  004d 4f            	clr	a
4194  004e 8d000000      	callf	f_ledflash
4196  0052 5b06          	addw	sp,#6
4197  0054               L1452:
4198                     ; 182     pow_check_time_flag=10;
4200  0054 350a0000      	mov	_pow_check_time_flag,#10
4201  0058               L5252:
4202                     ; 184 }
4205  0058 87            	retf
4233                     	xref	_p
4234                     	switch	.bss
4235  0000               _temp:
4236  0000 0000          	ds.b	2
4237                     	xdef	_temp
4238  0002               _temp1:
4239  0002 0000          	ds.b	2
4240                     	xdef	_temp1
4241                     	xref	_pow_check_time_flag
4242                     	xref	_pow_val_temp
4243                     	xref	_cal_val_temp
4244                     	xref	_cal_val
4245                     	xref	_IR_val
4246                     	xref	_pow_val
4247                     	xdef	f_AD_IR_val
4248                     	xdef	f_AD_VDD_val
4249                     	xdef	f_ADC_Init
4250                     	xdef	f_pow_check
4251                     	xdef	f_calibrat
4252                     	xref	f_buz_state
4253                     	xref	f_ledflash
4254                     	xref	f_led_state
4255                     	xref	f_Test_Device
4256                     	xref	f_delay
4257                     	xref	f_delay_ms
4258                     	xref	f_delay_us
4259                     	xdef	f_check_one
4260                     .const:	section	.text
4261  0000               L5352:
4262  0000 40266666      	dc.w	16422,26214
4263  0004               L5052:
4264  0004 3da3d70a      	dc.w	15779,-10486
4265  0008               L5742:
4266  0008 3de353f7      	dc.w	15843,21495
4267  000c               L1542:
4268  000c 3f2b851e      	dc.w	16171,-31458
4269  0010               L1442:
4270  0010 3e0f5c28      	dc.w	15887,23592
4271  0014               L7142:
4272  0014 3dc6a7ef      	dc.w	15814,-22545
4273  0018               L7042:
4274  0018 40400000      	dc.w	16448,0
4275  001c               L3232:
4276  001c 459cac08      	dc.w	17820,-21496
4277  0020               L3432:
4278  0020 3f9cac08      	dc.w	16284,-21496
4279                     	xref.b	c_x
4299                     	xref	d_fadd
4300                     	xref	d_ctof
4301                     	xref	d_fcmp
4302                     	xref	d_fsub
4303                     	xref	d_fmul
4304                     	xref	d_fdiv
4305                     	xref	d_rtol
4306                     	xref	d_uitof
4307                     	xref	d_ltor
4308                     	end
