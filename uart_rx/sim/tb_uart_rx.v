
`timescale 1ns/1ns

module tb_uart_rx;

reg sclk;
reg s_rst_n;
reg uart_rx;
wire po_flag;
wire [ 7:0] rx_data;
reg [ 7:0] mem_a[3:0];

initial begin
	sclk = 1;
	s_rst_n <= 0;
	uart_rx <= 1;
#100
	s_rst_n <= 1;
#1000
	tx_byte();	
end

always #5 sclk = ~sclk;
initial $readmemh("./tx_data.txt", mem_a);

  task tx_byte();
	integer i;
	for(i=0; i<4; i=i+1) begin
	tx_bit(mem_a[i]);
	end
endtask
//每隔560发一个数据
task tx_bit(
	input [ 7:0] data
);
integer i;
for(i=0; i<10; i=i+1) begin
case(i)
	0: uart_rx <= 1'b0;
	1: uart_rx <= data[0];
	2: uart_rx <= data[1];
	3: uart_rx <= data[2];
	4: uart_rx <= data[3];
	5: uart_rx <= data[4];
	6: uart_rx <= data[5];
	7: uart_rx <= data[6];
	8: uart_rx <= data[7];
	9: uart_rx <= 1'b1;
endcase
	#560;//延时
end
endtask  

uart_rx uart_rx_inst(
		// system signals
		.sclk (sclk ),
		.s_rst_n (s_rst_n ),
		// UART Interface
		.rs232_rx (uart_rx ),
		// others
		.rx_data (rx_data ),
		.po_flag (po_flag )
);
endmodule
