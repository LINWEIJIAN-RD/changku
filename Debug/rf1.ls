   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3318                     	switch	.data
3319  0000               _CMTBank:
3320  0000 0000          	dc.w	0
3321  0002 0166          	dc.w	358
3322  0004 02ec          	dc.w	748
3323  0006 031c          	dc.w	796
3324  0008 0470          	dc.w	1136
3325  000a 0580          	dc.w	1408
3326  000c 0614          	dc.w	1556
3327  000e 0708          	dc.w	1800
3328  0010 0891          	dc.w	2193
3329  0012 0902          	dc.w	2306
3330  0014 0a02          	dc.w	2562
3331  0016 0bd0          	dc.w	3024
3332  0018               _SystemBank:
3333  0018 0cae          	dc.w	3246
3334  001a 0df0          	dc.w	3568
3335  001c 0e39          	dc.w	3641
3336  001e 0f00          	dc.w	3840
3337  0020 1000          	dc.w	4096
3338  0022 1132          	dc.w	4402
3339  0024 1200          	dc.w	4608
3340  0026 13fa          	dc.w	5114
3341  0028 1400          	dc.w	5120
3342  002a 152b          	dc.w	5419
3343  002c 1620          	dc.w	5664
3344  002e 1701          	dc.w	5889
3345  0030               _FrequencyBank:
3346  0030 1842          	dc.w	6210
3347  0032 1971          	dc.w	6513
3348  0034 1ace          	dc.w	6862
3349  0036 1b1c          	dc.w	6940
3350  0038 1c42          	dc.w	7234
3351  003a 1d5b          	dc.w	7515
3352  003c 1e1c          	dc.w	7708
3353  003e 1f1c          	dc.w	7964
3354  0040               _DataRateBank:
3355  0040 203f          	dc.w	8255
3356  0042 21f0          	dc.w	8688
3357  0044 2263          	dc.w	8803
3358  0046 2310          	dc.w	8976
3359  0048 2463          	dc.w	9315
3360  004a 2512          	dc.w	9490
3361  004c 260b          	dc.w	9739
3362  004e 270a          	dc.w	9994
3363  0050 289f          	dc.w	10399
3364  0052 296c          	dc.w	10604
3365  0054 2a29          	dc.w	10793
3366  0056 2b29          	dc.w	11049
3367  0058 2cc0          	dc.w	11456
3368  005a 2d04          	dc.w	11524
3369  005c 2e01          	dc.w	11777
3370  005e 2f53          	dc.w	12115
3371  0060 3020          	dc.w	12320
3372  0062 3100          	dc.w	12544
3373  0064 32b4          	dc.w	12980
3374  0066 3300          	dc.w	13056
3375  0068 3400          	dc.w	13312
3376  006a 351c          	dc.w	13596
3377  006c 3600          	dc.w	13824
3378  006e 3700          	dc.w	14080
3379  0070               _BasebandBank:
3380  0070 3812          	dc.w	14354
3381  0072 3908          	dc.w	14600
3382  0074 3a00          	dc.w	14848
3383  0076 3baa          	dc.w	15274
3384  0078 3c04          	dc.w	15364
3385  007a 3d00          	dc.w	15616
3386  007c 3e00          	dc.w	15872
3387  007e 3f00          	dc.w	16128
3388  0080 4000          	dc.w	16384
3389  0082 4100          	dc.w	16640
3390  0084 42d4          	dc.w	17108
3391  0086 432d          	dc.w	17197
3392  0088 44d2          	dc.w	17618
3393  008a 4500          	dc.w	17664
3394  008c 4603          	dc.w	17923
3395  008e 4700          	dc.w	18176
3396  0090 4800          	dc.w	18432
3397  0092 4900          	dc.w	18688
3398  0094 4a00          	dc.w	18944
3399  0096 4b00          	dc.w	19200
3400  0098 4c00          	dc.w	19456
3401  009a 4d00          	dc.w	19712
3402  009c 4e00          	dc.w	19968
3403  009e 4f60          	dc.w	20320
3404  00a0 50ff          	dc.w	20735
3405  00a2 5100          	dc.w	20736
3406  00a4 52ff          	dc.w	21247
3407  00a6 5301          	dc.w	21249
3408  00a8 5480          	dc.w	21632
3409  00aa               _TXBank:
3410  00aa 5550          	dc.w	21840
3411  00ac 560e          	dc.w	22030
3412  00ae 5716          	dc.w	22294
3413  00b0 5800          	dc.w	22528
3414  00b2 5900          	dc.w	22784
3415  00b4 5a30          	dc.w	23088
3416  00b6 5b00          	dc.w	23296
3417  00b8 5c8a          	dc.w	23690
3418  00ba 5d18          	dc.w	23832
3419  00bc 5e3f          	dc.w	24127
3420  00be 5f7f          	dc.w	24447
3544                     ; 15 void setup_Tx(void)
3544                     ; 16 {
3545                     .text:	section	.text,new
3546  0000               f_setup_Tx:
3550                     ; 18 	FixedPktLength    = True;				
3552  0000 35010000      	mov	_FixedPktLength,#1
3553                     ; 19 	PayloadLength     = LEN;	
3555  0004 ae0004        	ldw	x,#4
3556  0007 cf0000        	ldw	_PayloadLength,x
3557                     ; 21 	vInit();
3559  000a 8d000000      	callf	f_vInit
3561                     ; 22 	vCfgBank(CMTBank,12);
3563  000e 4b0c          	push	#12
3564  0010 ae0000        	ldw	x,#_CMTBank
3565  0013 8d000000      	callf	f_vCfgBank
3567  0017 84            	pop	a
3568                     ; 23 	vCfgBank(SystemBank,12);
3570  0018 4b0c          	push	#12
3571  001a ae0018        	ldw	x,#_SystemBank
3572  001d 8d000000      	callf	f_vCfgBank
3574  0021 84            	pop	a
3575                     ; 24 	vCfgBank(FrequencyBank, 8);
3577  0022 4b08          	push	#8
3578  0024 ae0030        	ldw	x,#_FrequencyBank
3579  0027 8d000000      	callf	f_vCfgBank
3581  002b 84            	pop	a
3582                     ; 25 	vCfgBank(DataRateBank, 24);
3584  002c 4b18          	push	#24
3585  002e ae0040        	ldw	x,#_DataRateBank
3586  0031 8d000000      	callf	f_vCfgBank
3588  0035 84            	pop	a
3589                     ; 26 	vCfgBank(BasebandBank, 29);
3591  0036 4b1d          	push	#29
3592  0038 ae0070        	ldw	x,#_BasebandBank
3593  003b 8d000000      	callf	f_vCfgBank
3595  003f 84            	pop	a
3596                     ; 27 	vCfgBank(TXBank, 11);
3598  0040 4b0b          	push	#11
3599  0042 ae00aa        	ldw	x,#_TXBank
3600  0045 8d000000      	callf	f_vCfgBank
3602  0049 84            	pop	a
3603                     ; 28 	vEnableAntSwitch(0);  //设置天线切换_IO口切换
3605  004a 4f            	clr	a
3606  004b 8d000000      	callf	f_vEnableAntSwitch
3608                     ; 30   vGpioFuncCfg(GPIO1_INT1+GPIO2_INT2+GPIO3_DOUT+GPIO4_DOUT);//gai
3610  004f a695          	ld	a,#149
3611  0051 8d000000      	callf	f_vGpioFuncCfg
3613                     ; 31 	vIntSrcCfg(INT_TX_DONE, INT_FIFO_NMTY_TX);    //IO口中断的映射????????????????????
3615  0055 ae0010        	ldw	x,#16
3616  0058 a60a          	ld	a,#10
3617  005a 95            	ld	xh,a
3618  005b 8d000000      	callf	f_vIntSrcCfg
3620                     ; 32 	vIntSrcEnable(TX_DONE_EN);           //中断使能        
3622  005f a620          	ld	a,#32
3623  0061 8d000000      	callf	f_vIntSrcEnable
3625                     ; 34 	vClearFIFO();  //清除FIFO
3627  0065 8d000000      	callf	f_vClearFIFO
3629                     ; 35 	bGoSleep();    //进入睡眠
3631  0069 8d000000      	callf	f_bGoSleep
3633                     ; 36 }
3636  006d 87            	retf
3674                     ; 38 void setup_Rx(void)
3674                     ; 39 {
3675                     .text:	section	.text,new
3676  0000               f_setup_Rx:
3680                     ; 40 	FixedPktLength	= True;			   
3682  0000 35010000      	mov	_FixedPktLength,#1
3683                     ; 41 	PayloadLength 	= LEN; 
3685  0004 ae0004        	ldw	x,#4
3686  0007 cf0000        	ldw	_PayloadLength,x
3687                     ; 43 	vInit();
3689  000a 8d000000      	callf	f_vInit
3691                     ; 44 	vCfgBank(CMTBank, 12);
3693  000e 4b0c          	push	#12
3694  0010 ae0000        	ldw	x,#_CMTBank
3695  0013 8d000000      	callf	f_vCfgBank
3697  0017 84            	pop	a
3698                     ; 45 	vCfgBank(SystemBank, 12);
3700  0018 4b0c          	push	#12
3701  001a ae0018        	ldw	x,#_SystemBank
3702  001d 8d000000      	callf	f_vCfgBank
3704  0021 84            	pop	a
3705                     ; 46 	vCfgBank(FrequencyBank, 8);
3707  0022 4b08          	push	#8
3708  0024 ae0030        	ldw	x,#_FrequencyBank
3709  0027 8d000000      	callf	f_vCfgBank
3711  002b 84            	pop	a
3712                     ; 47 	vCfgBank(DataRateBank, 24);
3714  002c 4b18          	push	#24
3715  002e ae0040        	ldw	x,#_DataRateBank
3716  0031 8d000000      	callf	f_vCfgBank
3718  0035 84            	pop	a
3719                     ; 48 	vCfgBank(BasebandBank, 29);
3721  0036 4b1d          	push	#29
3722  0038 ae0070        	ldw	x,#_BasebandBank
3723  003b 8d000000      	callf	f_vCfgBank
3725  003f 84            	pop	a
3726                     ; 49 	vCfgBank(TXBank, 11);
3728  0040 4b0b          	push	#11
3729  0042 ae00aa        	ldw	x,#_TXBank
3730  0045 8d000000      	callf	f_vCfgBank
3732  0049 84            	pop	a
3733                     ; 50 	vEnableAntSwitch(0);
3735  004a 4f            	clr	a
3736  004b 8d000000      	callf	f_vEnableAntSwitch
3738                     ; 52 	vGpioFuncCfg(GPIO1_INT1+GPIO2_INT2+GPIO3_INT2+GPIO4_DOUT);	
3740  004f a6a5          	ld	a,#165
3741  0051 8d000000      	callf	f_vGpioFuncCfg
3743                     ; 53 	vIntSrcCfg(INT_PREAM_PASS , INT_PKT_DONE);
3745  0055 ae0007        	ldw	x,#7
3746  0058 a603          	ld	a,#3
3747  005a 95            	ld	xh,a
3748  005b 8d000000      	callf	f_vIntSrcCfg
3750                     ; 54 	vIntSrcEnable(PKT_DONE_EN+PREAMBLE_PASS_EN);   //中断使能 ，使能后相应flag才能置1//此函数只执行最后一次的操作
3752  005f a611          	ld	a,#17
3753  0061 8d000000      	callf	f_vIntSrcEnable
3755                     ; 55 	vClearFIFO();
3757  0065 8d000000      	callf	f_vClearFIFO
3759                     ; 56 	bGoSleep();
3761  0069 8d000000      	callf	f_bGoSleep
3763                     ; 57 }
3766  006d 87            	retf
3791                     ; 58 void loop_Tx(void)
3791                     ; 59 {
3792                     .text:	section	.text,new
3793  0000               f_loop_Tx:
3797                     ; 61 	bSendMessage(str, LEN);//bGoTx();//jia
3799  0000 4b04          	push	#4
3800  0002 ae0004        	ldw	x,#_str
3801  0005 8d000000      	callf	f_bSendMessage
3803  0009 84            	pop	a
3805  000a               L3632:
3806                     ; 62 	while(GPO3_L());   // 判断GPIO中断 为低等 为高运行下面代码   中断被我关闭了！！！！！！！！！！
3808  000a c6500b        	ld	a,_PC_IDR
3809  000d a501          	bcp	a,#1
3810  000f 27f9          	jreq	L3632
3811  0011               L7632:
3812                     ; 65 	while(1);
3814  0011 20fe          	jra	L7632
3843                     ; 68 char loop_Rx1(void)
3843                     ; 69 {
3844                     .text:	section	.text,new
3845  0000               f_loop_Rx1:
3849                     ; 70 	if((bSpi3Read(CMT23_INT_FLG) & RX_DONE_FLAG )!=0)   //{bIntSrcFlagClr(); ;}   /*///if(GPO3_H())
3851  0000 a66d          	ld	a,#109
3852  0002 8d000000      	callf	f_bSpi3Read
3854  0006 a501          	bcp	a,#1
3855  0008 271f          	jreq	L3042
3856                     ; 73 		RSSI_val=bSpi3Read(CMT23_RSSI_DBM);//加  收RSSI
3858  000a a670          	ld	a,#112
3859  000c 8d000000      	callf	f_bSpi3Read
3861  0010 c70000        	ld	_RSSI_val,a
3862                     ; 74 		bGoStandby();     //锁住fifo，降低功耗?
3864  0013 8d000000      	callf	f_bGoStandby
3866                     ; 75 		bGetMessage(getstr);  //仿真到此能看到getstr收到的数据包 等于 0x48
3868  0017 ae0000        	ldw	x,#_getstr
3869  001a 8d000000      	callf	f_bGetMessage
3871                     ; 76 		bIntSrcFlagClr();
3873  001e 8d000000      	callf	f_bIntSrcFlagClr
3875                     ; 77 		vClearFIFO(); 
3877  0022 8d000000      	callf	f_vClearFIFO
3879                     ; 79 		return 1;
3881  0026 a601          	ld	a,#1
3884  0028 87            	retf
3885  0029               L3042:
3886                     ; 81 	else return 0;
3888  0029 4f            	clr	a
3891  002a 87            	retf
3925                     	xref	_PayloadLength
3926                     	xref	_FixedPktLength
3927                     	xdef	_TXBank
3928                     	xdef	_BasebandBank
3929                     	xdef	_DataRateBank
3930                     	xdef	_FrequencyBank
3931                     	xdef	_SystemBank
3932                     	xdef	_CMTBank
3933                     	xref	f_bSendMessage
3934                     	xref	f_bGetMessage
3935                     	xref	f_vCfgBank
3936                     	xref	f_vInit
3937                     	xref	f_vClearFIFO
3938                     	xref	f_bIntSrcFlagClr
3939                     	xref	f_vIntSrcEnable
3940                     	xref	f_vEnableAntSwitch
3941                     	xref	f_vIntSrcCfg
3942                     	xref	f_vGpioFuncCfg
3943                     	xref	f_bGoStandby
3944                     	xref	f_bGoSleep
3945                     	xref	f_bSpi3Read
3946                     	xdef	f_loop_Rx1
3947                     	xdef	f_loop_Tx
3948                     	xdef	f_setup_Rx
3949                     	xdef	f_setup_Tx
3950                     	xref	_RSSI_val
3951                     	switch	.bss
3952  0000               _getstr:
3953  0000 00000000      	ds.b	4
3954                     	xdef	_getstr
3955  0004               _str:
3956  0004 00000000      	ds.b	4
3957                     	xdef	_str
3977                     	end
