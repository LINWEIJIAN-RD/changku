/*****�˴�ͨ��RFPDK���������Ȼ�����ÿ�������еĲ��� *****/
/************************************************************
Ƶ��:  433.92Mhz
����:  2.4Kpbs
Ƶƫ:  +/-10Khz
����:  +/-100khz
���ݰ���ʽ:
		0xAAAAAAAAAAAAAAAA + 0x2DD4 +0x15 +"HopeRF RFM COBRFM300A" 

���书��: 13dBm
**************************************************************/
	unsigned int CMTBank[12] = {
					  0x0000,
						0x0166,
						0x02EC,
						0x031C,
						0x0470,
						0x0580,
						0x0614,
						0x0708,
						0x0891,
						0x0902,
						0x0A02,
						0x0BD0
						/*0x0000,
						0x0166,
						0x02EC,                                         
						0x031C,
						0x0470,
						0x0580,
						0x0614,
						0x0708,
						0x0891,
						0x0902,
						0x0A02,
						0x0BD0*/
					   };
					   
	unsigned int SystemBank[12] = {
					 /* 0x0CAE,
						0x0DE0,
						0x0E35,  //TX EXIT STATE
						0x0F00,
						0x1000,
						0x11F4,
						0x1210,
						0x13E2,
						0x1442,
						0x1520,
						0x1600,
						0x1781*/
						0x0CAE,
						0x0DF0,//SLEEP_TIMER_EN(3bit)=0  TX_DC_EN(2bit)=0  //0x0DF0,��TX_DC_EN���һ�η���������ʱ��ģʽ�����·����жϽ�
						0x0E39,//0x0E35,//~~~��ͬ~~~��0x0E35,//TX_EXIT_STATE(3bit 2bit)=0 0: SLEEP 1��STBY 2��TFS 3��NA     //0x0E35,
						0x0F00,
						0x1000,
						0x1132,//T1 2ms=3200
						0x1200,//T1
						0x13FA,//T2 200ms=E242   FA00=10ms
						0x1400,//T2
						0x152B,//ģʽ
						0x1620,
						0x1701	//PJD=8��				0��4 ��   1��6 ��    2��8 ��    3: 10 ��						
						};
	
	unsigned int FrequencyBank[8] = {
					  0x1842,
						0x1971,
						0x1ACE,
						0x1B1C,
						0x1C42,
						0x1D5B,
						0x1E1C,
						0x1F1C
						 /*0x1842,
						0x1971,
						0x1ACE,
						0x1B1C,
						0x1C42,
						0x1D5B,
						0x1E1C,
						0x1F1C*/
							  };
							 
	unsigned int DataRateBank[24] = {
					  0x203F,
						0x21F0,
						0x2263,
						0x2310,
						0x2463,
						0x2512,
						0x260B,
						0x270A,
						0x289F,
						0x296C,
						0x2A29,
						0x2B29,
						0x2CC0,
						0x2D04,
						0x2E01,
						0x2F53,
						0x3020,
						0x3100,
						0x32B4,
						0x3300,
						0x3400,
						0x351C,//-100=RSSI       old RSSI 0x3540
						0x3600,
						0x3700
						/*0x2032,
						0x2118,
						0x2200,
						0x2399,
						0x24C1,
						0x259B,
						0x2606,
						0x270A,
						0x289F,
						0x2939,
						0x2A29,
						0x2B29,
						0x2CC0,
						0x2D51,
						0x2E2A,
						0x2F53,
						0x3000,
						0x3100,
						0x32B4,
						0x3300,
						0x3400,
						0x3501,
						0x3600,
						0x3700*/
							};	   
	
	unsigned int BasebandBank[29] = {
					  0x3812,//~~~~~~��0x380A,//RX_PREAM_SIZE [7:3](0=0)  PREAM_LENG_UNIT[2](ѡ��0=8����1=4��PREAM)  DATA_MODE [1:0](ֱ��0/��2)
						0x3908,//TX_PREAM_SIZE [7:0](0=0)
						0x3A00,//TX_PREAM_SIZE [15:8]
						0x3BAA,//PREAM_VALUE [7:0]( PREAM_LENG_UNIT =1 ʱֻ��<3:0>��Ч)
						0x3C04,//SYNC_TOL<6:4>�ݴ�  SYNC_SIZE<3:1>  SYNC_MAN_EN<0>
						0x3D00,//0x3D~44Ϊsync 44λ��ʼ
						0x3E00,
						0x3F00,
						0x4000,
						0x4100,
						0x42D4,
						0x432D,
						0x44D2,
						0x4500,// 0x4502������Ч����7λ��0λ��0��7˳���� 00������Ч����7λ��0λ��7��0˳����
						0x4603,//���ݳ���3=4byte
						0x4700,
						0x4800,
						0x4900,
						0x4A00,
						0x4B00,
						0x4C00,
						0x4D00,
						0x4E00,
						0x4F60,
						0x50FF,
						0x5100,
						0x52ff,//packet number  0xFF=�ظ�����255��
						0x5301,//~~~~~~��0x531F,//ÿ����֮��������bit
						0x5480//~~~~~~��0x5410 //FIFO_AUTO_RES_EN(bit8) ���ó� 1 �ظ�����FIFO
						/*	0x380A,
						0x3908,
						0x3A00,
						0x3BAA,
						0x3C04,
						0x3D00,
						0x3E00,
						0x3F00,
						0x4000,
						0x4100,
						0x42D4,
						0x432D,
						0x44D2,
						0x4500,
						0x4607,//���ݳ���
						0x4700,
						0x4800,
						0x4900,
						0x4A00,
						0x4B00,
						0x4C00,
						0x4D00,
						0x4E00,
						0x4F60,
						0x50FF,
						0x5100,
						0x5200,
						0x531F,
						0x5410		*/				
							};	
	
	unsigned int TXBank[11] = {
							0x5550,
						0x560E,
						0x5716,
						0x5800,
						0x5900,
						0x5A30,
						0x5B00,
						0x5C8A,//20DB
						0x5D18,
						0x5E3F,
						0x5F7F	
					 /* 0x5550,
						0x5626,
						0x5703,
						0x5800,
						0x5942,	
	          0x5AB0,
						0x5B00,
						0x5C37,
						0x5D0A,
						0x5E3F,
						0x5F7F	*/						
							};