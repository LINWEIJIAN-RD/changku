   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  53                     ; 2 void delay_us(unsigned int x)   //实测1000=872 
  53                     ; 3 {
  54                     .text:	section	.text,new
  55  0000               f_delay_us:
  57  0000 89            	pushw	x
  58       00000000      OFST:	set	0
  61  0001               L72:
  62                     ; 4 	while(x--);
  64  0001 1e01          	ldw	x,(OFST+1,sp)
  65  0003 1d0001        	subw	x,#1
  66  0006 1f01          	ldw	(OFST+1,sp),x
  67  0008 1c0001        	addw	x,#1
  68  000b a30000        	cpw	x,#0
  69  000e 26f1          	jrne	L72
  70                     ; 5 }
  73  0010 85            	popw	x
  74  0011 87            	retf
 113                     ; 8 void delay_ms(unsigned int ms)
 113                     ; 9 {
 114                     .text:	section	.text,new
 115  0000               f_delay_ms:
 117  0000 89            	pushw	x
 118  0001 89            	pushw	x
 119       00000002      OFST:	set	2
 122  0002 2014          	jra	L35
 123  0004               L15:
 124                     ; 13 		for(i=900;i>0;i--)
 126  0004 ae0384        	ldw	x,#900
 127  0007 1f01          	ldw	(OFST-1,sp),x
 128  0009               L75:
 129                     ; 15 			_asm("nop"); //一个asm("nop")函数经过示波器测试代表100ns
 132  0009 9d            nop
 134                     ; 16 			_asm("nop");
 137  000a 9d            nop
 139                     ; 17 			_asm("nop");
 142  000b 9d            nop
 144                     ; 18 			_asm("nop"); 
 147  000c 9d            nop
 149                     ; 13 		for(i=900;i>0;i--)
 151  000d 1e01          	ldw	x,(OFST-1,sp)
 152  000f 1d0001        	subw	x,#1
 153  0012 1f01          	ldw	(OFST-1,sp),x
 156  0014 1e01          	ldw	x,(OFST-1,sp)
 157  0016 26f1          	jrne	L75
 158  0018               L35:
 159                     ; 11 	while(ms--)
 161  0018 1e03          	ldw	x,(OFST+1,sp)
 162  001a 1d0001        	subw	x,#1
 163  001d 1f03          	ldw	(OFST+1,sp),x
 164  001f 1c0001        	addw	x,#1
 165  0022 a30000        	cpw	x,#0
 166  0025 26dd          	jrne	L15
 167                     ; 21 }
 170  0027 5b04          	addw	sp,#4
 171  0029 87            	retf
 210                     ; 24 void delay(unsigned int s)
 210                     ; 25 {
 211                     .text:	section	.text,new
 212  0000               f_delay:
 214  0000 89            	pushw	x
 215       00000002      OFST:	set	2
 218                     ; 27 	for(i=s;i>0;i--)
 220  0001 1f01          	ldw	(OFST-1,sp),x
 222  0003 200e          	jra	L701
 223  0005               L301:
 224                     ; 29 		delay_ms(10);
 226  0005 ae000a        	ldw	x,#10
 227  0008 8d000000      	callf	f_delay_ms
 229                     ; 27 	for(i=s;i>0;i--)
 231  000c 1e01          	ldw	x,(OFST-1,sp)
 232  000e 1d0001        	subw	x,#1
 233  0011 1f01          	ldw	(OFST-1,sp),x
 234  0013               L701:
 237  0013 1e01          	ldw	x,(OFST-1,sp)
 238  0015 26ee          	jrne	L301
 239                     ; 31 }
 242  0017 85            	popw	x
 243  0018 87            	retf
 255                     	xdef	f_delay
 256                     	xdef	f_delay_ms
 257                     	xdef	f_delay_us
 276                     	end
