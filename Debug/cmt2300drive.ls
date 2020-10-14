   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3384                     ; 10 Bool bGoTx(void)
3384                     ; 11 {
3385                     .text:	section	.text,new
3386  0000               f_bGoTx:
3388  0000 89            	pushw	x
3389       00000002      OFST:	set	2
3392                     ; 14 	vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TFS);	
3394  0001 ae6020        	ldw	x,#24608
3395  0004 8d000000      	callf	f_vSpi3Write
3397                     ; 15 	for(i=0; i<50; i++)
3399  0008 0f02          	clr	(OFST+0,sp)
3400  000a               L7132:
3401                     ; 17 		tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
3403  000a a661          	ld	a,#97
3404  000c 8d000000      	callf	f_bSpi3Read
3406  0010 a40f          	and	a,#15
3407  0012 6b01          	ld	(OFST-1,sp),a
3408                     ; 18 		if(tmp==MODE_STA_TFS)
3410  0014 7b01          	ld	a,(OFST-1,sp)
3411  0016 a104          	cp	a,#4
3412  0018 2708          	jreq	L3232
3413                     ; 19 			break;
3415                     ; 15 	for(i=0; i<50; i++)
3417  001a 0c02          	inc	(OFST+0,sp)
3420  001c 7b02          	ld	a,(OFST+0,sp)
3421  001e a132          	cp	a,#50
3422  0020 25e8          	jrult	L7132
3423  0022               L3232:
3424                     ; 22 	if(i>=50)
3426  0022 7b02          	ld	a,(OFST+0,sp)
3427  0024 a132          	cp	a,#50
3428  0026 2503          	jrult	L7232
3429                     ; 23 		return(False);
3431  0028 4f            	clr	a
3433  0029 2028          	jra	L6
3434  002b               L7232:
3435                     ; 25 	vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_TX);		
3437  002b ae6040        	ldw	x,#24640
3438  002e 8d000000      	callf	f_vSpi3Write
3440                     ; 26 	for(i=0; i<50; i++)
3442  0032 0f02          	clr	(OFST+0,sp)
3443  0034               L1332:
3444                     ; 28 		tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
3446  0034 a661          	ld	a,#97
3447  0036 8d000000      	callf	f_bSpi3Read
3449  003a a40f          	and	a,#15
3450  003c 6b01          	ld	(OFST-1,sp),a
3451                     ; 29 		if(tmp==MODE_STA_TX)
3453  003e 7b01          	ld	a,(OFST-1,sp)
3454  0040 a106          	cp	a,#6
3455  0042 2708          	jreq	L5332
3456                     ; 30 			break;
3458                     ; 26 	for(i=0; i<50; i++)
3460  0044 0c02          	inc	(OFST+0,sp)
3463  0046 7b02          	ld	a,(OFST+0,sp)
3464  0048 a132          	cp	a,#50
3465  004a 25e8          	jrult	L1332
3466  004c               L5332:
3467                     ; 33 	if(i>=50)
3469  004c 7b02          	ld	a,(OFST+0,sp)
3470  004e a132          	cp	a,#50
3471  0050 2503          	jrult	L1432
3472                     ; 34 		return(False);
3474  0052 4f            	clr	a
3476  0053               L6:
3478  0053 85            	popw	x
3479  0054 87            	retf
3480  0055               L1432:
3481                     ; 36 		return(True);
3483  0055 a601          	ld	a,#1
3485  0057 20fa          	jra	L6
3508                     ; 46 unsigned char vReadIngFlag1(void)
3508                     ; 47 {
3509                     .text:	section	.text,new
3510  0000               f_vReadIngFlag1:
3514                     ; 48 	return(bSpi3Read((unsigned char)(CMT23_INT_FLG>>8)));
3516  0000 4f            	clr	a
3517  0001 8d000000      	callf	f_bSpi3Read
3521  0005 87            	retf
3544                     ; 52 unsigned char vReadIngFlag2(void)
3544                     ; 53 {
3545                     .text:	section	.text,new
3546  0000               f_vReadIngFlag2:
3550                     ; 54 	return(bSpi3Read((unsigned char)(CMT23_INT_CLR1	>>8)));
3552  0000 4f            	clr	a
3553  0001 8d000000      	callf	f_bSpi3Read
3557  0005 87            	retf
3600                     ; 59 Bool bGoRx(void)//1.27ms
3600                     ; 60 {
3601                     .text:	section	.text,new
3602  0000               f_bGoRx:
3604  0000 89            	pushw	x
3605       00000002      OFST:	set	2
3608                     ; 62  RssiTrig = False;
3610  0001 725f0000      	clr	_RssiTrig
3611                     ; 63  vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_RFS);	
3613  0005 ae6004        	ldw	x,#24580
3614  0008 8d000000      	callf	f_vSpi3Write
3616                     ; 64  for(i=0; i<50; i++)
3618  000c 0f02          	clr	(OFST+0,sp)
3619  000e               L3042:
3620                     ; 66  	delay_us(200);	
3622  000e ae00c8        	ldw	x,#200
3623  0011 8d000000      	callf	f_delay_us
3625                     ; 67 	tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
3627  0015 a661          	ld	a,#97
3628  0017 8d000000      	callf	f_bSpi3Read
3630  001b a40f          	and	a,#15
3631  001d 6b01          	ld	(OFST-1,sp),a
3632                     ; 68 	if(tmp==MODE_STA_RFS)
3634  001f 7b01          	ld	a,(OFST-1,sp)
3635  0021 a103          	cp	a,#3
3636  0023 2708          	jreq	L7042
3637                     ; 69 		break;
3639                     ; 64  for(i=0; i<50; i++)
3641  0025 0c02          	inc	(OFST+0,sp)
3644  0027 7b02          	ld	a,(OFST+0,sp)
3645  0029 a132          	cp	a,#50
3646  002b 25e1          	jrult	L3042
3647  002d               L7042:
3648                     ; 71  if(i>=50)
3650  002d 7b02          	ld	a,(OFST+0,sp)
3651  002f a132          	cp	a,#50
3652  0031 2503          	jrult	L3142
3653                     ; 72  	return(False);
3655  0033 4f            	clr	a
3657  0034 202f          	jra	L61
3658  0036               L3142:
3659                     ; 74  vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_RX);		
3661  0036 ae6008        	ldw	x,#24584
3662  0039 8d000000      	callf	f_vSpi3Write
3664                     ; 75  for(i=0; i<50; i++)
3666  003d 0f02          	clr	(OFST+0,sp)
3667  003f               L5142:
3668                     ; 77  	delay_us(200);	
3670  003f ae00c8        	ldw	x,#200
3671  0042 8d000000      	callf	f_delay_us
3673                     ; 78 	tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
3675  0046 a661          	ld	a,#97
3676  0048 8d000000      	callf	f_bSpi3Read
3678  004c a40f          	and	a,#15
3679  004e 6b01          	ld	(OFST-1,sp),a
3680                     ; 79 	if(tmp==MODE_STA_RX)
3682  0050 7b01          	ld	a,(OFST-1,sp)
3683  0052 a105          	cp	a,#5
3684  0054 2708          	jreq	L1242
3685                     ; 80 		break;
3687                     ; 75  for(i=0; i<50; i++)
3689  0056 0c02          	inc	(OFST+0,sp)
3692  0058 7b02          	ld	a,(OFST+0,sp)
3693  005a a132          	cp	a,#50
3694  005c 25e1          	jrult	L5142
3695  005e               L1242:
3696                     ; 82  if(i>=50)
3698  005e 7b02          	ld	a,(OFST+0,sp)
3699  0060 a132          	cp	a,#50
3700  0062 2503          	jrult	L5242
3701                     ; 83  	return(False);
3703  0064 4f            	clr	a
3705  0065               L61:
3707  0065 85            	popw	x
3708  0066 87            	retf
3709  0067               L5242:
3710                     ; 85  	return(True);
3712  0067 a601          	ld	a,#1
3714  0069 20fa          	jra	L61
3748                     ; 94 Bool bGoSleep(void)
3748                     ; 95 {
3749                     .text:	section	.text,new
3750  0000               f_bGoSleep:
3752  0000 88            	push	a
3753       00000001      OFST:	set	1
3756                     ; 98  vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_SLEEP);	
3758  0001 ae6010        	ldw	x,#24592
3759  0004 8d000000      	callf	f_vSpi3Write
3761                     ; 100  tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
3763  0008 a661          	ld	a,#97
3764  000a 8d000000      	callf	f_bSpi3Read
3766  000e a40f          	and	a,#15
3767  0010 6b01          	ld	(OFST+0,sp),a
3768                     ; 101  if(tmp==MODE_STA_SLEEP)
3770  0012 7b01          	ld	a,(OFST+0,sp)
3771  0014 a101          	cp	a,#1
3772  0016 2605          	jrne	L5442
3773                     ; 102  	return(True);
3775  0018 a601          	ld	a,#1
3778  001a 5b01          	addw	sp,#1
3779  001c 87            	retf
3780  001d               L5442:
3781                     ; 104  	return(False);
3783  001d 4f            	clr	a
3786  001e 5b01          	addw	sp,#1
3787  0020 87            	retf
3830                     ; 113 Bool bGoStandby(void)
3830                     ; 114 {
3831                     .text:	section	.text,new
3832  0000               f_bGoStandby:
3834  0000 89            	pushw	x
3835       00000002      OFST:	set	2
3838                     ; 117  RssiTrig = False;
3840  0001 725f0000      	clr	_RssiTrig
3841                     ; 118  vSpi3Write(((unsigned int)CMT23_MODE_CTL<<8)+MODE_GO_STBY);	
3843  0005 ae6002        	ldw	x,#24578
3844  0008 8d000000      	callf	f_vSpi3Write
3846                     ; 119  for(i=0; i<50; i++)
3848  000c 0f02          	clr	(OFST+0,sp)
3849  000e               L7642:
3850                     ; 121  	delay_us(400);	
3852  000e ae0190        	ldw	x,#400
3853  0011 8d000000      	callf	f_delay_us
3855                     ; 122 	tmp = (MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));	
3857  0015 a661          	ld	a,#97
3858  0017 8d000000      	callf	f_bSpi3Read
3860  001b a40f          	and	a,#15
3861  001d 6b01          	ld	(OFST-1,sp),a
3862                     ; 123 	if(tmp==MODE_STA_STBY)
3864  001f 7b01          	ld	a,(OFST-1,sp)
3865  0021 a102          	cp	a,#2
3866  0023 2708          	jreq	L3742
3867                     ; 124 		break;
3869                     ; 119  for(i=0; i<50; i++)
3871  0025 0c02          	inc	(OFST+0,sp)
3874  0027 7b02          	ld	a,(OFST+0,sp)
3875  0029 a132          	cp	a,#50
3876  002b 25e1          	jrult	L7642
3877  002d               L3742:
3878                     ; 126  if(i>=50)
3880  002d 7b02          	ld	a,(OFST+0,sp)
3881  002f a132          	cp	a,#50
3882  0031 2503          	jrult	L7742
3883                     ; 127  	return(False);
3885  0033 4f            	clr	a
3887  0034 2002          	jra	L42
3888  0036               L7742:
3889                     ; 129  	return(True);
3891  0036 a601          	ld	a,#1
3893  0038               L42:
3895  0038 85            	popw	x
3896  0039 87            	retf
3920                     ; 138 void vSoftReset(void)
3920                     ; 139 {
3921                     .text:	section	.text,new
3922  0000               f_vSoftReset:
3926                     ; 140  vSpi3Write(((unsigned int)CMT23_SOFTRST<<8)+0xFF); 
3928  0000 ae7fff        	ldw	x,#32767
3929  0003 8d000000      	callf	f_vSpi3Write
3931                     ; 141  delay_us(1000);				//enough?
3933  0007 ae03e8        	ldw	x,#1000
3934  000a 8d000000      	callf	f_delay_us
3936                     ; 142 }
3939  000e 87            	retf
3962                     ; 150 unsigned char bReadStatus(void)
3962                     ; 151 {
3963                     .text:	section	.text,new
3964  0000               f_bReadStatus:
3968                     ; 152  return(MODE_MASK_STA & bSpi3Read(CMT23_MODE_STA));		
3970  0000 a661          	ld	a,#97
3971  0002 8d000000      	callf	f_bSpi3Read
3973  0006 a40f          	and	a,#15
3976  0008 87            	retf
4011                     ; 162 unsigned char bReadRssi(Bool unit_dbm)
4011                     ; 163 {
4012                     .text:	section	.text,new
4013  0000               f_bReadRssi:
4017                     ; 164  if(unit_dbm)
4019  0000 4d            	tnz	a
4020  0001 2707          	jreq	L1452
4021                     ; 165  	return(bSpi3Read(CMT23_RSSI_DBM));
4023  0003 a670          	ld	a,#112
4024  0005 8d000000      	callf	f_bSpi3Read
4028  0009 87            	retf
4029  000a               L1452:
4030                     ; 167  	return(bSpi3Read(CMT23_RSSI_CODE));
4032  000a a66f          	ld	a,#111
4033  000c 8d000000      	callf	f_bSpi3Read
4037  0010 87            	retf
4069                     ; 179 void vGpioFuncCfg(unsigned char io_cfg)
4069                     ; 180 {
4070                     .text:	section	.text,new
4071  0000               f_vGpioFuncCfg:
4075                     ; 181  vSpi3Write(((unsigned int)CMT23_IO_SEL<<8)+io_cfg);
4077  0000 5f            	clrw	x
4078  0001 97            	ld	xl,a
4079  0002 1c6500        	addw	x,#25856
4080  0005 8d000000      	callf	f_vSpi3Write
4082                     ; 182 }
4085  0009 87            	retf
4132                     ; 190 void vIntSrcCfg(unsigned char int_1, unsigned char int_2)
4132                     ; 191 {
4133                     .text:	section	.text,new
4134  0000               f_vIntSrcCfg:
4136  0000 89            	pushw	x
4137  0001 88            	push	a
4138       00000001      OFST:	set	1
4141                     ; 193  tmp = INT_MASK & bSpi3Read(CMT23_INT1_CTL);
4143  0002 a666          	ld	a,#102
4144  0004 8d000000      	callf	f_bSpi3Read
4146  0008 a4e0          	and	a,#224
4147  000a 6b01          	ld	(OFST+0,sp),a
4148                     ; 194  vSpi3Write(((unsigned int)CMT23_INT1_CTL<<8)+(tmp|int_1));
4150  000c 7b01          	ld	a,(OFST+0,sp)
4151  000e 1a02          	or	a,(OFST+1,sp)
4152  0010 5f            	clrw	x
4153  0011 97            	ld	xl,a
4154  0012 1c6600        	addw	x,#26112
4155  0015 8d000000      	callf	f_vSpi3Write
4157                     ; 196  tmp = INT_MASK & bSpi3Read(CMT23_INT2_CTL);
4159  0019 a667          	ld	a,#103
4160  001b 8d000000      	callf	f_bSpi3Read
4162  001f a4e0          	and	a,#224
4163  0021 6b01          	ld	(OFST+0,sp),a
4164                     ; 197  vSpi3Write(((unsigned int)CMT23_INT2_CTL<<8)+(tmp|int_2));
4166  0023 7b01          	ld	a,(OFST+0,sp)
4167  0025 1a03          	or	a,(OFST+2,sp)
4168  0027 5f            	clrw	x
4169  0028 97            	ld	xl,a
4170  0029 1c6700        	addw	x,#26368
4171  002c 8d000000      	callf	f_vSpi3Write
4173                     ; 198 }
4176  0030 5b03          	addw	sp,#3
4177  0032 87            	retf
4217                     ; 206 void vEnableAntSwitch(unsigned char mode)
4217                     ; 207 {
4218                     .text:	section	.text,new
4219  0000               f_vEnableAntSwitch:
4221  0000 88            	push	a
4222  0001 88            	push	a
4223       00000001      OFST:	set	1
4226                     ; 209  tmp = bSpi3Read(CMT23_INT1_CTL);
4228  0002 a666          	ld	a,#102
4229  0004 8d000000      	callf	f_bSpi3Read
4231  0008 6b01          	ld	(OFST+0,sp),a
4232                     ; 210  tmp&= 0x3F;
4234  000a 7b01          	ld	a,(OFST+0,sp)
4235  000c a43f          	and	a,#63
4236  000e 6b01          	ld	(OFST+0,sp),a
4237                     ; 211  switch(mode)
4239  0010 7b02          	ld	a,(OFST+1,sp)
4241                     ; 217  	case 0:
4241                     ; 218  	default:
4241                     ; 219  		break;							//Disable	
4242  0012 4a            	dec	a
4243  0013 2705          	jreq	L1062
4244  0015 4a            	dec	a
4245  0016 270a          	jreq	L3062
4246  0018 200e          	jra	L7262
4247  001a               L1062:
4248                     ; 213  	case 1:
4248                     ; 214  		tmp |= RF_SWT1_EN; break;		//GPO1=RxActive; GPO2=TxActive	
4250  001a 7b01          	ld	a,(OFST+0,sp)
4251  001c aa80          	or	a,#128
4252  001e 6b01          	ld	(OFST+0,sp),a
4255  0020 2006          	jra	L7262
4256  0022               L3062:
4257                     ; 215  	case 2:
4257                     ; 216  		tmp |= RF_SWT2_EN; break;		//GPO1=RxActive; GPO2=!RxActive
4259  0022 7b01          	ld	a,(OFST+0,sp)
4260  0024 aa40          	or	a,#64
4261  0026 6b01          	ld	(OFST+0,sp),a
4264  0028               L5062:
4265                     ; 217  	case 0:
4265                     ; 218  	default:
4265                     ; 219  		break;							//Disable	
4267  0028               L7262:
4268                     ; 221  vSpi3Write(((unsigned int)CMT23_INT1_CTL<<8)+tmp);
4270  0028 7b01          	ld	a,(OFST+0,sp)
4271  002a 5f            	clrw	x
4272  002b 97            	ld	xl,a
4273  002c 1c6600        	addw	x,#26112
4274  002f 8d000000      	callf	f_vSpi3Write
4276                     ; 222 }
4279  0033 85            	popw	x
4280  0034 87            	retf
4312                     ; 231 void vIntSrcEnable(unsigned char en_int)
4312                     ; 232 {
4313                     .text:	section	.text,new
4314  0000               f_vIntSrcEnable:
4318                     ; 233  vSpi3Write(((unsigned int)CMT23_INT_EN<<8)+en_int);				
4320  0000 5f            	clrw	x
4321  0001 97            	ld	xl,a
4322  0002 1c6800        	addw	x,#26624
4323  0005 8d000000      	callf	f_vSpi3Write
4325                     ; 234 }
4328  0009 87            	retf
4382                     ; 242 unsigned char bIntSrcFlagClr(void)
4382                     ; 243 {
4383                     .text:	section	.text,new
4384  0000               f_bIntSrcFlagClr:
4386  0000 5204          	subw	sp,#4
4387       00000004      OFST:	set	4
4390                     ; 245  unsigned char int_clr2 = 0;
4392  0002 0f02          	clr	(OFST-2,sp)
4393                     ; 246  unsigned char int_clr1 = 0;
4395  0004 0f01          	clr	(OFST-3,sp)
4396                     ; 247  unsigned char flg = 0;
4398  0006 0f03          	clr	(OFST-1,sp)
4399                     ; 249  tmp = bSpi3Read(CMT23_INT_FLG);
4401  0008 a66d          	ld	a,#109
4402  000a 8d000000      	callf	f_bSpi3Read
4404  000e 6b04          	ld	(OFST+0,sp),a
4405                     ; 250  if(tmp&LBD_STATUS_FLAG)		//LBD_FLG_Active
4407  0010 7b04          	ld	a,(OFST+0,sp)
4408  0012 a580          	bcp	a,#128
4409  0014 2706          	jreq	L7662
4410                     ; 251  	int_clr2 |= LBD_CLR;
4412  0016 7b02          	ld	a,(OFST-2,sp)
4413  0018 aa20          	or	a,#32
4414  001a 6b02          	ld	(OFST-2,sp),a
4415  001c               L7662:
4416                     ; 253  if(tmp&PREAMBLE_PASS_FLAG)		//Preamble Active
4418  001c 7b04          	ld	a,(OFST+0,sp)
4419  001e a510          	bcp	a,#16
4420  0020 270c          	jreq	L1762
4421                     ; 255  	int_clr2 |= PREAMBLE_PASS_CLR;
4423  0022 7b02          	ld	a,(OFST-2,sp)
4424  0024 aa10          	or	a,#16
4425  0026 6b02          	ld	(OFST-2,sp),a
4426                     ; 256  	flg |= PREAMBLE_PASS_EN;
4428  0028 7b03          	ld	a,(OFST-1,sp)
4429  002a aa10          	or	a,#16
4430  002c 6b03          	ld	(OFST-1,sp),a
4431  002e               L1762:
4432                     ; 258  if(tmp&SYNC_PASS_FLAG)			//Sync Active
4434  002e 7b04          	ld	a,(OFST+0,sp)
4435  0030 a508          	bcp	a,#8
4436  0032 270c          	jreq	L3762
4437                     ; 260  	int_clr2 |= SYNC_PASS_CLR;		
4439  0034 7b02          	ld	a,(OFST-2,sp)
4440  0036 aa08          	or	a,#8
4441  0038 6b02          	ld	(OFST-2,sp),a
4442                     ; 261  	flg |= SYNC_PASS_EN;		
4444  003a 7b03          	ld	a,(OFST-1,sp)
4445  003c aa08          	or	a,#8
4446  003e 6b03          	ld	(OFST-1,sp),a
4447  0040               L3762:
4448                     ; 263  if(tmp&NODE_PASS_FLAG)			//Node Addr Active
4450  0040 7b04          	ld	a,(OFST+0,sp)
4451  0042 a504          	bcp	a,#4
4452  0044 270c          	jreq	L5762
4453                     ; 265  	int_clr2 |= NODE_PASS_CLR;	
4455  0046 7b02          	ld	a,(OFST-2,sp)
4456  0048 aa04          	or	a,#4
4457  004a 6b02          	ld	(OFST-2,sp),a
4458                     ; 266  	flg |= NODE_PASS_EN;
4460  004c 7b03          	ld	a,(OFST-1,sp)
4461  004e aa04          	or	a,#4
4462  0050 6b03          	ld	(OFST-1,sp),a
4463  0052               L5762:
4464                     ; 268  if(tmp&CRC_PASS_FLAG)			//Crc Pass Active
4466  0052 7b04          	ld	a,(OFST+0,sp)
4467  0054 a502          	bcp	a,#2
4468  0056 270c          	jreq	L7762
4469                     ; 270  	int_clr2 |= CRC_PASS_CLR;
4471  0058 7b02          	ld	a,(OFST-2,sp)
4472  005a aa02          	or	a,#2
4473  005c 6b02          	ld	(OFST-2,sp),a
4474                     ; 271  	flg |= CRC_PASS_EN;
4476  005e 7b03          	ld	a,(OFST-1,sp)
4477  0060 aa02          	or	a,#2
4478  0062 6b03          	ld	(OFST-1,sp),a
4479  0064               L7762:
4480                     ; 273  if(tmp&RX_DONE_FLAG)			//Rx Done Active
4482  0064 7b04          	ld	a,(OFST+0,sp)
4483  0066 a501          	bcp	a,#1
4484  0068 270c          	jreq	L1072
4485                     ; 275  	int_clr2 |= RX_DONE_CLR;
4487  006a 7b02          	ld	a,(OFST-2,sp)
4488  006c aa01          	or	a,#1
4489  006e 6b02          	ld	(OFST-2,sp),a
4490                     ; 276  	flg |= PKT_DONE_EN;
4492  0070 7b03          	ld	a,(OFST-1,sp)
4493  0072 aa01          	or	a,#1
4494  0074 6b03          	ld	(OFST-1,sp),a
4495  0076               L1072:
4496                     ; 279  if(tmp&COLLISION_ERR_FLAG)		//这两个都必须通过RX_DONE清除
4498  0076 7b04          	ld	a,(OFST+0,sp)
4499  0078 a540          	bcp	a,#64
4500  007a 2706          	jreq	L3072
4501                     ; 280  	int_clr2 |= RX_DONE_CLR;
4503  007c 7b02          	ld	a,(OFST-2,sp)
4504  007e aa01          	or	a,#1
4505  0080 6b02          	ld	(OFST-2,sp),a
4506  0082               L3072:
4507                     ; 281  if(tmp&DC_ERR_FLAG)
4509  0082 7b04          	ld	a,(OFST+0,sp)
4510  0084 a520          	bcp	a,#32
4511  0086 2706          	jreq	L5072
4512                     ; 282  	int_clr2 |= RX_DONE_CLR;
4514  0088 7b02          	ld	a,(OFST-2,sp)
4515  008a aa01          	or	a,#1
4516  008c 6b02          	ld	(OFST-2,sp),a
4517  008e               L5072:
4518                     ; 284  vSpi3Write(((unsigned int)CMT23_INT_CLR2<<8)+int_clr2);	//Clear flag
4520  008e 7b02          	ld	a,(OFST-2,sp)
4521  0090 5f            	clrw	x
4522  0091 97            	ld	xl,a
4523  0092 1c6b00        	addw	x,#27392
4524  0095 8d000000      	callf	f_vSpi3Write
4526                     ; 287  tmp = bSpi3Read(CMT23_INT_CLR1);
4528  0099 a66a          	ld	a,#106
4529  009b 8d000000      	callf	f_bSpi3Read
4531  009f 6b04          	ld	(OFST+0,sp),a
4532                     ; 288  if(tmp&TX_DONE_FLAG)
4534  00a1 7b04          	ld	a,(OFST+0,sp)
4535  00a3 a508          	bcp	a,#8
4536  00a5 270c          	jreq	L7072
4537                     ; 290  	int_clr1 |= TX_DONE_CLR;
4539  00a7 7b01          	ld	a,(OFST-3,sp)
4540  00a9 aa04          	or	a,#4
4541  00ab 6b01          	ld	(OFST-3,sp),a
4542                     ; 291  	flg |= TX_DONE_EN;
4544  00ad 7b03          	ld	a,(OFST-1,sp)
4545  00af aa20          	or	a,#32
4546  00b1 6b03          	ld	(OFST-1,sp),a
4547  00b3               L7072:
4548                     ; 293  if(tmp&SLEEP_TIMEOUT_FLAG)
4550  00b3 7b04          	ld	a,(OFST+0,sp)
4551  00b5 a520          	bcp	a,#32
4552  00b7 270c          	jreq	L1172
4553                     ; 295  	int_clr1 |= SLEEP_TIMEOUT_CLR;
4555  00b9 7b01          	ld	a,(OFST-3,sp)
4556  00bb aa02          	or	a,#2
4557  00bd 6b01          	ld	(OFST-3,sp),a
4558                     ; 296  	flg |= SLEEP_TMO_EN;
4560  00bf 7b03          	ld	a,(OFST-1,sp)
4561  00c1 aa80          	or	a,#128
4562  00c3 6b03          	ld	(OFST-1,sp),a
4563  00c5               L1172:
4564                     ; 298  if(tmp&RX_TIMEOUT_FLAG)
4566  00c5 7b04          	ld	a,(OFST+0,sp)
4567  00c7 a510          	bcp	a,#16
4568  00c9 270c          	jreq	L3172
4569                     ; 300  	int_clr1 |= RX_TIMEOUT_CLR;
4571  00cb 7b01          	ld	a,(OFST-3,sp)
4572  00cd aa01          	or	a,#1
4573  00cf 6b01          	ld	(OFST-3,sp),a
4574                     ; 301  	flg |= RX_TMO_EN;
4576  00d1 7b03          	ld	a,(OFST-1,sp)
4577  00d3 aa40          	or	a,#64
4578  00d5 6b03          	ld	(OFST-1,sp),a
4579  00d7               L3172:
4580                     ; 303  vSpi3Write(((unsigned int)CMT23_INT_CLR1<<8)+int_clr1);	//Clear flag 
4582  00d7 7b01          	ld	a,(OFST-3,sp)
4583  00d9 5f            	clrw	x
4584  00da 97            	ld	xl,a
4585  00db 1c6a00        	addw	x,#27136
4586  00de 8d000000      	callf	f_vSpi3Write
4588                     ; 305  return(flg);
4590  00e2 7b03          	ld	a,(OFST-1,sp)
4593  00e4 5b04          	addw	sp,#4
4594  00e6 87            	retf
4627                     ; 314 unsigned char vClearFIFO(void)
4627                     ; 315 {
4628                     .text:	section	.text,new
4629  0000               f_vClearFIFO:
4631  0000 88            	push	a
4632       00000001      OFST:	set	1
4635                     ; 317  tmp = bSpi3Read(CMT23_FIFO_FLG);
4637  0001 a66e          	ld	a,#110
4638  0003 8d000000      	callf	f_bSpi3Read
4640  0007 6b01          	ld	(OFST+0,sp),a
4641                     ; 318  vSpi3Write(((unsigned int)CMT23_FIFO_CLR<<8)+FIFO_CLR_RX+FIFO_CLR_TX);
4643  0009 ae6c03        	ldw	x,#27651
4644  000c 8d000000      	callf	f_vSpi3Write
4646                     ; 319  return(tmp);
4648  0010 7b01          	ld	a,(OFST+0,sp)
4651  0012 5b01          	addw	sp,#1
4652  0014 87            	retf
4685                     ; 322 void vEnableWrFifo(void)
4685                     ; 323 {
4686                     .text:	section	.text,new
4687  0000               f_vEnableWrFifo:
4689  0000 88            	push	a
4690       00000001      OFST:	set	1
4693                     ; 325  tmp = bSpi3Read(CMT23_FIFO_CTL);
4695  0001 a669          	ld	a,#105
4696  0003 8d000000      	callf	f_bSpi3Read
4698  0007 6b01          	ld	(OFST+0,sp),a
4699                     ; 326  tmp |= (SPI_FIFO_RD_WR_SEL|FIFO_RX_TX_SEL);
4701  0009 7b01          	ld	a,(OFST+0,sp)
4702  000b aa05          	or	a,#5
4703  000d 6b01          	ld	(OFST+0,sp),a
4704                     ; 327  vSpi3Write(((unsigned int)CMT23_FIFO_CTL<<8)+tmp);
4706  000f 7b01          	ld	a,(OFST+0,sp)
4707  0011 5f            	clrw	x
4708  0012 97            	ld	xl,a
4709  0013 1c6900        	addw	x,#26880
4710  0016 8d000000      	callf	f_vSpi3Write
4712                     ; 328 }
4715  001a 84            	pop	a
4716  001b 87            	retf
4749                     ; 330 void vEnableRdFifo(void)
4749                     ; 331 {
4750                     .text:	section	.text,new
4751  0000               f_vEnableRdFifo:
4753  0000 88            	push	a
4754       00000001      OFST:	set	1
4757                     ; 333  tmp = bSpi3Read(CMT23_FIFO_CTL);
4759  0001 a669          	ld	a,#105
4760  0003 8d000000      	callf	f_bSpi3Read
4762  0007 6b01          	ld	(OFST+0,sp),a
4763                     ; 334  tmp &= (~(SPI_FIFO_RD_WR_SEL|FIFO_RX_TX_SEL));
4765  0009 7b01          	ld	a,(OFST+0,sp)
4766  000b a4fa          	and	a,#250
4767  000d 6b01          	ld	(OFST+0,sp),a
4768                     ; 335  vSpi3Write(((unsigned int)CMT23_FIFO_CTL<<8)+tmp);
4770  000f 7b01          	ld	a,(OFST+0,sp)
4771  0011 5f            	clrw	x
4772  0012 97            	ld	xl,a
4773  0013 1c6900        	addw	x,#26880
4774  0016 8d000000      	callf	f_vSpi3Write
4776                     ; 336 }
4779  001a 84            	pop	a
4780  001b 87            	retf
4827                     ; 347 void vInit(void)
4827                     ; 348 {
4828                     .text:	section	.text,new
4829  0000               f_vInit:
4831  0000 88            	push	a
4832       00000001      OFST:	set	1
4835                     ; 354  vSpi3Init();
4837  0001 8d000000      	callf	f_vSpi3Init
4839                     ; 361  vSoftReset();
4841  0005 8d000000      	callf	f_vSoftReset
4843                     ; 363 tmp1 = bGoStandby();
4845  0009 8d000000      	callf	f_bGoStandby
4847  000d 6b01          	ld	(OFST+0,sp),a
4848                     ; 364 if(tmp1 == False)
4850  000f 0d01          	tnz	(OFST+0,sp)
4851  0011 2602          	jrne	L1003
4852  0013               L3003:
4853                     ; 366 	while(1);
4855  0013 20fe          	jra	L3003
4856  0015               L1003:
4857                     ; 369  tmp = bSpi3Read(CMT23_MODE_STA);
4859  0015 a661          	ld	a,#97
4860  0017 8d000000      	callf	f_bSpi3Read
4862  001b 6b01          	ld	(OFST+0,sp),a
4863                     ; 370  tmp|= EEP_CPY_DIS;
4865  001d 7b01          	ld	a,(OFST+0,sp)
4866  001f aa10          	or	a,#16
4867  0021 6b01          	ld	(OFST+0,sp),a
4868                     ; 371  tmp&= (~RSTN_IN_EN);			//Disable RstPin	
4870  0023 7b01          	ld	a,(OFST+0,sp)
4871  0025 a4df          	and	a,#223
4872  0027 6b01          	ld	(OFST+0,sp),a
4873                     ; 372  vSpi3Write(((unsigned int)CMT23_MODE_STA<<8)+tmp);
4875  0029 7b01          	ld	a,(OFST+0,sp)
4876  002b 5f            	clrw	x
4877  002c 97            	ld	xl,a
4878  002d 1c6100        	addw	x,#24832
4879  0030 8d000000      	callf	f_vSpi3Write
4881                     ; 374  bIntSrcFlagClr();
4883  0034 8d000000      	callf	f_bIntSrcFlagClr
4885                     ; 376 }
4888  0038 84            	pop	a
4889  0039 87            	retf
4938                     ; 378 void vCfgBank(unsigned int cfg[], unsigned char length)
4938                     ; 379 {
4939                     .text:	section	.text,new
4940  0000               f_vCfgBank:
4942  0000 89            	pushw	x
4943  0001 88            	push	a
4944       00000001      OFST:	set	1
4947                     ; 382  if(length!=0)
4949  0002 0d07          	tnz	(OFST+6,sp)
4950  0004 2719          	jreq	L1303
4951                     ; 384  	for(i=0; i<length; i++)	
4953  0006 0f01          	clr	(OFST+0,sp)
4955  0008 200f          	jra	L7303
4956  000a               L3303:
4957                     ; 385  		vSpi3Write(cfg[i]);
4959  000a 7b01          	ld	a,(OFST+0,sp)
4960  000c 5f            	clrw	x
4961  000d 97            	ld	xl,a
4962  000e 58            	sllw	x
4963  000f 72fb02        	addw	x,(OFST+1,sp)
4964  0012 fe            	ldw	x,(x)
4965  0013 8d000000      	callf	f_vSpi3Write
4967                     ; 384  	for(i=0; i<length; i++)	
4969  0017 0c01          	inc	(OFST+0,sp)
4970  0019               L7303:
4973  0019 7b01          	ld	a,(OFST+0,sp)
4974  001b 1107          	cp	a,(OFST+6,sp)
4975  001d 25eb          	jrult	L3303
4976  001f               L1303:
4977                     ; 387 }
4980  001f 5b03          	addw	sp,#3
4981  0021 87            	retf
5027                     ; 397 unsigned char bGetMessage(unsigned char msg[])
5027                     ; 398 {
5028                     .text:	section	.text,new
5029  0000               f_bGetMessage:
5031  0000 89            	pushw	x
5032  0001 88            	push	a
5033       00000001      OFST:	set	1
5036                     ; 401  vEnableRdFifo();	
5038  0002 8d000000      	callf	f_vEnableRdFifo
5040                     ; 402  if(FixedPktLength)
5042  0006 725d0004      	tnz	_FixedPktLength
5043  000a 2711          	jreq	L3603
5044                     ; 404   	vSpi3BurstReadFIFO(msg, PayloadLength);
5046  000c 3b0003        	push	_PayloadLength+1
5047  000f 1e03          	ldw	x,(OFST+2,sp)
5048  0011 8d000000      	callf	f_vSpi3BurstReadFIFO
5050  0015 84            	pop	a
5051                     ; 405 	i = PayloadLength;
5053  0016 c60003        	ld	a,_PayloadLength+1
5054  0019 6b01          	ld	(OFST+0,sp),a
5056  001b 2010          	jra	L5603
5057  001d               L3603:
5058                     ; 409 	i = bSpi3ReadFIFO();	
5060  001d 8d000000      	callf	f_bSpi3ReadFIFO
5062  0021 6b01          	ld	(OFST+0,sp),a
5063                     ; 410  	vSpi3BurstReadFIFO(msg, i);
5065  0023 7b01          	ld	a,(OFST+0,sp)
5066  0025 88            	push	a
5067  0026 1e03          	ldw	x,(OFST+2,sp)
5068  0028 8d000000      	callf	f_vSpi3BurstReadFIFO
5070  002c 84            	pop	a
5071  002d               L5603:
5072                     ; 412  return(i);
5074  002d 7b01          	ld	a,(OFST+0,sp)
5077  002f 5b03          	addw	sp,#3
5078  0031 87            	retf
5142                     ; 415 unsigned char bGetMessageByFlag(unsigned char msg[])
5142                     ; 416 {
5143                     .text:	section	.text,new
5144  0000               f_bGetMessageByFlag:
5146  0000 89            	pushw	x
5147  0001 5203          	subw	sp,#3
5148       00000003      OFST:	set	3
5151                     ; 419  unsigned char rev = 0;
5153  0003 0f03          	clr	(OFST+0,sp)
5154                     ; 420  tmp = bSpi3Read(CMT23_INT_FLG);
5156  0005 a66d          	ld	a,#109
5157  0007 8d000000      	callf	f_bSpi3Read
5159  000b 6b02          	ld	(OFST-1,sp),a
5160                     ; 421  if((tmp&SYNC_PASS_FLAG)&&(!RssiTrig))
5162  000d 7b02          	ld	a,(OFST-1,sp)
5163  000f a508          	bcp	a,#8
5164  0011 2712          	jreq	L3113
5166  0013 725d0000      	tnz	_RssiTrig
5167  0017 260c          	jrne	L3113
5168                     ; 423  	PktRssi = bReadRssi(False);
5170  0019 4f            	clr	a
5171  001a 8d000000      	callf	f_bReadRssi
5173  001e c70001        	ld	_PktRssi,a
5174                     ; 424  	RssiTrig = True;
5176  0021 35010000      	mov	_RssiTrig,#1
5177  0025               L3113:
5178                     ; 427  tmp1 = bSpi3Read(CMT23_CRC_CTL);
5180  0025 a64c          	ld	a,#76
5181  0027 8d000000      	callf	f_bSpi3Read
5183  002b 6b01          	ld	(OFST-2,sp),a
5184                     ; 428  vEnableRdFifo();	 
5186  002d 8d000000      	callf	f_vEnableRdFifo
5188                     ; 429  if(tmp1&CRC_ENABLE)		//Enable CrcCheck
5190  0031 7b01          	ld	a,(OFST-2,sp)
5191  0033 a501          	bcp	a,#1
5192  0035 2733          	jreq	L5113
5193                     ; 431  	if(tmp&CRC_PASS_FLAG)
5195  0037 7b02          	ld	a,(OFST-1,sp)
5196  0039 a502          	bcp	a,#2
5197  003b 275e          	jreq	L5213
5198                     ; 433  		if(FixedPktLength)
5200  003d 725d0004      	tnz	_FixedPktLength
5201  0041 2711          	jreq	L1213
5202                     ; 435   			vSpi3BurstReadFIFO(msg, PayloadLength);
5204  0043 3b0003        	push	_PayloadLength+1
5205  0046 1e05          	ldw	x,(OFST+2,sp)
5206  0048 8d000000      	callf	f_vSpi3BurstReadFIFO
5208  004c 84            	pop	a
5209                     ; 436 			rev = PayloadLength;
5211  004d c60003        	ld	a,_PayloadLength+1
5212  0050 6b03          	ld	(OFST+0,sp),a
5214  0052 2010          	jra	L3213
5215  0054               L1213:
5216                     ; 440 			rev = bSpi3ReadFIFO();	
5218  0054 8d000000      	callf	f_bSpi3ReadFIFO
5220  0058 6b03          	ld	(OFST+0,sp),a
5221                     ; 441  			vSpi3BurstReadFIFO(msg, rev);
5223  005a 7b03          	ld	a,(OFST+0,sp)
5224  005c 88            	push	a
5225  005d 1e05          	ldw	x,(OFST+2,sp)
5226  005f 8d000000      	callf	f_vSpi3BurstReadFIFO
5228  0063 84            	pop	a
5229  0064               L3213:
5230                     ; 443  		RssiTrig = False;
5232  0064 725f0000      	clr	_RssiTrig
5233  0068 2031          	jra	L5213
5234  006a               L5113:
5235                     ; 448 	if(tmp&RX_DONE_FLAG) 		
5237  006a 7b02          	ld	a,(OFST-1,sp)
5238  006c a501          	bcp	a,#1
5239  006e 272b          	jreq	L5213
5240                     ; 450  		if(FixedPktLength)
5242  0070 725d0004      	tnz	_FixedPktLength
5243  0074 2711          	jreq	L1313
5244                     ; 452   			vSpi3BurstReadFIFO(msg, PayloadLength);
5246  0076 3b0003        	push	_PayloadLength+1
5247  0079 1e05          	ldw	x,(OFST+2,sp)
5248  007b 8d000000      	callf	f_vSpi3BurstReadFIFO
5250  007f 84            	pop	a
5251                     ; 453 			rev = PayloadLength;
5253  0080 c60003        	ld	a,_PayloadLength+1
5254  0083 6b03          	ld	(OFST+0,sp),a
5256  0085 2010          	jra	L3313
5257  0087               L1313:
5258                     ; 457 			rev = bSpi3ReadFIFO();	
5260  0087 8d000000      	callf	f_bSpi3ReadFIFO
5262  008b 6b03          	ld	(OFST+0,sp),a
5263                     ; 458  			vSpi3BurstReadFIFO(msg, rev);
5265  008d 7b03          	ld	a,(OFST+0,sp)
5266  008f 88            	push	a
5267  0090 1e05          	ldw	x,(OFST+2,sp)
5268  0092 8d000000      	callf	f_vSpi3BurstReadFIFO
5270  0096 84            	pop	a
5271  0097               L3313:
5272                     ; 460  		RssiTrig = False;		
5274  0097 725f0000      	clr	_RssiTrig
5275  009b               L5213:
5276                     ; 464  if(tmp&COLLISION_ERR_FLAG)			//错误处理
5278  009b 7b02          	ld	a,(OFST-1,sp)
5279  009d a540          	bcp	a,#64
5280  009f 2704          	jreq	L5313
5281                     ; 465 	rev = 0xFF;
5283  00a1 a6ff          	ld	a,#255
5284  00a3 6b03          	ld	(OFST+0,sp),a
5285  00a5               L5313:
5286                     ; 466  return(rev);
5288  00a5 7b03          	ld	a,(OFST+0,sp)
5291  00a7 5b05          	addw	sp,#5
5292  00a9 87            	retf
5339                     ; 476 Bool bSendMessage(unsigned char msg[], unsigned char length)
5339                     ; 477 {
5340                     .text:	section	.text,new
5341  0000               f_bSendMessage:
5343  0000 89            	pushw	x
5344       00000000      OFST:	set	0
5347                     ; 486 	vSetTxPayloadLength(length);
5349  0001 7b06          	ld	a,(OFST+6,sp)
5350  0003 5f            	clrw	x
5351  0004 97            	ld	xl,a
5352  0005 8d000000      	callf	f_vSetTxPayloadLength
5354                     ; 487 	bIntSrcFlagClr();  //jia 调试发现stanby会产生TX_DONE中断，所以加了清除中断标志
5356  0009 8d000000      	callf	f_bIntSrcFlagClr
5358                     ; 488 	vEnableWrFifo();	
5360  000d 8d000000      	callf	f_vEnableWrFifo
5362                     ; 489 	vSpi3BurstWriteFIFO(msg, length);
5364  0011 7b06          	ld	a,(OFST+6,sp)
5365  0013 88            	push	a
5366  0014 1e02          	ldw	x,(OFST+2,sp)
5367  0016 8d000000      	callf	f_vSpi3BurstWriteFIFO
5369  001a 84            	pop	a
5370                     ; 490 	bGoTx();
5372  001b 8d000000      	callf	f_bGoTx
5374  001f               L7513:
5376  001f 20fe          	jra	L7513
5426                     ; 511 void vSetTxPayloadLength(unsigned int length)
5426                     ; 512 {
5427                     .text:	section	.text,new
5428  0000               f_vSetTxPayloadLength:
5430  0000 89            	pushw	x
5431  0001 89            	pushw	x
5432       00000002      OFST:	set	2
5435                     ; 515  bGoStandby();//调试发现stanby会产生TX_DONE中断
5437  0002 8d000000      	callf	f_bGoStandby
5439                     ; 516  tmp = bSpi3Read(CMT23_PKT_CTRL1);
5441  0006 a645          	ld	a,#69
5442  0008 8d000000      	callf	f_bSpi3Read
5444  000c 6b01          	ld	(OFST-1,sp),a
5445                     ; 517  tmp&= 0x8F;
5447  000e 7b01          	ld	a,(OFST-1,sp)
5448  0010 a48f          	and	a,#143
5449  0012 6b01          	ld	(OFST-1,sp),a
5450                     ; 519  if(length!=0)
5452  0014 1e03          	ldw	x,(OFST+1,sp)
5453  0016 2713          	jreq	L3023
5454                     ; 521  	if(FixedPktLength)
5456  0018 725d0004      	tnz	_FixedPktLength
5457  001c 2707          	jreq	L5023
5458                     ; 522 		len = length-1;
5460  001e 7b04          	ld	a,(OFST+2,sp)
5461  0020 4a            	dec	a
5462  0021 6b02          	ld	(OFST+0,sp),a
5464  0023 2008          	jra	L1123
5465  0025               L5023:
5466                     ; 524 		len = length;
5468  0025 7b04          	ld	a,(OFST+2,sp)
5469  0027 6b02          	ld	(OFST+0,sp),a
5470  0029 2002          	jra	L1123
5471  002b               L3023:
5472                     ; 527  	len = 0;
5474  002b 0f02          	clr	(OFST+0,sp)
5475  002d               L1123:
5476                     ; 529  tmp|= (((unsigned char)(len>>8)&0x07)<<4);
5478                     ; 530  vSpi3Write(((unsigned int)CMT23_PKT_CTRL1<<8)+tmp);
5480  002d 7b01          	ld	a,(OFST-1,sp)
5481  002f 5f            	clrw	x
5482  0030 97            	ld	xl,a
5483  0031 1c4500        	addw	x,#17664
5484  0034 8d000000      	callf	f_vSpi3Write
5486                     ; 531  vSpi3Write(((unsigned int)CMT23_PKT_LEN<<8)+(unsigned char)len);	//Payload length
5488  0038 7b02          	ld	a,(OFST+0,sp)
5489  003a 5f            	clrw	x
5490  003b 97            	ld	xl,a
5491  003c 1c4600        	addw	x,#17920
5492  003f 8d000000      	callf	f_vSpi3Write
5494                     ; 533 }
5497  0043 5b04          	addw	sp,#4
5498  0045 87            	retf
5546                     	switch	.bss
5547  0000               _RssiTrig:
5548  0000 00            	ds.b	1
5549                     	xdef	_RssiTrig
5550  0001               _PktRssi:
5551  0001 00            	ds.b	1
5552                     	xdef	_PktRssi
5553  0002               _PayloadLength:
5554  0002 0000          	ds.b	2
5555                     	xdef	_PayloadLength
5556  0004               _FixedPktLength:
5557  0004 00            	ds.b	1
5558                     	xdef	_FixedPktLength
5559                     	xdef	f_bSendMessage
5560                     	xdef	f_bGetMessageByFlag
5561                     	xdef	f_bGetMessage
5562                     	xdef	f_vCfgBank
5563                     	xdef	f_vInit
5564                     	xdef	f_vReadIngFlag2
5565                     	xdef	f_vReadIngFlag1
5566                     	xdef	f_vSetTxPayloadLength
5567                     	xdef	f_vEnableWrFifo
5568                     	xdef	f_vEnableRdFifo
5569                     	xdef	f_vClearFIFO
5570                     	xdef	f_bIntSrcFlagClr
5571                     	xdef	f_vIntSrcEnable
5572                     	xdef	f_vEnableAntSwitch
5573                     	xdef	f_vIntSrcCfg
5574                     	xdef	f_vGpioFuncCfg
5575                     	xdef	f_bReadRssi
5576                     	xdef	f_bReadStatus
5577                     	xdef	f_vSoftReset
5578                     	xdef	f_bGoStandby
5579                     	xdef	f_bGoSleep
5580                     	xdef	f_bGoRx
5581                     	xdef	f_bGoTx
5582                     	xref	f_vSpi3BurstReadFIFO
5583                     	xref	f_vSpi3BurstWriteFIFO
5584                     	xref	f_bSpi3ReadFIFO
5585                     	xref	f_bSpi3Read
5586                     	xref	f_vSpi3Write
5587                     	xref	f_vSpi3Init
5588                     	xref	f_delay_us
5608                     	end
