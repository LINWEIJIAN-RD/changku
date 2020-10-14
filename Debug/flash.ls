   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
3350                     ; 13 void RAM_write(void)
3350                     ; 14 {
3351                     .text:	section	.text,new
3352  0000               f_RAM_write:
3356                     ; 15 	q = (char *)0x1010;
3358  0000 ae1010        	ldw	x,#4112
3359  0003 cf0000        	ldw	_q,x
3360                     ; 16 	FLASH_DUKR =0XAE;
3362  0006 35ae5053      	mov	_FLASH_DUKR,#174
3363                     ; 17 	FLASH_DUKR =0X56;
3365  000a 35565053      	mov	_FLASH_DUKR,#86
3367  000e               L5032:
3368                     ; 18 	while((FLASH_IAPSR & 0X08)==0);
3370  000e c65054        	ld	a,_FLASH_IAPSR
3371  0011 a508          	bcp	a,#8
3372  0013 27f9          	jreq	L5032
3373                     ; 19 	*q = str[0];
3375  0015 c60000        	ld	a,_str
3376  0018 72c70000      	ld	[_q.w],a
3377                     ; 20 	q=q+1;
3379  001c ce0000        	ldw	x,_q
3380  001f 1c0001        	addw	x,#1
3381  0022 cf0000        	ldw	_q,x
3382                     ; 21 	*q = str[1];
3384  0025 c60001        	ld	a,_str+1
3385  0028 72c70000      	ld	[_q.w],a
3386                     ; 22 	q=q+1;
3388  002c ce0000        	ldw	x,_q
3389  002f 1c0001        	addw	x,#1
3390  0032 cf0000        	ldw	_q,x
3391                     ; 23   *q = str[2];
3393  0035 c60002        	ld	a,_str+2
3394  0038 72c70000      	ld	[_q.w],a
3395                     ; 24 	q=q+1;
3397  003c ce0000        	ldw	x,_q
3398  003f 1c0001        	addw	x,#1
3399  0042 cf0000        	ldw	_q,x
3400                     ; 25   *q = has_code;
3402  0045 c60000        	ld	a,_has_code
3403  0048 72c70000      	ld	[_q.w],a
3405  004c               L5132:
3406                     ; 26 	while((FLASH_IAPSR & 0X04)==0);
3408  004c c65054        	ld	a,_FLASH_IAPSR
3409  004f a504          	bcp	a,#4
3410  0051 27f9          	jreq	L5132
3411                     ; 27 	FLASH_IAPSR &=~0X08;
3413  0053 72175054      	bres	_FLASH_IAPSR,#3
3414                     ; 29 }
3417  0057 87            	retf
3442                     ; 31 void RAM_read(void)
3442                     ; 32 {
3443                     .text:	section	.text,new
3444  0000               f_RAM_read:
3448                     ; 33 	q=(char *)0x1010;
3450  0000 ae1010        	ldw	x,#4112
3451  0003 cf0000        	ldw	_q,x
3452                     ; 34   str[0] = *q;//出厂需要连一起的要给他写个码
3454  0006 5510100000    	mov	_str,4112
3455                     ; 35 	q=q+1;
3457  000b ae1011        	ldw	x,#4113
3458  000e cf0000        	ldw	_q,x
3459                     ; 36 	str[1] = *q;//出厂需要连一起的要给他写个码
3461  0011 5510110001    	mov	_str+1,4113
3462                     ; 37 	q=q+1;
3464  0016 ae1012        	ldw	x,#4114
3465  0019 cf0000        	ldw	_q,x
3466                     ; 38   str[2] = *q;
3468  001c 5510120002    	mov	_str+2,4114
3469                     ; 39 	q=q+1;
3471  0021 ae1013        	ldw	x,#4115
3472  0024 cf0000        	ldw	_q,x
3473                     ; 40   has_code = *q;
3475  0027 5510130000    	mov	_has_code,4115
3476                     ; 42 }
3479  002c 87            	retf
3491                     	xdef	f_RAM_read
3492                     	xdef	f_RAM_write
3493                     	xref	_q
3494                     	xref	_has_code
3495                     	xref	_str
3514                     	end
