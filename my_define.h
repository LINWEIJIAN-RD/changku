#include<STM8L051F3.h>
#include<CMT2300drive.h>
#include<spi.h>

extern char has_code,hush_flag;
extern unsigned char str[4];
extern unsigned char getstr[4];
extern unsigned char flag_key;
extern unsigned int keydelay;
extern char get_msg_alarm;
extern unsigned char repeater;
extern char RSSI_val;

#define LEN 4

#define brue 0
#define red  4

#define LED_red P1_2
#define LED_brue P1_1
#define red_ON   PC_ODR|=0x10 //P1&=~(1<<brue)
#define red_OFF  PC_ODR&=~0x10 //P1|=(1<<brue)    #define	SetFCSB()	PC_ODR|=0X20
#define brue_ON    PB_ODR|=0x01 // P1&=~(1<<red)
#define brue_OFF   PB_ODR&=~0x01  //P1|=(1<<red)

//#define buz P0_1
#define ON   0
#define OFF  1

//#define TRUE   1
//#define FALSE  0
#define SUCCESS 1
#define FAIL 0
#define LINKDONE  2

#define alarm_code 0xF0
#define dis_alarm_code 0x0F
#define alarm_code_test 0xDD
#define master_test 0xDC
//#define hush_code 0xcc

#define slave_silence 0x33
#define all_silence 0x66
#define slave_ring 0xcc
#define master_ring 0x99
#define all_ring 0x77

#define TX_state 0x33
#define RX_state 0x55
#define Sleep_state 0x5A
#define RX_pream_pass 0xAA

#define RSSI_val_set 80 //35

#define CRYSTAL 0
//#define RC 1
//#define XOSC (SLEEP & 0x40)
//#define RC_STABLE (SLEEP & 0x20)
#define IRQ_DONE 0x10
//#define SFSTXON() do{RFST = 0x00;}while(0)
//#define SCAL() do{RFST = 0x01;}while(0)
#define SRX() do{RFST = 0x02;}while(0)
#define STX() do{RFST = 0x03;}while(0)
#define SIDLE() do{RFST = 0x04;}while(0)
//#define SAFC() do{RFST = 0x05;}while(0)
//#define SNOP() do{RFST = 0xFF;}while(0)

#define Sleep   _asm("halt")   //进入睡眠
#define IntDisable    _asm("sim") //关总中断
#define IntEnable     _asm("rim")  //开总中断

#define power_up_emitter {PB_DDR|=0x20;PB_CR1|=0x20;PB_ODR|=0x20;}  //PB5
#define power_up_amplify {PB_DDR|=0x40;PB_CR1|=0x40;PB_ODR|=0x40;}   //PB6
#define power_down_emitter {PB_DDR|=0x20;PB_CR1|=0x20;PB_ODR&=~0x20;}
#define power_down_amplify {PB_DDR|=0x40;PB_CR1|=0x40;PB_ODR&=~0x40;}

void CLK_Init(void);
void setup_Tx(void);
void setup_Rx(void);
void TX_fuction(unsigned char num);
void loop_Tx(void);
char loop_Rx(void);
char loop_Rx1(void);
void GET_repeater(void);
void RAM_write(void);
void RAM_read(void);
char RF_Receive(void);
char link(void);
char check_one(void);
void sleep(void);
void delay_us(unsigned int x);
void delay_ms(unsigned int ms);
void delay(unsigned int s);
void key(void);
void randum(void);
char Test_Device(void);

void GPIO_INIT(void);
void INT_key_Init(void);
void IOconfig(void);

void led_state(char led, char state);
void red_change(void);
void ledflash(char led, unsigned int num, unsigned int time_ON, unsigned int time_OFF);
void buz_state(char state);
void buz_change(void);

void calibrat(void);
void pow_check(void);

void TIM2_INIT_Slow(void);
void TIM2_INIT_Middle(void);
void TIM2_INIT_Fast(void);
void T1_Slow_for_ledbuz_EN(void);
void T1_Middle_for_ledbuz_EN(void);
void T1_Fast_for_ledbuz_EN(void);
void T1_for_ledbuz_DIS(void);

void ADC_Init(void);
float AD_VDD_val(void);
float AD_IR_val(void);
void IO_INIT(void);

