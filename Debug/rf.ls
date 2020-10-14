   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3318                     	switch	.data
3319  0000               _RSSI_val:
3320  0000 00            	dc.b	0
3321  0001               _repeater:
3322  0001 00            	dc.b	0
3353                     ; 19 void randum(void)
3353                     ; 20 {
3354                     .text:	section	.text,new
3355  0000               f_randum:
3359                     ; 24   randum_val1= RTC_SSR;//第一次才会变，需改善
3361  0000 5551580000    	mov	_randum_val1,_RTC_SSR+1
3362                     ; 25 }
3365  0005 87            	retf
3402                     ; 27 char RF_Receive(void)
3402                     ; 28 {
3403                     .text:	section	.text,new
3404  0000               f_RF_Receive:
3406  0000 88            	push	a
3407       00000001      OFST:	set	1
3410                     ; 29 	char PKT_OK=0;
3412  0001 0f01          	clr	(OFST+0,sp)
3413                     ; 30 	RSSI_val=0;
3415  0003 725f0000      	clr	_RSSI_val
3416                     ; 31 	RF_work_state=RX_state;
3418  0007 35550000      	mov	_RF_work_state,#85
3419                     ; 34 	bGoRx();
3421  000b 8d000000      	callf	f_bGoRx
3423                     ; 35 	delay_us(800);//800=697.6 
3425  000f ae0320        	ldw	x,#800
3426  0012 8d000000      	callf	f_delay_us
3428                     ; 37 	if(RF_work_state==RX_pream_pass)
3430  0016 c60000        	ld	a,_RF_work_state
3431  0019 a1aa          	cp	a,#170
3432  001b 260d          	jrne	L5132
3433                     ; 39 		delay_us(1200);// 化简发射后测1.0996ms  实测1100大概才1094   //delay_us(1130);//实测应该是1130  //首8个pream到数据结束       
3435  001d ae04b0        	ldw	x,#1200
3436  0020 8d000000      	callf	f_delay_us
3438                     ; 40 	  PKT_OK=loop_Rx1();
3440  0024 8d000000      	callf	f_loop_Rx1
3442  0028 6b01          	ld	(OFST+0,sp),a
3443  002a               L5132:
3444                     ; 42 	bGoSleep();
3446  002a 8d000000      	callf	f_bGoSleep
3448                     ; 43 	RF_work_state=Sleep_state;
3450  002e 355a0000      	mov	_RF_work_state,#90
3451                     ; 44 	return PKT_OK;
3453  0032 7b01          	ld	a,(OFST+0,sp)
3456  0034 5b01          	addw	sp,#1
3457  0036 87            	retf
3505                     ; 47 char link(void)
3505                     ; 48 {
3506                     .text:	section	.text,new
3507  0000               f_link:
3509  0000 89            	pushw	x
3510       00000002      OFST:	set	2
3513                     ; 50   if(flag_key==2)
3515  0001 c60000        	ld	a,_flag_key
3516  0004 a102          	cp	a,#2
3517  0006 2704          	jreq	L41
3518  0008 acbd00bd      	jpf	L3332
3519  000c               L41:
3520                     ; 52 		RAM_read();
3522  000c 8d000000      	callf	f_RAM_read
3524                     ; 53 		if((has_code==True))  //有码
3526  0010 c60000        	ld	a,_has_code
3527  0013 a101          	cp	a,#1
3528  0015 2618          	jrne	L5332
3529                     ; 55 			ledflash(red,3,20,20);
3531  0017 ae0014        	ldw	x,#20
3532  001a 89            	pushw	x
3533  001b ae0014        	ldw	x,#20
3534  001e 89            	pushw	x
3535  001f ae0003        	ldw	x,#3
3536  0022 89            	pushw	x
3537  0023 a604          	ld	a,#4
3538  0025 8d000000      	callf	f_ledflash
3540  0029 5b06          	addw	sp,#6
3541                     ; 56 			return LINKDONE;  //有码
3543  002b a602          	ld	a,#2
3545  002d 2069          	jra	L21
3546  002f               L5332:
3547                     ; 60 			for(j=0;j<(2600);j++)//for(j=0;j<(randum_val0);j++)   //收  for(j=0;j<(randum_val0/20);j++) 
3549  002f 5f            	clrw	x
3550  0030 1f01          	ldw	(OFST-1,sp),x
3551  0032               L1432:
3552                     ; 62 			  ledflash(red,1,20,20);
3554  0032 ae0014        	ldw	x,#20
3555  0035 89            	pushw	x
3556  0036 ae0014        	ldw	x,#20
3557  0039 89            	pushw	x
3558  003a ae0001        	ldw	x,#1
3559  003d 89            	pushw	x
3560  003e a604          	ld	a,#4
3561  0040 8d000000      	callf	f_ledflash
3563  0044 5b06          	addw	sp,#6
3564                     ; 63 				if( True==RF_Receive() ) //收到
3566  0046 8d000000      	callf	f_RF_Receive
3568  004a a101          	cp	a,#1
3569  004c 264c          	jrne	L7432
3570                     ; 65 					if((getstr[2]==(getstr[0]+0x23))&&((getstr[0]!=0)&&(getstr[1]!=0)))
3572  004e c60002        	ld	a,_getstr+2
3573  0051 5f            	clrw	x
3574  0052 97            	ld	xl,a
3575  0053 c60000        	ld	a,_getstr
3576  0056 905f          	clrw	y
3577  0058 9097          	ld	yl,a
3578  005a 72a90023      	addw	y,#35
3579  005e bf00          	ldw	c_x,x
3580  0060 90b300        	cpw	y,c_x
3581  0063 2635          	jrne	L7432
3583  0065 725d0000      	tnz	_getstr
3584  0069 272f          	jreq	L7432
3586  006b 725d0001      	tnz	_getstr+1
3587  006f 2729          	jreq	L7432
3588                     ; 67 						str[0]=getstr[0];str[1]=getstr[1];  //存储接收的码 
3590  0071 5500000000    	mov	_str,_getstr
3593  0076 5500010001    	mov	_str+1,_getstr+1
3594                     ; 68 						has_code=True;           //标记本设备有码
3596  007b 35010000      	mov	_has_code,#1
3597                     ; 69 						RAM_write();             //码存在RAM
3599  007f 8d000000      	callf	f_RAM_write
3601                     ; 70 						ledflash(brue,3,100,100);    //配对成功 闪灯
3603  0083 ae0064        	ldw	x,#100
3604  0086 89            	pushw	x
3605  0087 ae0064        	ldw	x,#100
3606  008a 89            	pushw	x
3607  008b ae0003        	ldw	x,#3
3608  008e 89            	pushw	x
3609  008f 4f            	clr	a
3610  0090 8d000000      	callf	f_ledflash
3612  0094 5b06          	addw	sp,#6
3613                     ; 71 						return SUCCESS;//n=65534;break;  //退出函数
3615  0096 a601          	ld	a,#1
3617  0098               L21:
3619  0098 85            	popw	x
3620  0099 87            	retf
3621  009a               L7432:
3622                     ; 74 				if(keydelay>1){keydelay=0; break;}
3624  009a ce0000        	ldw	x,_keydelay
3625  009d a30002        	cpw	x,#2
3626  00a0 2506          	jrult	L3532
3629  00a2 5f            	clrw	x
3630  00a3 cf0000        	ldw	_keydelay,x
3633  00a6 2012          	jra	L5432
3634  00a8               L3532:
3635                     ; 60 			for(j=0;j<(2600);j++)//for(j=0;j<(randum_val0);j++)   //收  for(j=0;j<(randum_val0/20);j++) 
3637  00a8 1e01          	ldw	x,(OFST-1,sp)
3638  00aa 1c0001        	addw	x,#1
3639  00ad 1f01          	ldw	(OFST-1,sp),x
3642  00af 1e01          	ldw	x,(OFST-1,sp)
3643  00b1 a30a28        	cpw	x,#2600
3644  00b4 2404ac320032  	jrult	L1432
3645  00ba               L5432:
3646                     ; 76 			return FAIL;  //超时未配对，退出
3648  00ba 4f            	clr	a
3650  00bb 20db          	jra	L21
3651  00bd               L3332:
3652                     ; 79 	if(flag_key==3)
3654  00bd c60000        	ld	a,_flag_key
3655  00c0 a103          	cp	a,#3
3656  00c2 265b          	jrne	L5532
3657                     ; 81 	  hush_flag=0;
3659  00c4 725f0000      	clr	_hush_flag
3660                     ; 82 		T1_Fast_for_ledbuz_EN();
3662  00c8 8d000000      	callf	f_T1_Fast_for_ledbuz_EN
3664                     ; 83 		RAM_read();
3666  00cc 8d000000      	callf	f_RAM_read
3668                     ; 84 		if((has_code!=True))  //无码
3670  00d0 c60000        	ld	a,_has_code
3671  00d3 a101          	cp	a,#1
3672  00d5 2719          	jreq	L7532
3673                     ; 86 			randum();  //自己生成码
3675  00d7 8d000000      	callf	f_randum
3677                     ; 87 			has_code=True;           //标记本设备有码
3679  00db 35010000      	mov	_has_code,#1
3680                     ; 88 			str[0]=randum_val1;str[1]=randum_val1&0xDD; 
3682  00df 5500000000    	mov	_str,_randum_val1
3685  00e4 c60000        	ld	a,_randum_val1
3686  00e7 a4dd          	and	a,#221
3687  00e9 c70001        	ld	_str+1,a
3688                     ; 89 		  RAM_write();             //码存在RAM
3690  00ec 8d000000      	callf	f_RAM_write
3692  00f0               L7532:
3693                     ; 91 		str[2]=str[0]+0x23;
3695  00f0 c60000        	ld	a,_str
3696  00f3 ab23          	add	a,#35
3697  00f5 c70002        	ld	_str+2,a
3698                     ; 92 		TX_fuction(190);//60秒左右
3700  00f8 a6be          	ld	a,#190
3701  00fa 8d000000      	callf	f_TX_fuction
3704  00fe 2016          	jra	L3632
3705  0100               L1632:
3706                     ; 95 		  if(keydelay>1)
3708  0100 ce0000        	ldw	x,_keydelay
3709  0103 a30002        	cpw	x,#2
3710  0106 250e          	jrult	L3632
3711                     ; 97 			  keydelay=0;
3713  0108 5f            	clrw	x
3714  0109 cf0000        	ldw	_keydelay,x
3715                     ; 98 				break;
3716  010c               L5632:
3717                     ; 101 	  T1_for_ledbuz_DIS();//关定时器中断     jia
3719  010c 8d000000      	callf	f_T1_for_ledbuz_DIS
3721                     ; 102 		red_OFF;  //关闭红灯     jia
3723  0110 7219500a      	bres	_PC_ODR,#4
3724  0114 2009          	jra	L5532
3725  0116               L3632:
3726                     ; 93 		while(RF_work_state==TX_state)
3728  0116 c60000        	ld	a,_RF_work_state
3729  0119 a133          	cp	a,#51
3730  011b 27e3          	jreq	L1632
3731  011d 20ed          	jra	L5632
3732  011f               L5532:
3733                     ; 104 }
3736  011f 85            	popw	x
3737  0120 87            	retf
3764                     ; 106 void GET_repeater(void)
3764                     ; 107 {
3765                     .text:	section	.text,new
3766  0000               f_GET_repeater:
3770                     ; 108 	if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
3772  0000 c60000        	ld	a,_RSSI_val
3773  0003 a150          	cp	a,#80
3774  0005 2442          	jruge	L1042
3775                     ; 110 		if( True==RF_Receive() ) 
3777  0007 8d000000      	callf	f_RF_Receive
3779  000b a101          	cp	a,#1
3780  000d 263a          	jrne	L1042
3781                     ; 112 			if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
3783  000f c60000        	ld	a,_getstr
3784  0012 c10000        	cp	a,_str
3785  0015 2632          	jrne	L1042
3787  0017 c60001        	ld	a,_getstr+1
3788  001a c10001        	cp	a,_str+1
3789  001d 262a          	jrne	L1042
3790                     ; 114 				if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
3792  001f c60000        	ld	a,_RSSI_val
3793  0022 a150          	cp	a,#80
3794  0024 2423          	jruge	L1042
3795                     ; 116 					if( True==RF_Receive() ) 
3797  0026 8d000000      	callf	f_RF_Receive
3799  002a a101          	cp	a,#1
3800  002c 261b          	jrne	L1042
3801                     ; 118 						if( (getstr[0]==str[0]) && (getstr[1]==str[1]) )
3803  002e c60000        	ld	a,_getstr
3804  0031 c10000        	cp	a,_str
3805  0034 2613          	jrne	L1042
3807  0036 c60001        	ld	a,_getstr+1
3808  0039 c10001        	cp	a,_str+1
3809  003c 260b          	jrne	L1042
3810                     ; 120 							if(RSSI_val<RSSI_val_set)//桌面到3楼梯中间横梁上
3812  003e c60000        	ld	a,_RSSI_val
3813  0041 a150          	cp	a,#80
3814  0043 2404          	jruge	L1042
3815                     ; 122 								repeater=1;
3817  0045 35010001      	mov	_repeater,#1
3818  0049               L1042:
3819                     ; 130 }
3822  0049 87            	retf
3864                     	xref	_RF_work_state
3865                     	switch	.bss
3866  0000               _randum_val1:
3867  0000 00            	ds.b	1
3868                     	xdef	_randum_val1
3869  0001               _randum_val0:
3870  0001 00            	ds.b	1
3871                     	xdef	_randum_val0
3872                     	xref	f_bGoSleep
3873                     	xref	f_bGoRx
3874                     	xref	f_T1_for_ledbuz_DIS
3875                     	xref	f_T1_Fast_for_ledbuz_EN
3876                     	xref	f_ledflash
3877                     	xdef	f_randum
3878                     	xref	f_delay_us
3879                     	xdef	f_link
3880                     	xdef	f_RF_Receive
3881                     	xref	f_RAM_read
3882                     	xref	f_RAM_write
3883                     	xdef	f_GET_repeater
3884                     	xref	f_loop_Rx1
3885                     	xref	f_TX_fuction
3886                     	xdef	_RSSI_val
3887                     	xdef	_repeater
3888                     	xref	_keydelay
3889                     	xref	_flag_key
3890                     	xref	_getstr
3891                     	xref	_str
3892                     	xref	_hush_flag
3893                     	xref	_has_code
3894                     	xref.b	c_x
3914                     	end
