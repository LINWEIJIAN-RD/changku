   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3351                     ; 3 void GPIO_INIT(void)
3351                     ; 4 {
3352                     .text:	section	.text,new
3353  0000               f_GPIO_INIT:
3357                     ; 5 	GPO3In();
3359  0000 7211500c      	bres	_PC_DDR,#0
3360                     ; 6   GPO3IT();
3362  0004 7210500e      	bset	_PC_CR2,#0
3363                     ; 7   EXTI_CR1|=0x01;//PC0 Rising 
3365  0008 721050a0      	bset	_EXTI_CR1,#0
3366                     ; 9   PC_DDR|=0x10;//LED
3368  000c 7218500c      	bset	_PC_DDR,#4
3369                     ; 10 	PC_CR1|=0x10;
3371  0010 7218500d      	bset	_PC_CR1,#4
3372                     ; 12 	PB_DDR|=0x03;
3374  0014 c65007        	ld	a,_PB_DDR
3375  0017 aa03          	or	a,#3
3376  0019 c75007        	ld	_PB_DDR,a
3377                     ; 13 	PB_CR1|=0x03;
3379  001c c65008        	ld	a,_PB_CR1
3380  001f aa03          	or	a,#3
3381  0021 c75008        	ld	_PB_CR1,a
3382                     ; 14 }
3385  0024 87            	retf
3423                     ; 16 void IOconfig(void)
3423                     ; 17 {
3424                     .text:	section	.text,new
3425  0000               f_IOconfig:
3429                     ; 18   PB_DDR |=0X7F;   //OUT 0111 1111  PB7 AD
3431  0000 c65007        	ld	a,_PB_DDR
3432  0003 aa7f          	or	a,#127
3433  0005 c75007        	ld	_PB_DDR,a
3434                     ; 19 	PB_CR1 |=0X7F;   //TW  0111 1111
3436  0008 c65008        	ld	a,_PB_CR1
3437  000b aa7f          	or	a,#127
3438  000d c75008        	ld	_PB_CR1,a
3439                     ; 20 	PB_CR2 &=~0XFF;   //DS
3441  0010 c65009        	ld	a,_PB_CR2
3442  0013 a400          	and	a,#0
3443  0015 c75009        	ld	_PB_CR2,a
3444                     ; 21 	PB_ODR=0X00;     //    0001 0000
3446  0018 725f5005      	clr	_PB_ODR
3447                     ; 23 	PC_DDR=0XFC;   //OUT 1111 1100  PC1=key  PC0=GPIO1 (有待考虑是否一直打开会有影响)
3449  001c 35fc500c      	mov	_PC_DDR,#252
3450                     ; 24 	PC_CR1=0XFC;   //TW  1111 1100
3452  0020 35fc500d      	mov	_PC_CR1,#252
3453                     ; 25 	PC_CR2=0X03;   //DS
3455  0024 3503500e      	mov	_PC_CR2,#3
3456                     ; 26 	PC_ODR=0X20;   //    0010 0000
3458  0028 3520500a      	mov	_PC_ODR,#32
3459                     ; 28 	PA_DDR |=0XFD;    //OUT 1111 1101
3461  002c c65002        	ld	a,_PA_DDR
3462  002f aafd          	or	a,#253
3463  0031 c75002        	ld	_PA_DDR,a
3464                     ; 29 	PA_CR1 |=0XFD;    //TW
3466  0034 c65003        	ld	a,_PA_CR1
3467  0037 aafd          	or	a,#253
3468  0039 c75003        	ld	_PA_CR1,a
3469                     ; 30 	PA_CR2 &=~0XFD;   //DS
3471  003c c65004        	ld	a,_PA_CR2
3472  003f a402          	and	a,#2
3473  0041 c75004        	ld	_PA_CR2,a
3474                     ; 31 	PA_ODR=0X00;      //00
3476  0044 725f5000      	clr	_PA_ODR
3477                     ; 33 	PD_DDR=0XFF;   //OUT
3479  0048 35ff5011      	mov	_PD_DDR,#255
3480                     ; 34 	PD_CR1=0XFF;   //TW
3482  004c 35ff5012      	mov	_PD_CR1,#255
3483                     ; 35 	PD_CR2=0X00;   //DS
3485  0050 725f5013      	clr	_PD_CR2
3486                     ; 36 	PD_ODR=0X01;   //00
3488  0054 3501500f      	mov	_PD_ODR,#1
3489                     ; 37 }
3492  0058 87            	retf
3504                     	xdef	f_IOconfig
3505                     	xdef	f_GPIO_INIT
3524                     	end
