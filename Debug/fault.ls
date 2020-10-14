   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3354                     ; 5 void fault_test(void)
3354                     ; 6 {	
3355                     .text:	section	.text,new
3356  0000               f_fault_test:
3358  0000 5204          	subw	sp,#4
3359       00000004      OFST:	set	4
3362                     ; 7   AD_VDD_val();
3364  0002 8d000000      	callf	f_AD_VDD_val
3366                     ; 8 	power_up_amplify
3368  0006 721c5007      	bset	_PB_DDR,#6
3371  000a 721c5008      	bset	_PB_CR1,#6
3374  000e 721c5005      	bset	_PB_ODR,#6
3375                     ; 9 	power_up_emitter
3377  0012 721a5007      	bset	_PB_DDR,#5
3380  0016 721a5008      	bset	_PB_CR1,#5
3383  001a 721a5005      	bset	_PB_ODR,#5
3384                     ; 10 	AD_IR_val();
3386  001e 8d000000      	callf	f_AD_IR_val
3388                     ; 11 	power_down_amplify
3390  0022 721c5007      	bset	_PB_DDR,#6
3393  0026 721c5008      	bset	_PB_CR1,#6
3396  002a 721d5005      	bres	_PB_ODR,#6
3397                     ; 12 	power_down_emitter
3399  002e 721a5007      	bset	_PB_DDR,#5
3402  0032 721a5008      	bset	_PB_CR1,#5
3405  0036 721b5005      	bres	_PB_ODR,#5
3406  003a               L1032:
3407                     ; 16 		if(IR_val<0.372)  
3409  003a 9c            	rvf
3410  003b ae0000        	ldw	x,#_IR_val
3411  003e 8d000000      	callf	d_ltor
3413  0042 ae000c        	ldw	x,#L3132
3414  0045 8d000000      	callf	d_fcmp
3416  0049 2f04          	jrslt	L6
3417  004b acdc00dc      	jpf	L5032
3418  004f               L6:
3419                     ; 18 	    ledflash(red, 2, 70, 70);
3421  004f ae0046        	ldw	x,#70
3422  0052 89            	pushw	x
3423  0053 ae0046        	ldw	x,#70
3424  0056 89            	pushw	x
3425  0057 ae0002        	ldw	x,#2
3426  005a 89            	pushw	x
3427  005b a604          	ld	a,#4
3428  005d 8d000000      	callf	f_ledflash
3430  0061 5b06          	addw	sp,#6
3431                     ; 19 			pow_val_temp=AD_VDD_val();
3433  0063 8d000000      	callf	f_AD_VDD_val
3435  0067 ae0000        	ldw	x,#_pow_val_temp
3436  006a 8d000000      	callf	d_rtol
3438                     ; 20 			power_up_amplify
3440  006e 721c5007      	bset	_PB_DDR,#6
3443  0072 721c5008      	bset	_PB_CR1,#6
3446  0076 721c5005      	bset	_PB_ODR,#6
3447                     ; 21 			power_up_emitter
3449  007a 721a5007      	bset	_PB_DDR,#5
3452  007e 721a5008      	bset	_PB_CR1,#5
3455  0082 721a5005      	bset	_PB_ODR,#5
3456                     ; 22 			cal_val_temp=AD_IR_val();
3458  0086 8d000000      	callf	f_AD_IR_val
3460  008a ae0000        	ldw	x,#_cal_val_temp
3461  008d 8d000000      	callf	d_rtol
3463                     ; 23 			power_down_amplify
3465  0091 721c5007      	bset	_PB_DDR,#6
3468  0095 721c5008      	bset	_PB_CR1,#6
3471  0099 721d5005      	bres	_PB_ODR,#6
3472                     ; 24 			power_down_emitter
3474  009d 721a5007      	bset	_PB_DDR,#5
3477  00a1 721a5008      	bset	_PB_CR1,#5
3480  00a5 721b5005      	bres	_PB_ODR,#5
3481                     ; 25 			IR_val=cal_val_temp-(pow_val_temp-3)*0.225;
3483  00a9 ae0000        	ldw	x,#_pow_val_temp
3484  00ac 8d000000      	callf	d_ltor
3486  00b0 ae0008        	ldw	x,#L3232
3487  00b3 8d000000      	callf	d_fsub
3489  00b7 ae0004        	ldw	x,#L3332
3490  00ba 8d000000      	callf	d_fmul
3492  00be 96            	ldw	x,sp
3493  00bf 1c0001        	addw	x,#OFST-3
3494  00c2 8d000000      	callf	d_rtol
3496  00c6 ae0000        	ldw	x,#_cal_val_temp
3497  00c9 8d000000      	callf	d_ltor
3499  00cd 96            	ldw	x,sp
3500  00ce 1c0001        	addw	x,#OFST-3
3501  00d1 8d000000      	callf	d_fsub
3503  00d5 ae0000        	ldw	x,#_IR_val
3504  00d8 8d000000      	callf	d_rtol
3506  00dc               L5032:
3507                     ; 27     if(IR_val>0.477)    
3509  00dc 9c            	rvf
3510  00dd ae0000        	ldw	x,#_IR_val
3511  00e0 8d000000      	callf	d_ltor
3513  00e4 ae0000        	ldw	x,#L5432
3514  00e7 8d000000      	callf	d_fcmp
3516  00eb 2c04          	jrsgt	L01
3517  00ed ac7e017e      	jpf	L7332
3518  00f1               L01:
3519                     ; 29 			ledflash(red, 3, 70, 70);
3521  00f1 ae0046        	ldw	x,#70
3522  00f4 89            	pushw	x
3523  00f5 ae0046        	ldw	x,#70
3524  00f8 89            	pushw	x
3525  00f9 ae0003        	ldw	x,#3
3526  00fc 89            	pushw	x
3527  00fd a604          	ld	a,#4
3528  00ff 8d000000      	callf	f_ledflash
3530  0103 5b06          	addw	sp,#6
3531                     ; 30 			pow_val_temp=AD_VDD_val();
3533  0105 8d000000      	callf	f_AD_VDD_val
3535  0109 ae0000        	ldw	x,#_pow_val_temp
3536  010c 8d000000      	callf	d_rtol
3538                     ; 31 			power_up_amplify
3540  0110 721c5007      	bset	_PB_DDR,#6
3543  0114 721c5008      	bset	_PB_CR1,#6
3546  0118 721c5005      	bset	_PB_ODR,#6
3547                     ; 32 			power_up_emitter
3549  011c 721a5007      	bset	_PB_DDR,#5
3552  0120 721a5008      	bset	_PB_CR1,#5
3555  0124 721a5005      	bset	_PB_ODR,#5
3556                     ; 33 			cal_val_temp=AD_IR_val();
3558  0128 8d000000      	callf	f_AD_IR_val
3560  012c ae0000        	ldw	x,#_cal_val_temp
3561  012f 8d000000      	callf	d_rtol
3563                     ; 34 			power_down_amplify
3565  0133 721c5007      	bset	_PB_DDR,#6
3568  0137 721c5008      	bset	_PB_CR1,#6
3571  013b 721d5005      	bres	_PB_ODR,#6
3572                     ; 35 			power_down_emitter
3574  013f 721a5007      	bset	_PB_DDR,#5
3577  0143 721a5008      	bset	_PB_CR1,#5
3580  0147 721b5005      	bres	_PB_ODR,#5
3581                     ; 36 			IR_val=cal_val_temp-(pow_val_temp-3)*0.225;
3583  014b ae0000        	ldw	x,#_pow_val_temp
3584  014e 8d000000      	callf	d_ltor
3586  0152 ae0008        	ldw	x,#L3232
3587  0155 8d000000      	callf	d_fsub
3589  0159 ae0004        	ldw	x,#L3332
3590  015c 8d000000      	callf	d_fmul
3592  0160 96            	ldw	x,sp
3593  0161 1c0001        	addw	x,#OFST-3
3594  0164 8d000000      	callf	d_rtol
3596  0168 ae0000        	ldw	x,#_cal_val_temp
3597  016b 8d000000      	callf	d_ltor
3599  016f 96            	ldw	x,sp
3600  0170 1c0001        	addw	x,#OFST-3
3601  0173 8d000000      	callf	d_fsub
3603  0177 ae0000        	ldw	x,#_IR_val
3604  017a 8d000000      	callf	d_rtol
3606  017e               L7332:
3607                     ; 38 		if((IR_val>=0.372)&&(IR_val<=0.477)) break;
3609  017e 9c            	rvf
3610  017f ae0000        	ldw	x,#_IR_val
3611  0182 8d000000      	callf	d_ltor
3613  0186 ae000c        	ldw	x,#L3132
3614  0189 8d000000      	callf	d_fcmp
3616  018d 2e04          	jrsge	L21
3617  018f ac3a003a      	jpf	L1032
3618  0193               L21:
3620  0193 9c            	rvf
3621  0194 ae0000        	ldw	x,#_IR_val
3622  0197 8d000000      	callf	d_ltor
3624  019b ae0000        	ldw	x,#L5432
3625  019e 8d000000      	callf	d_fcmp
3627  01a2 2d04          	jrsle	L41
3628  01a4 ac3a003a      	jpf	L1032
3629  01a8               L41:
3631                     ; 40 }
3634  01a8 5b04          	addw	sp,#4
3635  01aa 87            	retf
3647                     	xdef	f_fault_test
3648                     	xref	_pow_val_temp
3649                     	xref	_cal_val_temp
3650                     	xref	_IR_val
3651                     	xref	f_AD_IR_val
3652                     	xref	f_AD_VDD_val
3653                     	xref	f_ledflash
3654                     .const:	section	.text
3655  0000               L5432:
3656  0000 3ef43958      	dc.w	16116,14680
3657  0004               L3332:
3658  0004 3e666666      	dc.w	15974,26214
3659  0008               L3232:
3660  0008 40400000      	dc.w	16448,0
3661  000c               L3132:
3662  000c 3ebe76c8      	dc.w	16062,30408
3663                     	xref.b	c_x
3683                     	xref	d_fmul
3684                     	xref	d_fsub
3685                     	xref	d_rtol
3686                     	xref	d_fcmp
3687                     	xref	d_ltor
3688                     	end
