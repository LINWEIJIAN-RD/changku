   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3318                     	switch	.data
3319  0000               _pow_val:
3320  0000 00000000      	dc.w	0,0
3321  0004               _cal_val:
3322  0004 00000000      	dc.w	0,0
3323  0008               _cal_val_temp:
3324  0008 00000000      	dc.w	0,0
3325  000c               _pow_val_temp:
3326  000c 00000000      	dc.w	0,0
3327  0010               _IR_val:
3328  0010 00000000      	dc.w	0,0
3329  0014               _flag_key:
3330  0014 00            	dc.b	0
3331  0015               _keydelay:
3332  0015 0000          	dc.w	0
3333  0017               _if_alarm:
3334  0017 00            	dc.b	0
3335  0018               _get_msg_alarm:
3336  0018 00            	dc.b	0
3337  0019               _hush:
3338  0019 77            	dc.b	119
3339  001a               _hush_key_flag:
3340  001a 00            	dc.b	0
3341  001b               _hush_flag:
3342  001b 01            	dc.b	1
3343  001c               _hush_change_flag:
3344  001c 77            	dc.b	119
3345  001d               _pow_check_time_flag:
3346  001d 00            	dc.b	0
3347  001e               _silence_time:
3348  001e 0000          	dc.w	0
3349  0020               _Button_down_flag:
3350  0020 00            	dc.b	0
3351  0021               _RF_work_state:
3352  0021 00            	dc.b	0
3353  0022               _TX_num_temp:
3354  0022 00            	dc.b	0
3355  0023               _TX_num:
3356  0023 00            	dc.b	0
3393                     ; 34 void sleep(void)
3393                     ; 35 {
3394                     .text:	section	.text,new
3395  0000               f_sleep:
3399                     ; 36   CLK_PCKENR2|=0X04;	     //开启RTC时钟
3401  0000 721450c4      	bset	_CLK_PCKENR2,#2
3402                     ; 37 	CLK_CRTCR=0x04;       //选择LSI作为RTC时钟源38KHZ
3404  0004 350450c1      	mov	_CLK_CRTCR,#4
3405                     ; 38 	RTC_WPR=0xca;       //去RTC寄存器写保护
3407  0008 35ca5159      	mov	_RTC_WPR,#202
3408                     ; 39 	RTC_WPR=0x53;				//去RTC寄存器写保护
3410  000c 35535159      	mov	_RTC_WPR,#83
3411                     ; 40 	RTC_CR2 &=0xfb;     //清除WUTE禁用RTC定时器 
3413  0010 72155149      	bres	_RTC_CR2,#2
3415  0014               L3032:
3416                     ; 41 	while((RTC_ISR1 & 0x04)!=0x04); //直到WUTWF标志位为1，允许重装载计数值
3418  0014 c6514c        	ld	a,_RTC_ISR1
3419  0017 a404          	and	a,#4
3420  0019 a104          	cp	a,#4
3421  001b 26f7          	jrne	L3032
3422                     ; 42 	RTC_CR1=0X00;        //RTC时钟分频选择2  38KHZ/2=19KHZ
3424  001d 725f5148      	clr	_RTC_CR1
3425                     ; 43 	RTC_CR2 |=0x40;      //开RTC中断
3427  0021 721c5149      	bset	_RTC_CR2,#6
3428                     ; 44 	RTC_WUTRH=0X36;       //装载计数值高位364b
3430  0025 35365154      	mov	_RTC_WUTRH,#54
3431                     ; 45 	RTC_WUTRL=0X4B;       //装载计数值低位    6S
3433  0029 354b5155      	mov	_RTC_WUTRL,#75
3434                     ; 46 	RTC_CR2 |=0X04;       //再次使能RTC定时器
3436  002d 72145149      	bset	_RTC_CR2,#2
3437                     ; 47 	RTC_WPR=0X66;       //写个错key重开写保护
3439  0031 35665159      	mov	_RTC_WPR,#102
3440                     ; 48 }
3443  0035 87            	retf
3469                     ; 49 void CLK_INIT(void)
3469                     ; 50 {
3470                     .text:	section	.text,new
3471  0000               f_CLK_INIT:
3475                     ; 51 	CLK_SWCR =0X02;        //切换时钟
3477  0000 350250c9      	mov	_CLK_SWCR,#2
3478                     ; 52   CLK_SWR  =0X01;        //HSE 0X04 HSI 0X01 LSI 0X02  4MHz
3480  0004 350150c8      	mov	_CLK_SWR,#1
3481                     ; 53 	CLK_CKDIVR=0x00;       //1分频，必选
3483  0008 725f50c0      	clr	_CLK_CKDIVR
3484                     ; 55   CLK_PCKENR2|=0X01;	     //开启ADC1时钟//CLK_PCKENR2=0X00;	     //默认状态是1000 0000
3486  000c 721050c4      	bset	_CLK_PCKENR2,#0
3487                     ; 56 }
3490  0010 87            	retf
3531                     ; 57 char Test_Device(void)//修改频率，防止干扰。
3531                     ; 58 {
3532                     .text:	section	.text,new
3533  0000               f_Test_Device:
3537                     ; 59 	if((PC_IDR & 0X02)==0X02 )
3539  0000 c6500b        	ld	a,_PC_IDR
3540  0003 a402          	and	a,#2
3541  0005 a102          	cp	a,#2
3542  0007 2704          	jreq	L21
3543  0009 acf800f8      	jpf	L7232
3544  000d               L21:
3545                     ; 61     delay(3);
3547  000d ae0003        	ldw	x,#3
3548  0010 8d000000      	callf	f_delay
3550                     ; 62     if((PC_IDR & 0X02)==0X02 )
3552  0014 c6500b        	ld	a,_PC_IDR
3553  0017 a402          	and	a,#2
3554  0019 a102          	cp	a,#2
3555  001b 2704          	jreq	L41
3556  001d acf800f8      	jpf	L7232
3557  0021               L41:
3558                     ; 64 		  led_state(red, ON);
3560  0021 5f            	clrw	x
3561  0022 a604          	ld	a,#4
3562  0024 95            	ld	xh,a
3563  0025 8d000000      	callf	f_led_state
3565                     ; 65 			led_state(brue, ON);
3567  0029 5f            	clrw	x
3568  002a 4f            	clr	a
3569  002b 95            	ld	xh,a
3570  002c 8d000000      	callf	f_led_state
3572                     ; 66 			_asm("rim");
3575  0030 9a            rim
3577                     ; 67 			setup_Rx();
3579  0031 8d000000      	callf	f_setup_Rx
3581                     ; 68 			GPO3In();
3583  0035 7211500c      	bres	_PC_DDR,#0
3584                     ; 69 			GPO3IT();
3586  0039 7210500e      	bset	_PC_CR2,#0
3587                     ; 70 			EXTI_CR1|=0x01;//PC0 Rising 
3589  003d 721050a0      	bset	_EXTI_CR1,#0
3590  0041               L3332:
3591                     ; 73 				if( True==RF_Receive() ) //收到 
3593  0041 8d000000      	callf	f_RF_Receive
3595  0045 a101          	cp	a,#1
3596  0047 26f8          	jrne	L3332
3597                     ; 75 					if( (getstr[0]==0x09) && (getstr[1]==0x23) )
3599  0049 c60000        	ld	a,_getstr
3600  004c a109          	cp	a,#9
3601  004e 26f1          	jrne	L3332
3603  0050 c60001        	ld	a,_getstr+1
3604  0053 a123          	cp	a,#35
3605  0055 26ea          	jrne	L3332
3606                     ; 77 						str[0]=0x09;
3608  0057 35090000      	mov	_str,#9
3609                     ; 78 						str[1]=0x23;
3611  005b 35230001      	mov	_str+1,#35
3612                     ; 79 						AD_VDD_val();
3614  005f 8d000000      	callf	f_AD_VDD_val
3616                     ; 80 						AD_IR_val();
3618  0063 8d000000      	callf	f_AD_IR_val
3620                     ; 81 						str[2]=(char)(IR_val*10000)|0x00;//suiji ;
3622  0067 ae0010        	ldw	x,#_IR_val
3623  006a 8d000000      	callf	d_ltor
3625  006e ae0000        	ldw	x,#L7432
3626  0071 8d000000      	callf	d_fmul
3628  0075 8d000000      	callf	d_ftol
3630  0079 b603          	ld	a,c_lreg+3
3631  007b c70002        	ld	_str+2,a
3632                     ; 82 						str[2]=((char)(pow_val*10000)|0x00)+str[2];
3634  007e ae0000        	ldw	x,#_pow_val
3635  0081 8d000000      	callf	d_ltor
3637  0085 ae0000        	ldw	x,#L7432
3638  0088 8d000000      	callf	d_fmul
3640  008c 8d000000      	callf	d_ftol
3642  0090 b603          	ld	a,c_lreg+3
3643  0092 cb0002        	add	a,_str+2
3644  0095 c70002        	ld	_str+2,a
3645  0098               L3532:
3646                     ; 85 							setup_Tx();
3648  0098 8d000000      	callf	f_setup_Tx
3650                     ; 86 							bGoTx();//jia
3652  009c 8d000000      	callf	f_bGoTx
3654                     ; 87 							for(i=0;i<2;i++)//12s~140  2600改3250
3656  00a0 5f            	clrw	x
3657  00a1 cf0000        	ldw	_i,x
3658  00a4               L7532:
3659                     ; 89 								loop_Tx();
3661  00a4 8d000000      	callf	f_loop_Tx
3663                     ; 87 							for(i=0;i<2;i++)//12s~140  2600改3250
3665  00a8 ce0000        	ldw	x,_i
3666  00ab 1c0001        	addw	x,#1
3667  00ae cf0000        	ldw	_i,x
3670  00b1 9c            	rvf
3671  00b2 ce0000        	ldw	x,_i
3672  00b5 a30002        	cpw	x,#2
3673  00b8 2fea          	jrslt	L7532
3674                     ; 91 							GPO3IT();
3676  00ba 7210500e      	bset	_PC_CR2,#0
3677                     ; 92 							setup_Rx();
3679  00be 8d000000      	callf	f_setup_Rx
3681                     ; 93 							if( True==RF_Receive() ) //收到 
3683  00c2 8d000000      	callf	f_RF_Receive
3685  00c6 a101          	cp	a,#1
3686  00c8 26ce          	jrne	L3532
3687                     ; 95 								if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
3689  00ca c60000        	ld	a,_getstr
3690  00cd c10000        	cp	a,_str
3691  00d0 26c6          	jrne	L3532
3693  00d2 c60001        	ld	a,_getstr+1
3694  00d5 c10001        	cp	a,_str+1
3695  00d8 26be          	jrne	L3532
3696                     ; 97 									if(getstr[2]==str[2])//suiji
3698  00da c60002        	ld	a,_getstr+2
3699  00dd c10002        	cp	a,_str+2
3700  00e0 26b6          	jrne	L3532
3701                     ; 99 										led_state(red, OFF);
3703  00e2 ae0001        	ldw	x,#1
3704  00e5 a604          	ld	a,#4
3705  00e7 95            	ld	xh,a
3706  00e8 8d000000      	callf	f_led_state
3708                     ; 100 			              led_state(brue, OFF);
3710  00ec ae0001        	ldw	x,#1
3711  00ef 4f            	clr	a
3712  00f0 95            	ld	xh,a
3713  00f1 8d000000      	callf	f_led_state
3715                     ; 101 										return 1;
3717  00f5 a601          	ld	a,#1
3720  00f7 87            	retf
3721  00f8               L7232:
3722                     ; 111 }
3725  00f8 87            	retf
3766                     ; 112 void TX_fuction(unsigned char num)
3766                     ; 113 {
3767                     .text:	section	.text,new
3768  0000               f_TX_fuction:
3770  0000 88            	push	a
3771       00000000      OFST:	set	0
3774                     ; 114 	setup_Tx();
3776  0001 8d000000      	callf	f_setup_Tx
3778                     ; 115   RF_work_state=TX_state;
3780  0005 35330021      	mov	_RF_work_state,#51
3781                     ; 116 	TX_num_temp=0;
3783  0009 725f0022      	clr	_TX_num_temp
3784                     ; 117 	TX_num=num;
3786  000d 7b01          	ld	a,(OFST+1,sp)
3787  000f c70023        	ld	_TX_num,a
3788                     ; 118 	vSetTxPayloadLength(LEN);
3790  0012 ae0004        	ldw	x,#4
3791  0015 8d000000      	callf	f_vSetTxPayloadLength
3793                     ; 119 	bIntSrcFlagClr();  //jia 调试发现stanby会产生TX_DONE中断，所以加了清除中断标志
3795  0019 8d000000      	callf	f_bIntSrcFlagClr
3797                     ; 120 	vEnableWrFifo();	
3799  001d 8d000000      	callf	f_vEnableWrFifo
3801                     ; 122 	vSpi3BurstWriteFIFO(str, LEN);
3803  0021 4b04          	push	#4
3804  0023 ae0000        	ldw	x,#_str
3805  0026 8d000000      	callf	f_vSpi3BurstWriteFIFO
3807  002a 84            	pop	a
3808                     ; 124 	bGoTx();
3810  002b 8d000000      	callf	f_bGoTx
3812                     ; 125 }
3815  002f 84            	pop	a
3816  0030 87            	retf
3909                     ; 128 void main()
3909                     ; 129 {
3910                     .text:	section	.text,new
3911  0000               f_main:
3913  0000 5203          	subw	sp,#3
3914       00000003      OFST:	set	3
3917                     ; 130 	CLK_INIT();
3919  0002 8d000000      	callf	f_CLK_INIT
3921                     ; 131 	GPIO_INIT();
3923  0006 8d000000      	callf	f_GPIO_INIT
3925                     ; 132 	INT_key_Init();
3927  000a 8d000000      	callf	f_INT_key_Init
3929                     ; 133   ADC_Init();	
3931  000e 8d000000      	callf	f_ADC_Init
3933                     ; 134 	calibrat();
3935  0012 8d000000      	callf	f_calibrat
3937                     ; 135   _asm("rim");
3940  0016 9a            rim
3942                     ; 136   RAM_read();
3944  0017 8d000000      	callf	f_RAM_read
3946                     ; 138 	setup_Rx();//初始化为RX  遇到一个现象，加bGoRx(); while(1); 后，只能上电前有发射，才能进入接收。以后找原因,和rf1.h有关
3948  001b 8d000000      	callf	f_setup_Rx
3950  001f               L1342:
3951                     ; 145     key();
3953  001f 8d000000      	callf	f_key
3955                     ; 147     pow_check();
3957  0023 8d000000      	callf	f_pow_check
3959                     ; 149     for(i=0;i<1;i++)   //收
3961  0027 5f            	clrw	x
3962  0028 cf0000        	ldw	_i,x
3963  002b               L5342:
3964                     ; 151       if( True==RF_Receive() ) //收到 没有确认收到数据包
3966  002b 8d000000      	callf	f_RF_Receive
3968  002f a101          	cp	a,#1
3969  0031 261c          	jrne	L3442
3970                     ; 168 				if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
3972  0033 c60000        	ld	a,_getstr
3973  0036 c10000        	cp	a,_str
3974  0039 2614          	jrne	L3442
3976  003b c60001        	ld	a,_getstr+1
3977  003e c10001        	cp	a,_str+1
3978  0041 260c          	jrne	L3442
3979                     ; 172           get_msg_alarm=getstr[2];//报警
3981  0043 5500020018    	mov	_get_msg_alarm,_getstr+2
3982                     ; 173           hush=getstr[3];//声音
3984  0048 5500030019    	mov	_hush,_getstr+3
3985                     ; 174           break;
3987  004d 2012          	jra	L1442
3988  004f               L3442:
3989                     ; 149     for(i=0;i<1;i++)   //收
3991  004f ce0000        	ldw	x,_i
3992  0052 1c0001        	addw	x,#1
3993  0055 cf0000        	ldw	_i,x
3996  0058 9c            	rvf
3997  0059 ce0000        	ldw	x,_i
3998  005c a30001        	cpw	x,#1
3999  005f 2fca          	jrslt	L5342
4000  0061               L1442:
4001                     ; 179     if(True==check_one())
4003  0061 8d000000      	callf	f_check_one
4005  0065 a101          	cp	a,#1
4006  0067 263f          	jrne	L7442
4007                     ; 181       for(if_alarm=9;if_alarm>1;)	      //8次
4009  0069 35090017      	mov	_if_alarm,#9
4010  006d               L1542:
4011                     ; 183         ledflash(red,1,10,10);
4013  006d ae000a        	ldw	x,#10
4014  0070 89            	pushw	x
4015  0071 ae000a        	ldw	x,#10
4016  0074 89            	pushw	x
4017  0075 ae0001        	ldw	x,#1
4018  0078 89            	pushw	x
4019  0079 a604          	ld	a,#4
4020  007b 8d000000      	callf	f_ledflash
4022  007f 5b06          	addw	sp,#6
4023                     ; 184         delay(30);
4025  0081 ae001e        	ldw	x,#30
4026  0084 8d000000      	callf	f_delay
4028                     ; 185         if_alarm--;
4030  0088 725a0017      	dec	_if_alarm
4031                     ; 186         check_one();
4033  008c 8d000000      	callf	f_check_one
4035                     ; 187         if(IR_val<cal_val) break;
4037  0090 9c            	rvf
4038  0091 ae0010        	ldw	x,#_IR_val
4039  0094 8d000000      	callf	d_ltor
4041  0098 ae0004        	ldw	x,#_cal_val
4042  009b 8d000000      	callf	d_fcmp
4044  009f 2f07          	jrslt	L7442
4047                     ; 181       for(if_alarm=9;if_alarm>1;)	      //8次
4049  00a1 c60017        	ld	a,_if_alarm
4050  00a4 a102          	cp	a,#2
4051  00a6 24c5          	jruge	L1542
4052  00a8               L7442:
4053                     ; 191     if(if_alarm==1)//报警
4055  00a8 c60017        	ld	a,_if_alarm
4056  00ab a101          	cp	a,#1
4057  00ad 2704          	jreq	L22
4058  00af acdd01dd      	jpf	L1642
4059  00b3               L22:
4060                     ; 193       unsigned char k=20,tem=1;
4062  00b3 a614          	ld	a,#20
4063  00b5 6b02          	ld	(OFST-1,sp),a
4066  00b7 a601          	ld	a,#1
4067  00b9 6b03          	ld	(OFST+0,sp),a
4068                     ; 194 			hush_change_flag=all_ring;
4070  00bb 3577001c      	mov	_hush_change_flag,#119
4071                     ; 195       hush=all_ring;
4073  00bf 35770019      	mov	_hush,#119
4074                     ; 196       hush_flag=1;//test
4076  00c3 3501001b      	mov	_hush_flag,#1
4077                     ; 197 			silence_time=0;//静音时长清零
4079  00c7 5f            	clrw	x
4080  00c8 cf001e        	ldw	_silence_time,x
4081                     ; 198       T1_Middle_for_ledbuz_EN();  //报警输出
4083  00cb 8d000000      	callf	f_T1_Middle_for_ledbuz_EN
4085                     ; 200       str[2]=alarm_code;
4087  00cf 35f00002      	mov	_str+2,#240
4088                     ; 201       str[3]=hush;
4090  00d3 5500190003    	mov	_str+3,_hush
4091                     ; 202 	    TX_fuction(30);//9秒左右
4093  00d8 a61e          	ld	a,#30
4094  00da 8d000000      	callf	f_TX_fuction
4097  00de acc601c6      	jpf	L5642
4098  00e2               L3642:
4099                     ; 207         if((k==0)&&(RF_work_state==Sleep_state))
4101  00e2 0d02          	tnz	(OFST-1,sp)
4102  00e4 2629          	jrne	L1742
4104  00e6 c60021        	ld	a,_RF_work_state
4105  00e9 a15a          	cp	a,#90
4106  00eb 2622          	jrne	L1742
4107                     ; 209           str[2]=alarm_code+tem;
4109  00ed 7b03          	ld	a,(OFST+0,sp)
4110  00ef abf0          	add	a,#240
4111  00f1 c70002        	ld	_str+2,a
4112                     ; 211 					TX_fuction(5);//1.5秒左右
4114  00f4 a605          	ld	a,#5
4115  00f6 8d000000      	callf	f_TX_fuction
4117                     ; 212           tem++;
4119  00fa 0c03          	inc	(OFST+0,sp)
4120                     ; 213           if(tem==10)tem=0;
4122  00fc 7b03          	ld	a,(OFST+0,sp)
4123  00fe a10a          	cp	a,#10
4124  0100 2602          	jrne	L3742
4127  0102 0f03          	clr	(OFST+0,sp)
4128  0104               L3742:
4129                     ; 214           k=20;//60改20
4131  0104 a614          	ld	a,#20
4132  0106 6b02          	ld	(OFST-1,sp),a
4134  0108               L1052:
4135                     ; 215 					while(RF_work_state==TX_state);//防止错过RX
4137  0108 c60021        	ld	a,_RF_work_state
4138  010b a133          	cp	a,#51
4139  010d 27f9          	jreq	L1052
4140  010f               L1742:
4141                     ; 218 				if(RF_work_state==Sleep_state)
4143  010f c60021        	ld	a,_RF_work_state
4144  0112 a15a          	cp	a,#90
4145  0114 2643          	jrne	L5052
4146                     ; 220 					for(i=0;i<3;i++)   //收
4148  0116 5f            	clrw	x
4149  0117 cf0000        	ldw	_i,x
4150  011a               L7052:
4151                     ; 222 						if( True==RF_Receive() ) //收到
4153  011a 8d000000      	callf	f_RF_Receive
4155  011e a101          	cp	a,#1
4156  0120 2625          	jrne	L5152
4157                     ; 224 							if( (getstr[0]==str[0]) && (getstr[1]==str[1]) && (getstr[2]!=alarm_code_test) )
4159  0122 c60000        	ld	a,_getstr
4160  0125 c10000        	cp	a,_str
4161  0128 261d          	jrne	L5152
4163  012a c60001        	ld	a,_getstr+1
4164  012d c10001        	cp	a,_str+1
4165  0130 2615          	jrne	L5152
4167  0132 c60002        	ld	a,_getstr+2
4168  0135 a1dd          	cp	a,#221
4169  0137 270e          	jreq	L5152
4170                     ; 226 								if(getstr[3]!=all_ring) hush=getstr[3]; //
4172  0139 c60003        	ld	a,_getstr+3
4173  013c a177          	cp	a,#119
4174  013e 2719          	jreq	L5052
4177  0140 5500030019    	mov	_hush,_getstr+3
4178  0145 2012          	jra	L5052
4179  0147               L5152:
4180                     ; 220 					for(i=0;i<3;i++)   //收
4182  0147 ce0000        	ldw	x,_i
4183  014a 1c0001        	addw	x,#1
4184  014d cf0000        	ldw	_i,x
4187  0150 9c            	rvf
4188  0151 ce0000        	ldw	x,_i
4189  0154 a30003        	cpw	x,#3
4190  0157 2fc1          	jrslt	L7052
4191  0159               L5052:
4192                     ; 232 				if(hush==all_silence)      //主机静音模式
4194  0159 c60019        	ld	a,_hush
4195  015c a166          	cp	a,#102
4196  015e 261c          	jrne	L7252
4197                     ; 234           buz_state(OFF);
4199  0160 a601          	ld	a,#1
4200  0162 8d000000      	callf	f_buz_state
4202                     ; 235           hush_flag=0;
4204  0166 725f001b      	clr	_hush_flag
4205  016a 2010          	jra	L7252
4206  016c               L5252:
4207                     ; 240           str[3]=hush;
4209  016c 5500190003    	mov	_str+3,_hush
4210                     ; 241 			    TX_fuction(20);//6秒左右
4212  0171 a614          	ld	a,#20
4213  0173 8d000000      	callf	f_TX_fuction
4215                     ; 242           hush_change_flag=hush;
4217  0177 550019001c    	mov	_hush_change_flag,_hush
4218  017c               L7252:
4219                     ; 238         while( hush!=hush_change_flag )
4221  017c c60019        	ld	a,_hush
4222  017f c1001c        	cp	a,_hush_change_flag
4223  0182 26e8          	jrne	L5252
4224                     ; 245         if(k==10)//30改10
4226  0184 7b02          	ld	a,(OFST-1,sp)
4227  0186 a10a          	cp	a,#10
4228  0188 2604          	jrne	L3352
4229                     ; 247           check_one();
4231  018a 8d000000      	callf	f_check_one
4233  018e               L3352:
4234                     ; 250         if(IR_val<=cal_val)
4236  018e 9c            	rvf
4237  018f ae0010        	ldw	x,#_IR_val
4238  0192 8d000000      	callf	d_ltor
4240  0196 ae0004        	ldw	x,#_cal_val
4241  0199 8d000000      	callf	d_fcmp
4243  019d 2c25          	jrsgt	L5352
4244                     ; 252           buz_state(OFF);  //关闭蜂鸣器
4246  019f a601          	ld	a,#1
4247  01a1 8d000000      	callf	f_buz_state
4249                     ; 253           T1_for_ledbuz_DIS();//关定时器中断，从而关报警
4251  01a5 8d000000      	callf	f_T1_for_ledbuz_DIS
4253                     ; 254 					red_OFF;  //关闭红灯
4255  01a9 7219500a      	bres	_PC_ODR,#4
4256                     ; 255           str[2]=dis_alarm_code;
4258  01ad 350f0002      	mov	_str+2,#15
4259                     ; 256 					TX_fuction(20);//6秒左右
4261  01b1 a614          	ld	a,#20
4262  01b3 8d000000      	callf	f_TX_fuction
4265  01b7               L1452:
4266                     ; 257 					while(RF_work_state==TX_state);
4268  01b7 c60021        	ld	a,_RF_work_state
4269  01ba a133          	cp	a,#51
4270  01bc 27f9          	jreq	L1452
4271                     ; 258 					break;
4272  01be               L7642:
4273                     ; 263       if_alarm=0;
4275  01be 725f0017      	clr	_if_alarm
4276  01c2 2019          	jra	L1642
4277  01c4               L5352:
4278                     ; 261         k--;
4280  01c4 0a02          	dec	(OFST-1,sp)
4281  01c6               L5642:
4282                     ; 204       while(IR_val>cal_val)
4284  01c6 9c            	rvf
4285  01c7 ae0010        	ldw	x,#_IR_val
4286  01ca 8d000000      	callf	d_ltor
4288  01ce ae0004        	ldw	x,#_cal_val
4289  01d1 8d000000      	callf	d_fcmp
4291  01d5 2d04          	jrsle	L42
4292  01d7 ace200e2      	jpf	L3642
4293  01db               L42:
4294  01db 20e1          	jra	L7642
4295  01dd               L1642:
4296                     ; 266     if((get_msg_alarm & 0xF0)==alarm_code)//滚动
4298  01dd c60018        	ld	a,_get_msg_alarm
4299  01e0 a4f0          	and	a,#240
4300  01e2 a1f0          	cp	a,#240
4301  01e4 2704          	jreq	L62
4302  01e6 ac8b038b      	jpf	L5452
4303  01ea               L62:
4304                     ; 268 		  unsigned int n=0;
4306  01ea 5f            	clrw	x
4307  01eb 1f02          	ldw	(OFST-1,sp),x
4308                     ; 269       unsigned char get_msg_alarm_flag=alarm_code;
4310  01ed a6f0          	ld	a,#240
4311  01ef 6b01          	ld	(OFST-2,sp),a
4312                     ; 270 			hush_change_flag=hush;
4314  01f1 550019001c    	mov	_hush_change_flag,_hush
4315                     ; 271       hush_flag=1;//需要，不然会保留上次报警的静音
4317  01f6 3501001b      	mov	_hush_flag,#1
4318                     ; 272 			silence_time=0;//静音时长清零
4320  01fa 5f            	clrw	x
4321  01fb cf001e        	ldw	_silence_time,x
4322                     ; 274 			if( (hush==all_silence)||(hush==slave_silence) )      //从设备静音模式
4324  01fe c60019        	ld	a,_hush
4325  0201 a166          	cp	a,#102
4326  0203 2707          	jreq	L1552
4328  0205 c60019        	ld	a,_hush
4329  0208 a133          	cp	a,#51
4330  020a 260a          	jrne	L7452
4331  020c               L1552:
4332                     ; 276 				buz_state(OFF);
4334  020c a601          	ld	a,#1
4335  020e 8d000000      	callf	f_buz_state
4337                     ; 277 				hush_flag=0;
4339  0212 725f001b      	clr	_hush_flag
4340  0216               L7452:
4341                     ; 279       T1_Slow_for_ledbuz_EN();  //报警信号输出
4343  0216 8d000000      	callf	f_T1_Slow_for_ledbuz_EN
4345                     ; 281       if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
4347  021a c60000        	ld	a,_RSSI_val
4348  021d a150          	cp	a,#80
4349  021f 2418          	jruge	L3552
4350                     ; 283 				repeater=1;
4352  0221 35010000      	mov	_repeater,#1
4353                     ; 284 				str[2]=get_msg_alarm;
4355  0225 5500180002    	mov	_str+2,_get_msg_alarm
4356                     ; 285 				str[3]=hush;
4358  022a 5500190003    	mov	_str+3,_hush
4359                     ; 286 				TX_fuction(20);//6秒左右
4361  022f a614          	ld	a,#20
4362  0231 8d000000      	callf	f_TX_fuction
4365  0235 ac7c037c      	jpf	L1652
4366  0239               L3552:
4367                     ; 288 			else delay_ms(6000);//yu主同步，test
4369  0239 ae1770        	ldw	x,#6000
4370  023c 8d000000      	callf	f_delay_ms
4372  0240 ac7c037c      	jpf	L1652
4373  0244               L7552:
4374                     ; 294 				if((repeater==1)&&(RF_work_state==Sleep_state))
4376  0244 c60000        	ld	a,_repeater
4377  0247 a101          	cp	a,#1
4378  0249 2631          	jrne	L5652
4380  024b c60021        	ld	a,_RF_work_state
4381  024e a15a          	cp	a,#90
4382  0250 262a          	jrne	L5652
4383                     ; 295         { ledflash(brue,6,20,5);//test测试RSSI！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
4385  0252 ae0005        	ldw	x,#5
4386  0255 89            	pushw	x
4387  0256 ae0014        	ldw	x,#20
4388  0259 89            	pushw	x
4389  025a ae0006        	ldw	x,#6
4390  025d 89            	pushw	x
4391  025e 4f            	clr	a
4392  025f 8d000000      	callf	f_ledflash
4394  0263 5b06          	addw	sp,#6
4395                     ; 296           str[2]=get_msg_alarm;
4397  0265 5500180002    	mov	_str+2,_get_msg_alarm
4398                     ; 297           str[3]=hush;//声音状态 
4400  026a 5500190003    	mov	_str+3,_hush
4401                     ; 298 					TX_fuction(5);//1.5秒左右
4403  026f a605          	ld	a,#5
4404  0271 8d000000      	callf	f_TX_fuction
4407  0275               L1752:
4408                     ; 299 					while(RF_work_state==TX_state);//防止错过RX
4410  0275 c60021        	ld	a,_RF_work_state
4411  0278 a133          	cp	a,#51
4412  027a 27f9          	jreq	L1752
4413  027c               L5652:
4414                     ; 302         if(RF_work_state==Sleep_state)
4416  027c c60021        	ld	a,_RF_work_state
4417  027f a15a          	cp	a,#90
4418  0281 2673          	jrne	L5752
4419                     ; 304 				  repeater=0;
4421  0283 725f0000      	clr	_repeater
4422                     ; 305 					for(i=0;i<3;i++)   //收
4424  0287 5f            	clrw	x
4425  0288 cf0000        	ldw	_i,x
4426  028b               L7752:
4427                     ; 307 						if( True==RF_Receive() ) //收到
4429  028b 8d000000      	callf	f_RF_Receive
4431  028f a101          	cp	a,#1
4432  0291 262e          	jrne	L5062
4433                     ; 309 							if( (getstr[0]==str[0]) && (getstr[1]==str[1]) && (getstr[2]!=alarm_code_test) )
4435  0293 c60000        	ld	a,_getstr
4436  0296 c10000        	cp	a,_str
4437  0299 2626          	jrne	L5062
4439  029b c60001        	ld	a,_getstr+1
4440  029e c10001        	cp	a,_str+1
4441  02a1 261e          	jrne	L5062
4443  02a3 c60002        	ld	a,_getstr+2
4444  02a6 a1dd          	cp	a,#221
4445  02a8 2717          	jreq	L5062
4446                     ; 311 								get_msg_alarm=getstr[2];  //记下报警状态
4448  02aa 5500020018    	mov	_get_msg_alarm,_getstr+2
4449                     ; 312 								if(getstr[3]!=all_ring) hush=getstr[3]; //不然自身的静音信号被接收的刷新了
4451  02af c60003        	ld	a,_getstr+3
4452  02b2 a177          	cp	a,#119
4453  02b4 2705          	jreq	L1162
4456  02b6 5500030019    	mov	_hush,_getstr+3
4457  02bb               L1162:
4458                     ; 313 								GET_repeater();
4460  02bb 8d000000      	callf	f_GET_repeater
4462                     ; 314 								break;
4464  02bf 2012          	jra	L3062
4465  02c1               L5062:
4466                     ; 305 					for(i=0;i<3;i++)   //收
4468  02c1 ce0000        	ldw	x,_i
4469  02c4 1c0001        	addw	x,#1
4470  02c7 cf0000        	ldw	_i,x
4473  02ca 9c            	rvf
4474  02cb ce0000        	ldw	x,_i
4475  02ce a30003        	cpw	x,#3
4476  02d1 2fb8          	jrslt	L7752
4477  02d3               L3062:
4478                     ; 319 					if(get_msg_alarm_flag==get_msg_alarm)//旧信号
4480  02d3 7b01          	ld	a,(OFST-2,sp)
4481  02d5 c10018        	cp	a,_get_msg_alarm
4482  02d8 2609          	jrne	L3162
4483                     ; 321 						n++;
4485  02da 1e02          	ldw	x,(OFST-1,sp)
4486  02dc 1c0001        	addw	x,#1
4487  02df 1f02          	ldw	(OFST-1,sp),x
4489  02e1 2008          	jra	L5162
4490  02e3               L3162:
4491                     ; 325 						get_msg_alarm_flag=get_msg_alarm;
4493  02e3 c60018        	ld	a,_get_msg_alarm
4494  02e6 6b01          	ld	(OFST-2,sp),a
4495                     ; 326 						n=0;
4497  02e8 5f            	clrw	x
4498  02e9 1f02          	ldw	(OFST-1,sp),x
4499  02eb               L5162:
4500                     ; 328 				  if(n>2000) {get_msg_alarm=dis_alarm_code; }     //超时未接收到新信息，则退出报警 10改5
4502  02eb 1e02          	ldw	x,(OFST-1,sp)
4503  02ed a307d1        	cpw	x,#2001
4504  02f0 2504          	jrult	L5752
4507  02f2 350f0018      	mov	_get_msg_alarm,#15
4508  02f6               L5752:
4509                     ; 331         if( (hush==all_silence)||(hush==slave_silence) )      //从设备静音模式
4511  02f6 c60019        	ld	a,_hush
4512  02f9 a166          	cp	a,#102
4513  02fb 2707          	jreq	L3262
4515  02fd c60019        	ld	a,_hush
4516  0300 a133          	cp	a,#51
4517  0302 260a          	jrne	L1262
4518  0304               L3262:
4519                     ; 333           buz_state(OFF);
4521  0304 a601          	ld	a,#1
4522  0306 8d000000      	callf	f_buz_state
4524                     ; 334           hush_flag=0;
4526  030a 725f001b      	clr	_hush_flag
4527  030e               L1262:
4528                     ; 338 				if(((hush!=hush_change_flag)&&(Button_down_flag==1))||((hush!=hush_change_flag)&&(repeater==1)))//不需要等待之前的发送结束，为了更快静音
4530  030e c60019        	ld	a,_hush
4531  0311 c1001c        	cp	a,_hush_change_flag
4532  0314 2707          	jreq	L1362
4534  0316 c60020        	ld	a,_Button_down_flag
4535  0319 a101          	cp	a,#1
4536  031b 270f          	jreq	L7262
4537  031d               L1362:
4539  031d c60019        	ld	a,_hush
4540  0320 c1001c        	cp	a,_hush_change_flag
4541  0323 2720          	jreq	L5262
4543  0325 c60000        	ld	a,_repeater
4544  0328 a101          	cp	a,#1
4545  032a 2619          	jrne	L5262
4546  032c               L7262:
4547                     ; 340 				  str[2]=get_msg_alarm;
4549  032c 5500180002    	mov	_str+2,_get_msg_alarm
4550                     ; 341           str[3]=hush;
4552  0331 5500190003    	mov	_str+3,_hush
4553                     ; 342 					TX_fuction(20);//6秒左右
4555  0336 a614          	ld	a,#20
4556  0338 8d000000      	callf	f_TX_fuction
4558                     ; 343           hush_change_flag=hush;
4560  033c 550019001c    	mov	_hush_change_flag,_hush
4561                     ; 344 					Button_down_flag=0;
4563  0341 725f0020      	clr	_Button_down_flag
4564  0345               L5262:
4565                     ; 347         if(get_msg_alarm==dis_alarm_code)      //报警解除
4567  0345 c60018        	ld	a,_get_msg_alarm
4568  0348 a10f          	cp	a,#15
4569  034a 2630          	jrne	L1652
4570                     ; 349           buz_state(OFF); //关闭蜂鸣器
4572  034c a601          	ld	a,#1
4573  034e 8d000000      	callf	f_buz_state
4575                     ; 350 					T1_for_ledbuz_DIS();//关定时器中断，从而关报警
4577  0352 8d000000      	callf	f_T1_for_ledbuz_DIS
4579                     ; 351 					red_OFF;  //关闭红灯
4581  0356 7219500a      	bres	_PC_ODR,#4
4582                     ; 352           if((repeater==1)&&(RF_work_state==Sleep_state))
4584  035a c60000        	ld	a,_repeater
4585  035d a101          	cp	a,#1
4586  035f 2626          	jrne	L3652
4588  0361 c60021        	ld	a,_RF_work_state
4589  0364 a15a          	cp	a,#90
4590  0366 261f          	jrne	L3652
4591                     ; 354 						str[2]=get_msg_alarm;
4593  0368 5500180002    	mov	_str+2,_get_msg_alarm
4594                     ; 355 						TX_fuction(20);//6秒左右
4596  036d a614          	ld	a,#20
4597  036f 8d000000      	callf	f_TX_fuction
4600  0373               L1462:
4601                     ; 356 						while(RF_work_state==TX_state);
4603  0373 c60021        	ld	a,_RF_work_state
4604  0376 a133          	cp	a,#51
4605  0378 27f9          	jreq	L1462
4606  037a 200b          	jra	L3652
4607  037c               L1652:
4608                     ; 290       while(get_msg_alarm!=dis_alarm_code)//while(get_msg_alarm==alarm_code)//1)//
4610  037c c60018        	ld	a,_get_msg_alarm
4611  037f a10f          	cp	a,#15
4612  0381 2704          	jreq	L03
4613  0383 ac440244      	jpf	L7552
4614  0387               L03:
4615  0387               L3652:
4616                     ; 361       get_msg_alarm=0;
4618  0387 725f0018      	clr	_get_msg_alarm
4619  038b               L5452:
4620                     ; 364 		if((get_msg_alarm==alarm_code_test)&&(Test_mode_flag==0))
4622  038b c60018        	ld	a,_get_msg_alarm
4623  038e a1dd          	cp	a,#221
4624  0390 263d          	jrne	L5462
4626  0392 725d0002      	tnz	_Test_mode_flag
4627  0396 2637          	jrne	L5462
4628                     ; 367 			T1_Middle_for_ledbuz_EN();//实测95.3ms
4630  0398 8d000000      	callf	f_T1_Middle_for_ledbuz_EN
4632                     ; 369 			if(RSSI_val<RSSI_val_set)//
4634  039c c60000        	ld	a,_RSSI_val
4635  039f a150          	cp	a,#80
4636  03a1 240f          	jruge	L7462
4637                     ; 371 				TX_fuction(30);//9秒左右
4639  03a3 a61e          	ld	a,#30
4640  03a5 8d000000      	callf	f_TX_fuction
4643  03a9               L3562:
4644                     ; 372 				while(RF_work_state==TX_state);
4646  03a9 c60021        	ld	a,_RF_work_state
4647  03ac a133          	cp	a,#51
4648  03ae 27f9          	jreq	L3562
4650  03b0 2007          	jra	L7562
4651  03b2               L7462:
4652                     ; 374 			else delay_ms(9000);
4654  03b2 ae2328        	ldw	x,#9000
4655  03b5 8d000000      	callf	f_delay_ms
4657  03b9               L7562:
4658                     ; 375 			buz_state(OFF);  //关闭蜂鸣器
4660  03b9 a601          	ld	a,#1
4661  03bb 8d000000      	callf	f_buz_state
4663                     ; 376 			T1_for_ledbuz_DIS();//关定时器中断，从而关报警
4665  03bf 8d000000      	callf	f_T1_for_ledbuz_DIS
4667                     ; 377 			red_OFF;  //关闭红灯
4669  03c3 7219500a      	bres	_PC_ODR,#4
4670                     ; 378 			get_msg_alarm=0;
4672  03c7 725f0018      	clr	_get_msg_alarm
4673                     ; 379 			Test_mode_flag=3;
4675  03cb 35030002      	mov	_Test_mode_flag,#3
4676  03cf               L5462:
4677                     ; 382     if((get_msg_alarm==master_test)&&(Test_mode_flag==0))//Test_mode_flag测试过后12S禁止测试                
4679  03cf c60018        	ld	a,_get_msg_alarm
4680  03d2 a1dc          	cp	a,#220
4681  03d4 2635          	jrne	L1662
4683  03d6 725d0002      	tnz	_Test_mode_flag
4684  03da 262f          	jrne	L1662
4685                     ; 385 			T1_Middle_for_ledbuz_EN();
4687  03dc 8d000000      	callf	f_T1_Middle_for_ledbuz_EN
4689                     ; 386 			RAM_read();
4691  03e0 8d000000      	callf	f_RAM_read
4693                     ; 387 			str[2]=alarm_code_test;
4695  03e4 35dd0002      	mov	_str+2,#221
4696                     ; 388 			TX_fuction(30);//9秒左右
4698  03e8 a61e          	ld	a,#30
4699  03ea 8d000000      	callf	f_TX_fuction
4702  03ee               L5662:
4703                     ; 389 			while(RF_work_state==TX_state);
4705  03ee c60021        	ld	a,_RF_work_state
4706  03f1 a133          	cp	a,#51
4707  03f3 27f9          	jreq	L5662
4708                     ; 390 			buz_state(OFF);  //关闭蜂鸣器
4710  03f5 a601          	ld	a,#1
4711  03f7 8d000000      	callf	f_buz_state
4713                     ; 391 			T1_for_ledbuz_DIS();//关定时器中断，从而关报警
4715  03fb 8d000000      	callf	f_T1_for_ledbuz_DIS
4717                     ; 392 			red_OFF;  //关闭红灯
4719  03ff 7219500a      	bres	_PC_ODR,#4
4720                     ; 393 			get_msg_alarm=0;
4722  0403 725f0018      	clr	_get_msg_alarm
4723                     ; 394 			Test_mode_flag=3;
4725  0407 35030002      	mov	_Test_mode_flag,#3
4726  040b               L1662:
4727                     ; 396 		get_msg_alarm=0;//防止接收到上次休眠前的测试信号，而记录给下一次唤醒
4729  040b 725f0018      	clr	_get_msg_alarm
4730                     ; 397 	  keydelay=0;//清除静音产生的按键值 
4732  040f 5f            	clrw	x
4733  0410 cf0015        	ldw	_keydelay,x
4734                     ; 399     CLK_PCKENR1&=~0X01;//不加功耗高？？？？？？？
4736  0413 721150c3      	bres	_CLK_PCKENR1,#0
4737                     ; 400 		IOconfig();
4739  0417 8d000000      	callf	f_IOconfig
4741                     ; 401     sleep();
4743  041b 8d000000      	callf	f_sleep
4745                     ; 402 		_asm("halt"); 
4748  041f 8e            halt
4751  0420 ac1f001f      	jpf	L1342
4785                     ; 406 @far @interrupt void button_interrupt(void)
4785                     ; 407 {
4786                     .text:	section	.text,new
4787  0000               f_button_interrupt:
4789  0000 3b0002        	push	c_x+2
4790  0003 be00          	ldw	x,c_x
4791  0005 89            	pushw	x
4792  0006 3b0002        	push	c_y+2
4793  0009 be00          	ldw	x,c_y
4794  000b 89            	pushw	x
4797                     ; 408   IntDisable;
4800  000c 9b            sim
4802                     ; 409   EXTI_SR1|=0x02;   //清除中断标志
4804  000d 721250a3      	bset	_EXTI_SR1,#1
4805                     ; 411 	RTC_CR2 &=0xfb;     //关RTC定时器唤醒 
4807  0011 72155149      	bres	_RTC_CR2,#2
4808                     ; 412   RTC_CR2 &=0xbf;     //关RTC中断
4810  0015 721d5149      	bres	_RTC_CR2,#6
4811                     ; 414   if((PC_IDR & 0X02)==0X02)
4813  0019 c6500b        	ld	a,_PC_IDR
4814  001c a402          	and	a,#2
4815  001e a102          	cp	a,#2
4816  0020 2704aca900a9  	jrne	L1072
4817                     ; 416     delay_ms(3);
4819  0026 ae0003        	ldw	x,#3
4820  0029 8d000000      	callf	f_delay_ms
4822                     ; 417     if((PC_IDR & 0X02)==0X02) //改成报警后才能进去静音按键操作
4824  002d c6500b        	ld	a,_PC_IDR
4825  0030 a402          	and	a,#2
4826  0032 a102          	cp	a,#2
4827  0034 2673          	jrne	L1072
4828                     ; 419 		  Button_down_flag=1;
4830  0036 35010020      	mov	_Button_down_flag,#1
4831                     ; 421 			if(if_alarm==0) //判断是否从设备
4833  003a 725d0017      	tnz	_if_alarm
4834  003e 2612          	jrne	L5072
4835                     ; 423 				buz_state(OFF);
4837  0040 a601          	ld	a,#1
4838  0042 8d000000      	callf	f_buz_state
4840                     ; 424 				hush_flag=0;
4842  0046 725f001b      	clr	_hush_flag
4843                     ; 426 				str[3]=slave_silence;
4845  004a 35330003      	mov	_str+3,#51
4846                     ; 427 				hush=slave_silence;
4848  004e 35330019      	mov	_hush,#51
4849  0052               L5072:
4850                     ; 429       if(if_alarm==1) //判断是否主设备
4852  0052 c60017        	ld	a,_if_alarm
4853  0055 a101          	cp	a,#1
4854  0057 2647          	jrne	L3172
4855                     ; 431 				buz_state(OFF);
4857  0059 a601          	ld	a,#1
4858  005b 8d000000      	callf	f_buz_state
4860                     ; 432 				hush_flag=0;
4862  005f 725f001b      	clr	_hush_flag
4863                     ; 434 				hush=all_silence;
4865  0063 35660019      	mov	_hush,#102
4866  0067 2037          	jra	L3172
4867  0069               L1172:
4868                     ; 438         delay_ms(10);
4870  0069 ae000a        	ldw	x,#10
4871  006c 8d000000      	callf	f_delay_ms
4873                     ; 439         keydelay++;
4875  0070 ce0015        	ldw	x,_keydelay
4876  0073 1c0001        	addw	x,#1
4877  0076 cf0015        	ldw	_keydelay,x
4878                     ; 441         if((keydelay>250)&&(keydelay%100)==0)//逢100闪
4880  0079 ce0015        	ldw	x,_keydelay
4881  007c a300fb        	cpw	x,#251
4882  007f 251f          	jrult	L3172
4884  0081 ce0015        	ldw	x,_keydelay
4885  0084 90ae0064      	ldw	y,#100
4886  0088 65            	divw	x,y
4887  0089 51            	exgw	x,y
4888  008a a30000        	cpw	x,#0
4889  008d 2611          	jrne	L3172
4890                     ; 443           ledflash(brue,1,20,0);
4892  008f 5f            	clrw	x
4893  0090 89            	pushw	x
4894  0091 ae0014        	ldw	x,#20
4895  0094 89            	pushw	x
4896  0095 ae0001        	ldw	x,#1
4897  0098 89            	pushw	x
4898  0099 4f            	clr	a
4899  009a 8d000000      	callf	f_ledflash
4901  009e 5b06          	addw	sp,#6
4902  00a0               L3172:
4903                     ; 436       while((PC_IDR & 0X02)==0X02)
4905  00a0 c6500b        	ld	a,_PC_IDR
4906  00a3 a402          	and	a,#2
4907  00a5 a102          	cp	a,#2
4908  00a7 27c0          	jreq	L1172
4909  00a9               L1072:
4910                     ; 448   IntEnable;
4913  00a9 9a            rim
4915                     ; 449 }
4918  00aa 85            	popw	x
4919  00ab bf00          	ldw	c_y,x
4920  00ad 320002        	pop	c_y+2
4921  00b0 85            	popw	x
4922  00b1 bf00          	ldw	c_x,x
4923  00b3 320002        	pop	c_x+2
4924  00b6 80            	iret
4951                     ; 451 @far @interrupt void wakeup_interrupt(void)
4951                     ; 452 {
4952                     .text:	section	.text,new
4953  0000               f_wakeup_interrupt:
4957                     ; 453 	RTC_WPR=0xca;       //去RTC寄存器写保护
4959  0000 35ca5159      	mov	_RTC_WPR,#202
4960                     ; 454 	RTC_WPR=0x53;				//去RTC寄存器写保护 
4962  0004 35535159      	mov	_RTC_WPR,#83
4963                     ; 455 	RTC_CR2 &=0xfb;     //关RTC定时器唤醒 
4965  0008 72155149      	bres	_RTC_CR2,#2
4966                     ; 456   RTC_CR2 &=0xbf;     //关RTC中断
4968  000c 721d5149      	bres	_RTC_CR2,#6
4969                     ; 457 	RTC_WPR=0X66;       //写个错key重开写保护
4971  0010 35665159      	mov	_RTC_WPR,#102
4972                     ; 458   RTC_ISR2 &=~0x04;   //关允许访问标志位
4974  0014 7215514d      	bres	_RTC_ISR2,#2
4975                     ; 460 	if(Test_mode_flag>0)Test_mode_flag--;
4977  0018 725d0002      	tnz	_Test_mode_flag
4978  001c 2704          	jreq	L1372
4981  001e 725a0002      	dec	_Test_mode_flag
4982  0022               L1372:
4983                     ; 461   pow_check_time_flag--;
4985  0022 725a001d      	dec	_pow_check_time_flag
4986                     ; 462 }
4989  0026 80            	iret
5019                     ; 464 @far @interrupt void time1_interrupt(void)
5019                     ; 465 {
5020                     .text:	section	.text,new
5021  0000               f_time1_interrupt:
5023  0000 3b0002        	push	c_x+2
5024  0003 be00          	ldw	x,c_x
5025  0005 89            	pushw	x
5026  0006 3b0002        	push	c_y+2
5027  0009 be00          	ldw	x,c_y
5028  000b 89            	pushw	x
5031                     ; 466 	TIM2_SR1&=~0x01;//写0才是清除
5033  000c 72115256      	bres	_TIM2_SR1,#0
5034                     ; 467   red_change();
5036  0010 8d000000      	callf	f_red_change
5038                     ; 468   if( (hush_flag==1)||(get_msg_alarm==alarm_code_test)||(get_msg_alarm==master_test) ) buz_change();//buz=!buz;//非静音模式
5040  0014 c6001b        	ld	a,_hush_flag
5041  0017 a101          	cp	a,#1
5042  0019 270e          	jreq	L5472
5044  001b c60018        	ld	a,_get_msg_alarm
5045  001e a1dd          	cp	a,#221
5046  0020 2707          	jreq	L5472
5048  0022 c60018        	ld	a,_get_msg_alarm
5049  0025 a1dc          	cp	a,#220
5050  0027 2604          	jrne	L3472
5051  0029               L5472:
5054  0029 8d000000      	callf	f_buz_change
5056  002d               L3472:
5057                     ; 469   if(hush_flag==0)
5059  002d 725d001b      	tnz	_hush_flag
5060  0031 263e          	jrne	L1572
5061                     ; 471 	  silence_time++;
5063  0033 ce001e        	ldw	x,_silence_time
5064  0036 1c0001        	addw	x,#1
5065  0039 cf001e        	ldw	_silence_time,x
5066                     ; 472 		if(if_alarm==0) //判断是否从设备
5068  003c 725d0017      	tnz	_if_alarm
5069  0040 2614          	jrne	L3572
5070                     ; 474 	    if(silence_time==4615){ hush_flag=1; hush=all_ring;silence_time=0;}
5072  0042 ce001e        	ldw	x,_silence_time
5073  0045 a31207        	cpw	x,#4615
5074  0048 260c          	jrne	L3572
5077  004a 3501001b      	mov	_hush_flag,#1
5080  004e 35770019      	mov	_hush,#119
5083  0052 5f            	clrw	x
5084  0053 cf001e        	ldw	_silence_time,x
5085  0056               L3572:
5086                     ; 476 		if(if_alarm==1) //判断是否主设备
5088  0056 c60017        	ld	a,_if_alarm
5089  0059 a101          	cp	a,#1
5090  005b 2614          	jrne	L1572
5091                     ; 478 			if(silence_time==6315){ hush_flag=1; hush=all_ring;silence_time=0;}
5093  005d ce001e        	ldw	x,_silence_time
5094  0060 a318ab        	cpw	x,#6315
5095  0063 260c          	jrne	L1572
5098  0065 3501001b      	mov	_hush_flag,#1
5101  0069 35770019      	mov	_hush,#119
5104  006d 5f            	clrw	x
5105  006e cf001e        	ldw	_silence_time,x
5106  0071               L1572:
5107                     ; 481 }
5110  0071 85            	popw	x
5111  0072 bf00          	ldw	c_y,x
5112  0074 320002        	pop	c_y+2
5113  0077 85            	popw	x
5114  0078 bf00          	ldw	c_x,x
5115  007a 320002        	pop	c_x+2
5116  007d 80            	iret
5145                     ; 498 @far @interrupt void GPIO1_interrupt(void)
5145                     ; 499 {
5146                     .text:	section	.text,new
5147  0000               f_GPIO1_interrupt:
5149  0000 3b0002        	push	c_x+2
5150  0003 be00          	ldw	x,c_x
5151  0005 89            	pushw	x
5152  0006 3b0002        	push	c_y+2
5153  0009 be00          	ldw	x,c_y
5154  000b 89            	pushw	x
5157                     ; 500 	if(RF_work_state==TX_state)
5159  000c c60021        	ld	a,_RF_work_state
5160  000f a133          	cp	a,#51
5161  0011 2628          	jrne	L3772
5162                     ; 502 		vSpi3Write(((unsigned int)CMT23_INT_CLR1<<8)+TX_DONE_CLR);	//Clear TX_DONE flag 
5164  0013 ae6a04        	ldw	x,#27140
5165  0016 8d000000      	callf	f_vSpi3Write
5167                     ; 503 		vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TX);		//bGoTx();
5169  001a ae6040        	ldw	x,#24640
5170  001d 8d000000      	callf	f_vSpi3Write
5172                     ; 504 		TX_num_temp++;
5174  0021 725c0022      	inc	_TX_num_temp
5175                     ; 505 		if(TX_num_temp>TX_num)
5177  0025 c60022        	ld	a,_TX_num_temp
5178  0028 c10023        	cp	a,_TX_num
5179  002b 2319          	jrule	L7772
5180                     ; 507 			setup_Rx();//切换，以后删减里面
5182  002d 8d000000      	callf	f_setup_Rx
5184                     ; 508 			bGoSleep();    //进入睡眠
5186  0031 8d000000      	callf	f_bGoSleep
5188                     ; 509 			RF_work_state=Sleep_state;
5190  0035 355a0021      	mov	_RF_work_state,#90
5191  0039 200b          	jra	L7772
5192  003b               L3772:
5193                     ; 512 	else if(RF_work_state==RX_state)
5195  003b c60021        	ld	a,_RF_work_state
5196  003e a155          	cp	a,#85
5197  0040 2604          	jrne	L7772
5198                     ; 514 		RF_work_state=RX_pream_pass;
5200  0042 35aa0021      	mov	_RF_work_state,#170
5201  0046               L7772:
5202                     ; 519 	EXTI_SR1|=0x01;//clear PORTX0 IT flag
5204  0046 721050a3      	bset	_EXTI_SR1,#0
5205                     ; 520 }
5208  004a 85            	popw	x
5209  004b bf00          	ldw	c_y,x
5210  004d 320002        	pop	c_y+2
5211  0050 85            	popw	x
5212  0051 bf00          	ldw	c_x,x
5213  0053 320002        	pop	c_x+2
5214  0056 80            	iret
5403                     	xdef	f_GPIO1_interrupt
5404                     	xdef	f_time1_interrupt
5405                     	xdef	f_wakeup_interrupt
5406                     	xdef	f_button_interrupt
5407                     	xdef	f_main
5408                     	xdef	f_CLK_INIT
5409                     	xdef	_TX_num
5410                     	xdef	_TX_num_temp
5411                     	xdef	_RF_work_state
5412                     	xdef	_Button_down_flag
5413                     	xdef	_silence_time
5414                     	switch	.bss
5415  0000               _i:
5416  0000 0000          	ds.b	2
5417                     	xdef	_i
5418  0002               _Test_mode_flag:
5419  0002 00            	ds.b	1
5420                     	xdef	_Test_mode_flag
5421                     	xdef	_pow_check_time_flag
5422  0003               _p:
5423  0003 0000          	ds.b	2
5424                     	xdef	_p
5425  0005               _q:
5426  0005 0000          	ds.b	2
5427                     	xdef	_q
5428                     	xdef	_hush_change_flag
5429                     	xdef	_hush_key_flag
5430                     	xdef	_hush
5431                     	xdef	_if_alarm
5432                     	xdef	_IR_val
5433                     	xdef	_pow_val_temp
5434                     	xdef	_cal_val_temp
5435                     	xdef	_cal_val
5436                     	xdef	_pow_val
5437                     	xref	f_vSetTxPayloadLength
5438                     	xref	f_vEnableWrFifo
5439                     	xref	f_bIntSrcFlagClr
5440                     	xref	f_bGoSleep
5441                     	xref	f_bGoTx
5442                     	xref	f_vSpi3BurstWriteFIFO
5443                     	xref	f_vSpi3Write
5444                     	xref	f_AD_IR_val
5445                     	xref	f_AD_VDD_val
5446                     	xref	f_ADC_Init
5447                     	xref	f_T1_for_ledbuz_DIS
5448                     	xref	f_T1_Middle_for_ledbuz_EN
5449                     	xref	f_T1_Slow_for_ledbuz_EN
5450                     	xref	f_pow_check
5451                     	xref	f_calibrat
5452                     	xref	f_buz_change
5453                     	xref	f_buz_state
5454                     	xref	f_ledflash
5455                     	xref	f_red_change
5456                     	xref	f_led_state
5457                     	xref	f_IOconfig
5458                     	xref	f_INT_key_Init
5459                     	xref	f_GPIO_INIT
5460                     	xdef	f_Test_Device
5461                     	xref	f_key
5462                     	xref	f_delay
5463                     	xref	f_delay_ms
5464                     	xdef	f_sleep
5465                     	xref	f_check_one
5466                     	xref	f_RF_Receive
5467                     	xref	f_RAM_read
5468                     	xref	f_GET_repeater
5469                     	xref	f_loop_Tx
5470                     	xdef	f_TX_fuction
5471                     	xref	f_setup_Rx
5472                     	xref	f_setup_Tx
5473                     	xref	_RSSI_val
5474                     	xref	_repeater
5475                     	xdef	_get_msg_alarm
5476                     	xdef	_keydelay
5477                     	xdef	_flag_key
5478                     	xref	_getstr
5479                     	xref	_str
5480                     	xdef	_hush_flag
5481  0007               _has_code:
5482  0007 00            	ds.b	1
5483                     	xdef	_has_code
5484                     .const:	section	.text
5485  0000               L7432:
5486  0000 461c4000      	dc.w	17948,16384
5487                     	xref.b	c_lreg
5488                     	xref.b	c_x
5489                     	xref.b	c_y
5509                     	xref	d_fcmp
5510                     	xref	d_ftol
5511                     	xref	d_fmul
5512                     	xref	d_ltor
5513                     	end
