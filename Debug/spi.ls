   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3354                     ; 14 void vSpi3Init(void)
3354                     ; 15 {
3355                     .text:	section	.text,new
3356  0000               f_vSpi3Init:
3360                     ; 16 	PC_DDR|=0X60;  // PC1 PC5 PC6  //Êä³öµÍ
3362  0000 c6500c        	ld	a,_PC_DDR
3363  0003 aa60          	or	a,#96
3364  0005 c7500c        	ld	_PC_DDR,a
3365                     ; 17 	PC_CR1|=0X60;
3367  0008 c6500d        	ld	a,_PC_CR1
3368  000b aa60          	or	a,#96
3369  000d c7500d        	ld	_PC_CR1,a
3370                     ; 18 	PC_ODR&=~0X60;
3372  0010 c6500a        	ld	a,_PC_ODR
3373  0013 a49f          	and	a,#159
3374  0015 c7500a        	ld	_PC_ODR,a
3375                     ; 19 	PD_DDR|=0X01;  //PD0 //Êä³öµÍ
3377  0018 72105011      	bset	_PD_DDR,#0
3378                     ; 20 	PD_CR1|=0X01;
3380  001c 72105012      	bset	_PD_CR1,#0
3381                     ; 21 	PD_ODR&=~0X01;
3383  0020 7211500f      	bres	_PD_ODR,#0
3384                     ; 22 	PB_DDR|=0X10;  //PB4 //Êä³öµÍ
3386  0024 72185007      	bset	_PB_DDR,#4
3387                     ; 23 	PB_CR1|=0X10;
3389  0028 72185008      	bset	_PB_CR1,#4
3390                     ; 24 	PB_ODR&=~0X10;
3392  002c 72195005      	bres	_PB_ODR,#4
3393                     ; 26 	SetCSB();
3395  0030 7210500f      	bset	_PD_ODR,#0
3396                     ; 27 	SetFCSB();
3398  0034 721a500a      	bset	_PC_ODR,#5
3399                     ; 28 	SetSDIO();
3401  0038 72185005      	bset	_PB_ODR,#4
3402                     ; 29 	ClrSDCK();
3404  003c 721d500a      	bres	_PC_ODR,#6
3405                     ; 30 }
3408  0040 87            	retf
3452                     ; 38 void vSpi3WriteByte(unsigned char dat)
3452                     ; 39 {
3453                     .text:	section	.text,new
3454  0000               f_vSpi3WriteByte:
3456  0000 88            	push	a
3457  0001 88            	push	a
3458       00000001      OFST:	set	1
3461                     ; 43 	SetFCSB();				//FCSB = 1;
3463  0002 721a500a      	bset	_PC_ODR,#5
3464                     ; 45  	OutputSDIO();			//SDA output mode
3466  0006 72185007      	bset	_PB_DDR,#4
3469  000a 72185008      	bset	_PB_CR1,#4
3472  000e 72195005      	bres	_PB_ODR,#4
3473                     ; 46  	OutputSDIO();			//SDA output mode
3476  0012 72185007      	bset	_PB_DDR,#4
3479  0016 72185008      	bset	_PB_CR1,#4
3482  001a 72195005      	bres	_PB_ODR,#4
3483                     ; 47  	SetSDIO();				//    output 1
3486  001e 72185005      	bset	_PB_ODR,#4
3487                     ; 49  	ClrSDCK();				
3489  0022 721d500a      	bres	_PC_ODR,#6
3490                     ; 50  	ClrCSB();
3492  0026 7211500f      	bres	_PD_ODR,#0
3493                     ; 52  	for(bitcnt=8; bitcnt!=0; bitcnt--)
3495  002a a608          	ld	a,#8
3496  002c 6b01          	ld	(OFST+0,sp),a
3497  002e               L7132:
3498                     ; 54 		ClrSDCK();	
3500  002e 721d500a      	bres	_PC_ODR,#6
3501                     ; 55 		delay_us(SPI3_SPEED);
3503  0032 ae0001        	ldw	x,#1
3504  0035 8d000000      	callf	f_delay_us
3506                     ; 56  		if(dat&0x80)
3508  0039 7b02          	ld	a,(OFST+1,sp)
3509  003b a580          	bcp	a,#128
3510  003d 2706          	jreq	L5232
3511                     ; 57  			SetSDIO();
3513  003f 72185005      	bset	_PB_ODR,#4
3515  0043 2004          	jra	L7232
3516  0045               L5232:
3517                     ; 59  			ClrSDIO();
3519  0045 72195005      	bres	_PB_ODR,#4
3520  0049               L7232:
3521                     ; 60 		SetSDCK();
3523  0049 721c500a      	bset	_PC_ODR,#6
3524                     ; 61  		dat <<= 1; 		
3526  004d 0802          	sll	(OFST+1,sp)
3527                     ; 62  		delay_us(SPI3_SPEED);
3529  004f ae0001        	ldw	x,#1
3530  0052 8d000000      	callf	f_delay_us
3532                     ; 52  	for(bitcnt=8; bitcnt!=0; bitcnt--)
3534  0056 0a01          	dec	(OFST+0,sp)
3537  0058 0d01          	tnz	(OFST+0,sp)
3538  005a 26d2          	jrne	L7132
3539                     ; 64  	ClrSDCK();		
3541  005c 721d500a      	bres	_PC_ODR,#6
3542                     ; 65  	SetSDIO();
3544  0060 72185005      	bset	_PB_ODR,#4
3545                     ; 66 }
3548  0064 85            	popw	x
3549  0065 87            	retf
3594                     ; 74 unsigned char bSpi3ReadByte(void)
3594                     ; 75 {
3595                     .text:	section	.text,new
3596  0000               f_bSpi3ReadByte:
3598  0000 89            	pushw	x
3599       00000002      OFST:	set	2
3602                     ; 76 	unsigned char RdPara = 0;
3604  0001 0f02          	clr	(OFST+0,sp)
3605                     ; 79  	ClrCSB(); 
3607  0003 7211500f      	bres	_PD_ODR,#0
3608                     ; 80  	InputSDIO();			
3610  0007 72195007      	bres	_PB_DDR,#4
3611                     ; 81   	InputSDIO();		
3613  000b 72195007      	bres	_PB_DDR,#4
3614                     ; 82  	for(bitcnt=8; bitcnt!=0; bitcnt--)
3616  000f a608          	ld	a,#8
3617  0011 6b01          	ld	(OFST-1,sp),a
3618  0013               L7432:
3619                     ; 84  		ClrSDCK();
3621  0013 721d500a      	bres	_PC_ODR,#6
3622                     ; 85  		RdPara <<= 1;
3624  0017 0802          	sll	(OFST+0,sp)
3625                     ; 86  		delay_us(SPI3_SPEED);
3627  0019 ae0001        	ldw	x,#1
3628  001c 8d000000      	callf	f_delay_us
3630                     ; 87  		SetSDCK();
3632  0020 721c500a      	bset	_PC_ODR,#6
3633                     ; 88  		delay_us(SPI3_SPEED);
3635  0024 ae0001        	ldw	x,#1
3636  0027 8d000000      	callf	f_delay_us
3638                     ; 89  		if(SDIO_H())
3640  002b c65006        	ld	a,_PB_IDR
3641  002e a410          	and	a,#16
3642  0030 a110          	cp	a,#16
3643  0032 2606          	jrne	L5532
3644                     ; 90  			RdPara |= 0x01;
3646  0034 7b02          	ld	a,(OFST+0,sp)
3647  0036 aa01          	or	a,#1
3648  0038 6b02          	ld	(OFST+0,sp),a
3650  003a               L5532:
3651                     ; 92  			RdPara |= 0x00;
3653                     ; 82  	for(bitcnt=8; bitcnt!=0; bitcnt--)
3655  003a 0a01          	dec	(OFST-1,sp)
3658  003c 0d01          	tnz	(OFST-1,sp)
3659  003e 26d3          	jrne	L7432
3660                     ; 94  	ClrSDCK();
3662  0040 721d500a      	bres	_PC_ODR,#6
3663                     ; 95  	OutputSDIO();
3665  0044 72185007      	bset	_PB_DDR,#4
3668  0048 72185008      	bset	_PB_CR1,#4
3671  004c 72195005      	bres	_PB_ODR,#4
3672                     ; 96 	OutputSDIO();
3675  0050 72185007      	bset	_PB_DDR,#4
3678  0054 72185008      	bset	_PB_CR1,#4
3681  0058 72195005      	bres	_PB_ODR,#4
3682                     ; 97  	SetSDIO();
3685  005c 72185005      	bset	_PB_ODR,#4
3686                     ; 98  	SetCSB();			
3688  0060 7210500f      	bset	_PD_ODR,#0
3689                     ; 99  	return(RdPara);	
3691  0064 7b02          	ld	a,(OFST+0,sp)
3694  0066 85            	popw	x
3695  0067 87            	retf
3728                     ; 108 void vSpi3Write(unsigned int dat)
3728                     ; 109 {
3729                     .text:	section	.text,new
3730  0000               f_vSpi3Write:
3732  0000 89            	pushw	x
3733       00000000      OFST:	set	0
3736                     ; 110  	vSpi3WriteByte((unsigned char)(dat>>8)&0x7F);
3738  0001 9e            	ld	a,xh
3739  0002 a47f          	and	a,#127
3740  0004 8d000000      	callf	f_vSpi3WriteByte
3742                     ; 111  	vSpi3WriteByte((unsigned char)dat);
3744  0008 7b02          	ld	a,(OFST+2,sp)
3745  000a 8d000000      	callf	f_vSpi3WriteByte
3747                     ; 112  	SetCSB();
3749  000e 7210500f      	bset	_PD_ODR,#0
3750                     ; 113 }
3753  0012 85            	popw	x
3754  0013 87            	retf
3787                     ; 121 unsigned char bSpi3Read(unsigned char addr)
3787                     ; 122 {
3788                     .text:	section	.text,new
3789  0000               f_bSpi3Read:
3793                     ; 123   	vSpi3WriteByte(addr|0x80);
3795  0000 aa80          	or	a,#128
3796  0002 8d000000      	callf	f_vSpi3WriteByte
3798                     ; 124  	return(bSpi3ReadByte());
3800  0006 8d000000      	callf	f_bSpi3ReadByte
3804  000a 87            	retf
3848                     ; 133 void vSpi3WriteFIFO(unsigned char dat)
3848                     ; 134 {
3849                     .text:	section	.text,new
3850  0000               f_vSpi3WriteFIFO:
3852  0000 88            	push	a
3853  0001 88            	push	a
3854       00000001      OFST:	set	1
3857                     ; 137  	SetCSB();	
3859  0002 7210500f      	bset	_PD_ODR,#0
3860                     ; 138 	OutputSDIO();	
3862  0006 72185007      	bset	_PB_DDR,#4
3865  000a 72185008      	bset	_PB_CR1,#4
3868  000e 72195005      	bres	_PB_ODR,#4
3869                     ; 139 	ClrSDCK();
3872  0012 721d500a      	bres	_PC_ODR,#6
3873                     ; 140  	ClrFCSB();			//FCSB = 0
3875  0016 721b500a      	bres	_PC_ODR,#5
3876                     ; 141 	delay_us(SPI3_SPEED);		//Time-Critical  jia
3878  001a ae0001        	ldw	x,#1
3879  001d 8d000000      	callf	f_delay_us
3881                     ; 142  	delay_us(SPI3_SPEED);		//Time-Critical  jia
3883  0021 ae0001        	ldw	x,#1
3884  0024 8d000000      	callf	f_delay_us
3886                     ; 143 	for(bitcnt=8; bitcnt!=0; bitcnt--)
3888  0028 a608          	ld	a,#8
3889  002a 6b01          	ld	(OFST+0,sp),a
3890  002c               L7242:
3891                     ; 145  		ClrSDCK();
3893  002c 721d500a      	bres	_PC_ODR,#6
3894                     ; 147  		if(dat&0x80)
3896  0030 7b02          	ld	a,(OFST+1,sp)
3897  0032 a580          	bcp	a,#128
3898  0034 2706          	jreq	L5342
3899                     ; 148 			SetSDIO();		
3901  0036 72185005      	bset	_PB_ODR,#4
3903  003a 2004          	jra	L7342
3904  003c               L5342:
3905                     ; 150 			ClrSDIO();
3907  003c 72195005      	bres	_PB_ODR,#4
3908  0040               L7342:
3909                     ; 151 		delay_us(SPI3_SPEED);
3911  0040 ae0001        	ldw	x,#1
3912  0043 8d000000      	callf	f_delay_us
3914                     ; 152 		SetSDCK();
3916  0047 721c500a      	bset	_PC_ODR,#6
3917                     ; 153 		delay_us(SPI3_SPEED);
3919  004b ae0001        	ldw	x,#1
3920  004e 8d000000      	callf	f_delay_us
3922                     ; 154  		dat <<= 1;
3924  0052 0802          	sll	(OFST+1,sp)
3925                     ; 143 	for(bitcnt=8; bitcnt!=0; bitcnt--)
3927  0054 0a01          	dec	(OFST+0,sp)
3930  0056 0d01          	tnz	(OFST+0,sp)
3931  0058 26d2          	jrne	L7242
3932                     ; 156  	ClrSDCK();	
3934  005a 721d500a      	bres	_PC_ODR,#6
3935                     ; 157  	delay_us(SPI3_SPEED);		//Time-Critical
3937  005e ae0001        	ldw	x,#1
3938  0061 8d000000      	callf	f_delay_us
3940                     ; 160  	SetFCSB();
3942  0065 721a500a      	bset	_PC_ODR,#5
3943                     ; 161 	delay_us(SPI3_SPEED);		//Time-Critical  jia
3945  0069 ae0001        	ldw	x,#1
3946  006c 8d000000      	callf	f_delay_us
3948                     ; 162 	SetSDIO();
3950  0070 72185005      	bset	_PB_ODR,#4
3951                     ; 167 }
3954  0074 85            	popw	x
3955  0075 87            	retf
4000                     ; 175 unsigned char bSpi3ReadFIFO(void)
4000                     ; 176 {
4001                     .text:	section	.text,new
4002  0000               f_bSpi3ReadFIFO:
4004  0000 89            	pushw	x
4005       00000002      OFST:	set	2
4008                     ; 180  	SetCSB();
4010  0001 7210500f      	bset	_PD_ODR,#0
4011                     ; 181 	InputSDIO();
4013  0005 72195007      	bres	_PB_DDR,#4
4014                     ; 182  	ClrSDCK();
4016  0009 721d500a      	bres	_PC_ODR,#6
4017                     ; 183 	ClrFCSB();
4019  000d 721b500a      	bres	_PC_ODR,#5
4020                     ; 184 	delay_us(SPI3_SPEED);		//Time-Critical  jia
4022  0011 ae0001        	ldw	x,#1
4023  0014 8d000000      	callf	f_delay_us
4025                     ; 185  	delay_us(SPI3_SPEED);		//Time-Critical  jia	
4027  0018 ae0001        	ldw	x,#1
4028  001b 8d000000      	callf	f_delay_us
4030                     ; 186  	for(bitcnt=8; bitcnt!=0; bitcnt--)
4032  001f a608          	ld	a,#8
4033  0021 6b01          	ld	(OFST-1,sp),a
4034  0023               L7542:
4035                     ; 188  		ClrSDCK();
4037  0023 721d500a      	bres	_PC_ODR,#6
4038                     ; 189  		RdPara <<= 1;
4040  0027 0802          	sll	(OFST+0,sp)
4041                     ; 190  		delay_us(SPI3_SPEED);
4043  0029 ae0001        	ldw	x,#1
4044  002c 8d000000      	callf	f_delay_us
4046                     ; 191 		SetSDCK();
4048  0030 721c500a      	bset	_PC_ODR,#6
4049                     ; 192 		delay_us(SPI3_SPEED);
4051  0034 ae0001        	ldw	x,#1
4052  0037 8d000000      	callf	f_delay_us
4054                     ; 193  		if(SDIO_H())
4056  003b c65006        	ld	a,_PB_IDR
4057  003e a410          	and	a,#16
4058  0040 a110          	cp	a,#16
4059  0042 2606          	jrne	L5642
4060                     ; 194  			RdPara |= 0x01;		//NRZ MSB
4062  0044 7b02          	ld	a,(OFST+0,sp)
4063  0046 aa01          	or	a,#1
4064  0048 6b02          	ld	(OFST+0,sp),a
4066  004a               L5642:
4067                     ; 196  		 	RdPara |= 0x00;		//NRZ MSB
4069                     ; 186  	for(bitcnt=8; bitcnt!=0; bitcnt--)
4071  004a 0a01          	dec	(OFST-1,sp)
4074  004c 0d01          	tnz	(OFST-1,sp)
4075  004e 26d3          	jrne	L7542
4076                     ; 199  	ClrSDCK();
4078  0050 721d500a      	bres	_PC_ODR,#6
4079                     ; 200   delay_us(SPI3_SPEED);		//Time-Critical
4081  0054 ae0001        	ldw	x,#1
4082  0057 8d000000      	callf	f_delay_us
4084                     ; 203  	SetFCSB();
4086  005b 721a500a      	bset	_PC_ODR,#5
4087                     ; 204 	delay_us(SPI3_SPEED);		//Time-Critical  jia
4089  005f ae0001        	ldw	x,#1
4090  0062 8d000000      	callf	f_delay_us
4092                     ; 205 	OutputSDIO();
4094  0066 72185007      	bset	_PB_DDR,#4
4097  006a 72185008      	bset	_PB_CR1,#4
4100  006e 72195005      	bres	_PB_ODR,#4
4101                     ; 206 	SetSDIO();
4104  0072 72185005      	bset	_PB_ODR,#4
4105                     ; 211  	return(RdPara);
4107  0076 7b02          	ld	a,(OFST+0,sp)
4110  0078 85            	popw	x
4111  0079 87            	retf
4161                     ; 220 void vSpi3BurstWriteFIFO(unsigned char ptr[], unsigned char length)
4161                     ; 221 {
4162                     .text:	section	.text,new
4163  0000               f_vSpi3BurstWriteFIFO:
4165  0000 89            	pushw	x
4166  0001 88            	push	a
4167       00000001      OFST:	set	1
4170                     ; 223  	if(length!=0x00)
4172  0002 0d07          	tnz	(OFST+6,sp)
4173  0004 271c          	jreq	L3152
4174                     ; 225  		for(i=0;i<length;i++)
4176  0006 0f01          	clr	(OFST+0,sp)
4178  0008 2012          	jra	L1252
4179  000a               L5152:
4180                     ; 226  			vSpi3WriteFIFO(ptr[i]);
4182  000a 7b02          	ld	a,(OFST+1,sp)
4183  000c 97            	ld	xl,a
4184  000d 7b03          	ld	a,(OFST+2,sp)
4185  000f 1b01          	add	a,(OFST+0,sp)
4186  0011 2401          	jrnc	L42
4187  0013 5c            	incw	x
4188  0014               L42:
4189  0014 02            	rlwa	x,a
4190  0015 f6            	ld	a,(x)
4191  0016 8d000000      	callf	f_vSpi3WriteFIFO
4193                     ; 225  		for(i=0;i<length;i++)
4195  001a 0c01          	inc	(OFST+0,sp)
4196  001c               L1252:
4199  001c 7b01          	ld	a,(OFST+0,sp)
4200  001e 1107          	cp	a,(OFST+6,sp)
4201  0020 25e8          	jrult	L5152
4202  0022               L3152:
4203                     ; 228  	return;
4206  0022 5b03          	addw	sp,#3
4207  0024 87            	retf
4256                     ; 237 void vSpi3BurstReadFIFO(unsigned char ptr[], unsigned char length)
4256                     ; 238 {
4257                     .text:	section	.text,new
4258  0000               f_vSpi3BurstReadFIFO:
4260  0000 89            	pushw	x
4261  0001 88            	push	a
4262       00000001      OFST:	set	1
4265                     ; 240  	if(length!=0)
4267  0002 0d07          	tnz	(OFST+6,sp)
4268  0004 271e          	jreq	L7452
4269                     ; 242  		for(i=0;i<length;i++)
4271  0006 0f01          	clr	(OFST+0,sp)
4273  0008 2014          	jra	L5552
4274  000a               L1552:
4275                     ; 243  			ptr[i] = bSpi3ReadFIFO();
4277  000a 7b02          	ld	a,(OFST+1,sp)
4278  000c 97            	ld	xl,a
4279  000d 7b03          	ld	a,(OFST+2,sp)
4280  000f 1b01          	add	a,(OFST+0,sp)
4281  0011 2401          	jrnc	L03
4282  0013 5c            	incw	x
4283  0014               L03:
4284  0014 02            	rlwa	x,a
4285  0015 89            	pushw	x
4286  0016 8d000000      	callf	f_bSpi3ReadFIFO
4288  001a 85            	popw	x
4289  001b f7            	ld	(x),a
4290                     ; 242  		for(i=0;i<length;i++)
4292  001c 0c01          	inc	(OFST+0,sp)
4293  001e               L5552:
4296  001e 7b01          	ld	a,(OFST+0,sp)
4297  0020 1107          	cp	a,(OFST+6,sp)
4298  0022 25e6          	jrult	L1552
4299  0024               L7452:
4300                     ; 245  	return;
4303  0024 5b03          	addw	sp,#3
4304  0026 87            	retf
4316                     	xdef	f_bSpi3ReadByte
4317                     	xdef	f_vSpi3WriteByte
4318                     	xdef	f_vSpi3BurstReadFIFO
4319                     	xdef	f_vSpi3BurstWriteFIFO
4320                     	xdef	f_bSpi3ReadFIFO
4321                     	xdef	f_vSpi3WriteFIFO
4322                     	xdef	f_bSpi3Read
4323                     	xdef	f_vSpi3Write
4324                     	xdef	f_vSpi3Init
4325                     	xref	f_delay_us
4344                     	end
