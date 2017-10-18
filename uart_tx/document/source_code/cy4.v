/////////////////////////////////////////////////////////////////////////////
//Altera ATPP������� ��о�Ƽ� Я�� ��Ȩͬѧ ��ͬ���� FPGA������ϵ��
//����Ӳ��ƽ̨�� Altera Cyclone IV FPGA 
//�����׼��ͺţ� SF-CY4 ��Ȩ����
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����SF-CY4�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
//�����������أ� http://pan.baidu.com/s/1jGpMIJc
//��                ˾�� �Ϻ�������ӿƼ����޹�˾
/////////////////////////////////////////////////////////////////////////////
//����PC�˷��͵�UART���ݣ�ԭ���ݷ��ظ�PC�ˣ���loopback����
module cy4(
			input ext_clk_25m,	//�ⲿ����25MHzʱ���ź�
			input ext_rst_n,	//�ⲿ���븴λ�źţ��͵�ƽ��Ч
			input uart_rx,		// UART���������ź�
			output uart_tx		// UART���������ź�
		);													

//-------------------------------------
//PLL����
wire clk_12m5;	//PLL���12.5MHzʱ��
wire clk_25m;	//PLL���25MHzʱ��
wire clk_50m;	//PLL���50MHzʱ��
wire clk_100m;	//PLL���100MHzʱ��
wire sys_rst_n;	//PLL�����locked�źţ���ΪFPGA�ڲ��ĸ�λ�źţ��͵�ƽ��λ���ߵ�ƽ��������

pll_controller	pll_controller_inst (
	.areset ( !ext_rst_n ),
	.inclk0 ( ext_clk_25m ),
	.c0 ( clk_12m5 ),
	.c1 ( clk_25m ),
	.c2 ( clk_50m ),
	.c3 ( clk_100m ),
	.locked ( sys_rst_n )
	);
		
//-------------------------------------
//������ĸ�ģ���У�speed_rx��speed_tx��������ȫ������Ӳ��ģ�飬�ɳ�֮Ϊ�߼�����
//��������Դ����������е�ͬһ���ӳ�����ò��ܻ�Ϊһ̸��

wire bps_start1,bps_start2;	//���յ����ݺ󣬲�����ʱ�������ź���λ
wire clk_bps1,clk_bps2;		// clk_bps_r�ߵ�ƽΪ��������λ���м������,ͬʱҲ��Ϊ�������ݵ����ݸı�� 
wire[7:0] rx_data;	//�������ݼĴ���������ֱ����һ����������
wire rx_int;		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ

	//UART�����źŲ���������
speed_setting		speed_rx(	
							.clk(clk_25m),	//������ѡ��ģ��
							.rst_n(sys_rst_n),
							.bps_start(bps_start1),
							.clk_bps(clk_bps1)
						);

	//UART�������ݴ���
my_uart_rx			my_uart_rx(		
							.clk(clk_25m),	//��������ģ��
							.rst_n(sys_rst_n),
							.uart_rx(uart_rx),
							.rx_data(rx_data),
							.rx_int(rx_int),
							.clk_bps(clk_bps1),
							.bps_start(bps_start1)
						);
		
//-------------------------------------

	//UART�����źŲ���������													
speed_setting		speed_tx(	
							.clk(clk_25m),	//������ѡ��ģ��
							.rst_n(sys_rst_n),
							.bps_start(bps_start2),
							.clk_bps(clk_bps2)
						);
						
	//UART�������ݴ���
my_uart_tx			my_uart_tx(		
							.clk(clk_25m),	//��������ģ��
							.rst_n(sys_rst_n),
							.rx_data(rx_data),
							.rx_int(rx_int),
							.uart_tx(uart_tx),
							.clk_bps(clk_bps2),
							.bps_start(bps_start2)
						);


endmodule

