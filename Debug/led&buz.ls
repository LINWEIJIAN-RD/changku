   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3363                     ; 8 void led_state(char led, char state)
3363                     ; 9 {
3364                     .text:	section	.text,new
3365  0000               f_led_state:
3367  0000 89            	pushw	x
3368       00000000      OFST:	set	0
3371                     ; 10 	if(led==red)
3373  0001 9e            	ld	a,xh
3374  0002 a104          	cp	a,#4
3375  0004 2630          	jrne	L7032
3376                     ; 12 		if(state==ON)
3378  0006 9f            	ld	a,xl
3379  0007 4d            	tnz	a
3380  0008 2612          	jrne	L1132
3381                     ; 14 			PC_ODR |= 0x01<<led;//P1&=~(1<<led);
3383  000a 9e            	ld	a,xh
3384  000b 5f            	clrw	x
3385  000c 97            	ld	xl,a
3386  000d a601          	ld	a,#1
3387  000f 5d            	tnzw	x
3388  0010 2704          	jreq	L6
3389  0012               L01:
3390  0012 48            	sll	a
3391  0013 5a            	decw	x
3392  0014 26fc          	jrne	L01
3393  0016               L6:
3394  0016 ca500a        	or	a,_PC_ODR
3395  0019 c7500a        	ld	_PC_ODR,a
3396  001c               L1132:
3397                     ; 16 		if(state==OFF)
3399  001c 7b02          	ld	a,(OFST+2,sp)
3400  001e a101          	cp	a,#1
3401  0020 2614          	jrne	L7032
3402                     ; 18 			PC_ODR &= ~(0x01<<led);//P1|=(1<<led);
3404  0022 7b01          	ld	a,(OFST+1,sp)
3405  0024 5f            	clrw	x
3406  0025 97            	ld	xl,a
3407  0026 a601          	ld	a,#1
3408  0028 5d            	tnzw	x
3409  0029 2704          	jreq	L21
3410  002b               L41:
3411  002b 48            	sll	a
3412  002c 5a            	decw	x
3413  002d 26fc          	jrne	L41
3414  002f               L21:
3415  002f 43            	cpl	a
3416  0030 c4500a        	and	a,_PC_ODR
3417  0033 c7500a        	ld	_PC_ODR,a
3418  0036               L7032:
3419                     ; 21 	if(led==brue)
3421  0036 0d01          	tnz	(OFST+1,sp)
3422  0038 2631          	jrne	L5132
3423                     ; 23 		if(state==ON)
3425  003a 0d02          	tnz	(OFST+2,sp)
3426  003c 2613          	jrne	L7132
3427                     ; 25 			PB_ODR |= 0x01<<led;//P1&=~(1<<led);
3429  003e 7b01          	ld	a,(OFST+1,sp)
3430  0040 5f            	clrw	x
3431  0041 97            	ld	xl,a
3432  0042 a601          	ld	a,#1
3433  0044 5d            	tnzw	x
3434  0045 2704          	jreq	L61
3435  0047               L02:
3436  0047 48            	sll	a
3437  0048 5a            	decw	x
3438  0049 26fc          	jrne	L02
3439  004b               L61:
3440  004b ca5005        	or	a,_PB_ODR
3441  004e c75005        	ld	_PB_ODR,a
3442  0051               L7132:
3443                     ; 27 		if(state==OFF)
3445  0051 7b02          	ld	a,(OFST+2,sp)
3446  0053 a101          	cp	a,#1
3447  0055 2614          	jrne	L5132
3448                     ; 29 			PB_ODR &= ~(0x01<<led);//P1|=(1<<led);
3450  0057 7b01          	ld	a,(OFST+1,sp)
3451  0059 5f            	clrw	x
3452  005a 97            	ld	xl,a
3453  005b a601          	ld	a,#1
3454  005d 5d            	tnzw	x
3455  005e 2704          	jreq	L22
3456  0060               L42:
3457  0060 48            	sll	a
3458  0061 5a            	decw	x
3459  0062 26fc          	jrne	L42
3460  0064               L22:
3461  0064 43            	cpl	a
3462  0065 c45005        	and	a,_PB_ODR
3463  0068 c75005        	ld	_PB_ODR,a
3464  006b               L5132:
3465                     ; 32 }
3468  006b 85            	popw	x
3469  006c 87            	retf
3523                     ; 37 void ledflash(char led, unsigned int num, unsigned int time_ON, unsigned int time_OFF)//5=44.730ms
3523                     ; 38 {
3524                     .text:	section	.text,new
3525  0000               f_ledflash:
3527  0000 88            	push	a
3528       00000000      OFST:	set	0
3531  0001 2025          	jra	L1532
3532  0003               L5432:
3533                     ; 41     led_state(led,ON);
3535  0003 5f            	clrw	x
3536  0004 7b01          	ld	a,(OFST+1,sp)
3537  0006 95            	ld	xh,a
3538  0007 8d000000      	callf	f_led_state
3540                     ; 42     delay(time_ON);
3542  000b 1e07          	ldw	x,(OFST+7,sp)
3543  000d 8d000000      	callf	f_delay
3545                     ; 43     led_state(led,OFF);
3547  0011 ae0001        	ldw	x,#1
3548  0014 7b01          	ld	a,(OFST+1,sp)
3549  0016 95            	ld	xh,a
3550  0017 8d000000      	callf	f_led_state
3552                     ; 44     delay(time_OFF);
3554  001b 1e09          	ldw	x,(OFST+9,sp)
3555  001d 8d000000      	callf	f_delay
3557                     ; 39   for(;num>0;num--)
3559  0021 1e05          	ldw	x,(OFST+5,sp)
3560  0023 1d0001        	subw	x,#1
3561  0026 1f05          	ldw	(OFST+5,sp),x
3562  0028               L1532:
3565  0028 1e05          	ldw	x,(OFST+5,sp)
3566  002a 26d7          	jrne	L5432
3567                     ; 46 }
3570  002c 84            	pop	a
3571  002d 87            	retf
3594                     ; 49 void red_change(void)
3594                     ; 50 {
3595                     .text:	section	.text,new
3596  0000               f_red_change:
3600                     ; 51   if((PC_ODR & 0x10)==0x10)
3602  0000 c6500a        	ld	a,_PC_ODR
3603  0003 a410          	and	a,#16
3604  0005 a110          	cp	a,#16
3605  0007 2606          	jrne	L5632
3606                     ; 53 	  PC_ODR &= ~0x10;//red = 0;
3608  0009 7219500a      	bres	_PC_ODR,#4
3610  000d 2004          	jra	L7632
3611  000f               L5632:
3612                     ; 57     PC_ODR |= 0x10;//red = 1;
3614  000f 7218500a      	bset	_PC_ODR,#4
3615  0013               L7632:
3616                     ; 59 }
3619  0013 87            	retf
3651                     ; 68 void buz_state(char state)
3651                     ; 69 {
3652                     .text:	section	.text,new
3653  0000               f_buz_state:
3655  0000 88            	push	a
3656       00000000      OFST:	set	0
3659                     ; 70   if(state==ON)
3661  0001 4d            	tnz	a
3662  0002 2604          	jrne	L5042
3663                     ; 72     PB_ODR |= 0x02;//buz = 1;
3665  0004 72125005      	bset	_PB_ODR,#1
3666  0008               L5042:
3667                     ; 74   if(state==OFF)
3669  0008 7b01          	ld	a,(OFST+1,sp)
3670  000a a101          	cp	a,#1
3671  000c 2604          	jrne	L7042
3672                     ; 76     PB_ODR &= ~0x02;//buz = 0;
3674  000e 72135005      	bres	_PB_ODR,#1
3675  0012               L7042:
3676                     ; 78 }
3679  0012 84            	pop	a
3680  0013 87            	retf
3703                     ; 80 void buz_change(void)
3703                     ; 81 {
3704                     .text:	section	.text,new
3705  0000               f_buz_change:
3709                     ; 82   if((PB_ODR & 0x02)==0x02)
3711  0000 c65005        	ld	a,_PB_ODR
3712  0003 a402          	and	a,#2
3713  0005 a102          	cp	a,#2
3714  0007 2606          	jrne	L1242
3715                     ; 84 	  PB_ODR &= ~0x02;//buz = 0;
3717  0009 72135005      	bres	_PB_ODR,#1
3719  000d 2004          	jra	L3242
3720  000f               L1242:
3721                     ; 88     PB_ODR |= 0x02;//buz = 1;
3723  000f 72125005      	bset	_PB_ODR,#1
3724  0013               L3242:
3725                     ; 90 }
3728  0013 87            	retf
3740                     	xdef	f_buz_change
3741                     	xdef	f_buz_state
3742                     	xdef	f_ledflash
3743                     	xdef	f_red_change
3744                     	xdef	f_led_state
3745                     	xref	f_delay
3764                     	end
