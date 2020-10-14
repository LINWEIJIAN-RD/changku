   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3350                     ; 5 void INT_key_Init(void)
3350                     ; 6 {
3351                     .text:	section	.text,new
3352  0000               f_INT_key_Init:
3356                     ; 7 	PC_DDR &=0xFD;    //PC1设为输入 xxxxxx0x
3358  0000 7213500c      	bres	_PC_DDR,#1
3359                     ; 8 	PC_CR1 &=0xFD;    //PC1悬浮输入 xxxxxx0x
3361  0004 7213500d      	bres	_PC_CR1,#1
3362                     ; 9 	PC_CR2 |=0x02;    //PC1使能中断 00000010
3364  0008 7212500e      	bset	_PC_CR2,#1
3365                     ; 10 	ITC_SPR3=0xFB;    //端口PC1外部中断，优先级1
3367  000c 35fb7f72      	mov	_ITC_SPR3,#251
3368                     ; 11 	EXTI_CR1|=0X04;     //PortC中断选为上升沿触发
3370  0010 721450a0      	bset	_EXTI_CR1,#2
3371                     ; 12 }
3374  0014 87            	retf
3405                     ; 14 void key(void)
3405                     ; 15 {
3406                     .text:	section	.text,new
3407  0000               f_key:
3411                     ; 16   IntDisable;
3414  0000 9b            sim
3416                     ; 17   if((0<keydelay)&&(keydelay<400))
3418  0001 ce0000        	ldw	x,_keydelay
3419  0004 2710          	jreq	L1132
3421  0006 ce0000        	ldw	x,_keydelay
3422  0009 a30190        	cpw	x,#400
3423  000c 2408          	jruge	L1132
3424                     ; 19     keydelay=0;
3426  000e 5f            	clrw	x
3427  000f cf0000        	ldw	_keydelay,x
3428                     ; 20     flag_key=1;  
3430  0012 35010000      	mov	_flag_key,#1
3431  0016               L1132:
3432                     ; 22   if((400<=keydelay)&&(keydelay<500))
3434  0016 ce0000        	ldw	x,_keydelay
3435  0019 a30190        	cpw	x,#400
3436  001c 2510          	jrult	L3132
3438  001e ce0000        	ldw	x,_keydelay
3439  0021 a301f4        	cpw	x,#500
3440  0024 2408          	jruge	L3132
3441                     ; 24     keydelay=0;
3443  0026 5f            	clrw	x
3444  0027 cf0000        	ldw	_keydelay,x
3445                     ; 25     flag_key=2;
3447  002a 35020000      	mov	_flag_key,#2
3448  002e               L3132:
3449                     ; 27 	if((500<=keydelay)&&(keydelay<600))
3451  002e ce0000        	ldw	x,_keydelay
3452  0031 a301f4        	cpw	x,#500
3453  0034 2510          	jrult	L5132
3455  0036 ce0000        	ldw	x,_keydelay
3456  0039 a30258        	cpw	x,#600
3457  003c 2408          	jruge	L5132
3458                     ; 29     keydelay=0;
3460  003e 5f            	clrw	x
3461  003f cf0000        	ldw	_keydelay,x
3462                     ; 30     flag_key=3;
3464  0042 35030000      	mov	_flag_key,#3
3465  0046               L5132:
3466                     ; 32   if((600<=keydelay)&&(keydelay<700))
3468  0046 ce0000        	ldw	x,_keydelay
3469  0049 a30258        	cpw	x,#600
3470  004c 2510          	jrult	L7132
3472  004e ce0000        	ldw	x,_keydelay
3473  0051 a302bc        	cpw	x,#700
3474  0054 2408          	jruge	L7132
3475                     ; 34     keydelay=0;
3477  0056 5f            	clrw	x
3478  0057 cf0000        	ldw	_keydelay,x
3479                     ; 35     flag_key=4; 
3481  005a 35040000      	mov	_flag_key,#4
3482  005e               L7132:
3483                     ; 37   keydelay=0;
3485  005e 5f            	clrw	x
3486  005f cf0000        	ldw	_keydelay,x
3487                     ; 38   IntEnable;
3490  0062 9a            rim
3492                     ; 39 	if(flag_key==1)
3494  0063 c60000        	ld	a,_flag_key
3495  0066 a101          	cp	a,#1
3496  0068 2608          	jrne	L1232
3497                     ; 41 		get_msg_alarm=master_test;
3499  006a 35dc0000      	mov	_get_msg_alarm,#220
3500                     ; 42 		flag_key=0;
3502  006e 725f0000      	clr	_flag_key
3503  0072               L1232:
3504                     ; 44 	if((flag_key==2)||(flag_key==3) )  //进入配对状态
3506  0072 c60000        	ld	a,_flag_key
3507  0075 a102          	cp	a,#2
3508  0077 2707          	jreq	L5232
3510  0079 c60000        	ld	a,_flag_key
3511  007c a103          	cp	a,#3
3512  007e 2608          	jrne	L3232
3513  0080               L5232:
3514                     ; 47 		link();
3516  0080 8d000000      	callf	f_link
3518                     ; 48 		flag_key=0;
3520  0084 725f0000      	clr	_flag_key
3521  0088               L3232:
3522                     ; 51 	if(flag_key==4)  //清除码
3524  0088 c60000        	ld	a,_flag_key
3525  008b a104          	cp	a,#4
3526  008d 2632          	jrne	L7232
3527                     ; 53 		str[0]=0xFF;str[1]=0xFF;str[2]=0xFF;has_code=0xFF;  //写空数据
3529  008f 35ff0000      	mov	_str,#255
3532  0093 35ff0001      	mov	_str+1,#255
3535  0097 35ff0002      	mov	_str+2,#255
3538  009b 35ff0000      	mov	_has_code,#255
3539                     ; 54 		RAM_write();
3541  009f 8d000000      	callf	f_RAM_write
3543                     ; 55 		delay(50);
3545  00a3 ae0032        	ldw	x,#50
3546  00a6 8d000000      	callf	f_delay
3548                     ; 56 		ledflash(brue,3,50,50);
3550  00aa ae0032        	ldw	x,#50
3551  00ad 89            	pushw	x
3552  00ae ae0032        	ldw	x,#50
3553  00b1 89            	pushw	x
3554  00b2 ae0003        	ldw	x,#3
3555  00b5 89            	pushw	x
3556  00b6 4f            	clr	a
3557  00b7 8d000000      	callf	f_ledflash
3559  00bb 5b06          	addw	sp,#6
3560                     ; 57 		flag_key=0;
3562  00bd 725f0000      	clr	_flag_key
3563  00c1               L7232:
3564                     ; 59 }
3567  00c1 87            	retf
3579                     	xref	f_ledflash
3580                     	xdef	f_INT_key_Init
3581                     	xdef	f_key
3582                     	xref	f_delay
3583                     	xref	f_link
3584                     	xref	f_RAM_write
3585                     	xref	_get_msg_alarm
3586                     	xref	_keydelay
3587                     	xref	_flag_key
3588                     	xref	_str
3589                     	xref	_has_code
3608                     	end
