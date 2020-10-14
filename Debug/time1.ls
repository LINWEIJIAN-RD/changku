   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3351                     ; 2 void TIM2_INIT_Slow(void)//从报警用
3351                     ; 3 {
3352                     .text:	section	.text,new
3353  0000               f_TIM2_INIT_Slow:
3357                     ; 4 	CLK_PCKENR1|=0X01;      //打开TIM2时钟
3359  0000 721050c3      	bset	_CLK_PCKENR1,#0
3360                     ; 6 	TIM2_CR1 =0X80;   //预 边 上 单脉冲 禁计
3362  0004 35805250      	mov	_TIM2_CR1,#128
3363                     ; 7 	TIM2_PSCR =0X05; //分频4=mhz T=us
3365  0008 3505525e      	mov	_TIM2_PSCR,#5
3366                     ; 9 	TIM2_ARRH =0Xff;
3368  000c 35ff525f      	mov	_TIM2_ARRH,#255
3369                     ; 10 	TIM2_ARRL =0Xff;   //8MHz 32Div 
3371  0010 35ff5260      	mov	_TIM2_ARRL,#255
3372                     ; 12 	TIM2_SR1&=~0x01;
3374  0014 72115256      	bres	_TIM2_SR1,#0
3375                     ; 13 }
3378  0018 87            	retf
3406                     ; 15 void TIM2_INIT_Middle(void)//主报警用
3406                     ; 16 {
3407                     .text:	section	.text,new
3408  0000               f_TIM2_INIT_Middle:
3412                     ; 17 	CLK_PCKENR1|=0X01;      //打开TIM2时钟
3414  0000 721050c3      	bset	_CLK_PCKENR1,#0
3415                     ; 19 	TIM2_CR1 =0X80;   //预 边 上 单脉冲 禁计
3417  0004 35805250      	mov	_TIM2_CR1,#128
3418                     ; 20 	TIM2_PSCR =0X05; //分频4=mhz T=us
3420  0008 3505525e      	mov	_TIM2_PSCR,#5
3421                     ; 22 	TIM2_ARRH =0Xbb;
3423  000c 35bb525f      	mov	_TIM2_ARRH,#187
3424                     ; 23 	TIM2_ARRL =0Xbb;   //8MHz 32Div 
3426  0010 35bb5260      	mov	_TIM2_ARRL,#187
3427                     ; 25 	TIM2_SR1&=~0x01;
3429  0014 72115256      	bres	_TIM2_SR1,#0
3430                     ; 26 }
3433  0018 87            	retf
3461                     ; 28 void TIM2_INIT_Fast(void)//配对时用
3461                     ; 29 {
3462                     .text:	section	.text,new
3463  0000               f_TIM2_INIT_Fast:
3467                     ; 30 	CLK_PCKENR1|=0X01;      //打开TIM2时钟
3469  0000 721050c3      	bset	_CLK_PCKENR1,#0
3470                     ; 32 	TIM2_CR1 =0X80;   //预 边 上 单脉冲 禁计
3472  0004 35805250      	mov	_TIM2_CR1,#128
3473                     ; 33 	TIM2_PSCR =0X05; //分频4=mhz T=us
3475  0008 3505525e      	mov	_TIM2_PSCR,#5
3476                     ; 35 	TIM2_ARRH =0Xa2;
3478  000c 35a2525f      	mov	_TIM2_ARRH,#162
3479                     ; 36 	TIM2_ARRL =0X0f;   //8MHz 32Div a20f==0.1646s
3481  0010 350f5260      	mov	_TIM2_ARRL,#15
3482                     ; 38 	TIM2_SR1&=~0x01;
3484  0014 72115256      	bres	_TIM2_SR1,#0
3485                     ; 39 }
3488  0018 87            	retf
3514                     ; 41 void T1_Slow_for_ledbuz_EN(void)
3514                     ; 42 {
3515                     .text:	section	.text,new
3516  0000               f_T1_Slow_for_ledbuz_EN:
3520                     ; 43   TIM2_INIT_Slow();
3522  0000 8d000000      	callf	f_TIM2_INIT_Slow
3524                     ; 44 	TIM2_IER |=0x01;//TIM2_IER |=0x40;//使能中断
3526  0004 72105255      	bset	_TIM2_IER,#0
3527                     ; 45   TIM2_CR1 |=0X01;
3529  0008 72105250      	bset	_TIM2_CR1,#0
3530                     ; 46 }
3533  000c 87            	retf
3559                     ; 47 void T1_Middle_for_ledbuz_EN(void)
3559                     ; 48 {
3560                     .text:	section	.text,new
3561  0000               f_T1_Middle_for_ledbuz_EN:
3565                     ; 49   TIM2_INIT_Middle();
3567  0000 8d000000      	callf	f_TIM2_INIT_Middle
3569                     ; 50 	TIM2_IER |=0x01;//TIM2_IER |=0x40;//使能中断
3571  0004 72105255      	bset	_TIM2_IER,#0
3572                     ; 51   TIM2_CR1 |=0X01;
3574  0008 72105250      	bset	_TIM2_CR1,#0
3575                     ; 52 }
3578  000c 87            	retf
3604                     ; 53 void T1_Fast_for_ledbuz_EN(void)
3604                     ; 54 {
3605                     .text:	section	.text,new
3606  0000               f_T1_Fast_for_ledbuz_EN:
3610                     ; 55   TIM2_INIT_Fast();
3612  0000 8d000000      	callf	f_TIM2_INIT_Fast
3614                     ; 56 	TIM2_IER |=0x01;//TIM2_IER |=0x40;//使能中断
3616  0004 72105255      	bset	_TIM2_IER,#0
3617                     ; 57   TIM2_CR1 |=0X01;
3619  0008 72105250      	bset	_TIM2_CR1,#0
3620                     ; 58 }
3623  000c 87            	retf
3648                     ; 59 void T1_for_ledbuz_DIS(void)
3648                     ; 60 {
3649                     .text:	section	.text,new
3650  0000               f_T1_for_ledbuz_DIS:
3654                     ; 61   TIM2_CR1 &=~0X01;
3656  0000 72115250      	bres	_TIM2_CR1,#0
3657                     ; 62 	TIM2_IER &=~0x40;//使能中断
3659  0004 721d5255      	bres	_TIM2_IER,#6
3660                     ; 63 	CLK_PCKENR1&=~0X01;      //关闭TIM2时钟
3662  0008 721150c3      	bres	_CLK_PCKENR1,#0
3663                     ; 64 }
3666  000c 87            	retf
3678                     	xdef	f_T1_for_ledbuz_DIS
3679                     	xdef	f_T1_Fast_for_ledbuz_EN
3680                     	xdef	f_T1_Middle_for_ledbuz_EN
3681                     	xdef	f_T1_Slow_for_ledbuz_EN
3682                     	xdef	f_TIM2_INIT_Fast
3683                     	xdef	f_TIM2_INIT_Middle
3684                     	xdef	f_TIM2_INIT_Slow
3703                     	end
