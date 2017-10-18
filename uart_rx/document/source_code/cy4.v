/////////////////////////////////////////////////////////////////////////////
//Altera ATPP合作伙伴 至芯科技 携手 特权同学 共同打造 FPGA开发板系列
//工程硬件平台： Altera Cyclone IV FPGA 
//开发套件型号： SF-CY4 特权打造
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供SF-CY4开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
//最新资料下载： http://pan.baidu.com/s/1jGpMIJc
//公                司： 上海或与电子科技有限公司
/////////////////////////////////////////////////////////////////////////////
//接收PC端发送的UART数据，原数据返回给PC端，即loopback功能
module cy4(
			input ext_clk_25m,	//外部输入25MHz时钟信号
			input ext_rst_n,	//外部输入复位信号，低电平有效
			input uart_rx,		// UART接收数据信号
			output uart_tx		// UART发送数据信号
		);													

//-------------------------------------
//PLL例化
wire clk_12m5;	//PLL输出12.5MHz时钟
wire clk_25m;	//PLL输出25MHz时钟
wire clk_50m;	//PLL输出50MHz时钟
wire clk_100m;	//PLL输出100MHz时钟
wire sys_rst_n;	//PLL输出的locked信号，作为FPGA内部的复位信号，低电平复位，高电平正常工作

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
//下面的四个模块中，speed_rx和speed_tx是两个完全独立的硬件模块，可称之为逻辑复制
//（不是资源共享，和软件中的同一个子程序调用不能混为一谈）

wire bps_start1,bps_start2;	//接收到数据后，波特率时钟启动信号置位
wire clk_bps1,clk_bps2;		// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点 
wire[7:0] rx_data;	//接收数据寄存器，保存直至下一个数据来到
wire rx_int;		//接收数据中断信号,接收到数据期间始终为高电平

	//UART接收信号波特率设置
speed_setting		speed_rx(	
							.clk(clk_25m),	//波特率选择模块
							.rst_n(sys_rst_n),
							.bps_start(bps_start1),
							.clk_bps(clk_bps1)
						);

	//UART接收数据处理
my_uart_rx			my_uart_rx(		
							.clk(clk_25m),	//接收数据模块
							.rst_n(sys_rst_n),
							.uart_rx(uart_rx),
							.rx_data(rx_data),
							.rx_int(rx_int),
							.clk_bps(clk_bps1),
							.bps_start(bps_start1)
						);
		
//-------------------------------------

	//UART发送信号波特率设置													
speed_setting		speed_tx(	
							.clk(clk_25m),	//波特率选择模块
							.rst_n(sys_rst_n),
							.bps_start(bps_start2),
							.clk_bps(clk_bps2)
						);
						
	//UART发送数据处理
my_uart_tx			my_uart_tx(		
							.clk(clk_25m),	//发送数据模块
							.rst_n(sys_rst_n),
							.rx_data(rx_data),
							.rx_int(rx_int),
							.uart_tx(uart_tx),
							.clk_bps(clk_bps2),
							.bps_start(bps_start2)
						);


endmodule

