//`define SIM
module uart_tx(
		// system signals
		input 			sclk 	,
		input 			s_rst_n ,
		// UART Interface
		input			tx_trig,
		input  [ 7:0]		uart_tx ,
		// others
		output 	reg	 	rs232_tx  
);
/********** Define Parameter and Internal Signals **************/
//====================================================================/
`ifndef SIM
localparam BAUD_END = 5207 ;
`else
localparam BAUD_END = 56 ;
`endif
localparam BAUD_M = BAUD_END/2 - 1 ;
localparam BIT_END = 8 ;
reg	[7:0]	uart_tx_reg;
reg 	[12:0]	baud_cnt ;
reg 		bit_flag ;
reg 	[ 3:0] 	bit_cnt ;
reg		tx_flag;

//=================================================================================
// *************** Main Code ****************
//=================================================================================
//tx_flag
always	@(posedge sclk or negedge s_rst_n)begin
if(!s_rst_n)
	tx_flag <= 1'b0;
else if(bit_cnt == 'd8 && bit_flag == 1'b1)
	tx_flag <= 1'b0;
else if(tx_trig == 1'b1)
	tx_flag <= 1'b1;
end
//uart_tx_reg
always	@(posedge sclk or negedge s_rst_n)begin
if(!s_rst_n)
	uart_tx_reg <= 8'd0;
else if (tx_trig == 1'b1)
	uart_tx_reg <= uart_tx;
end
//baud_cnt
always 	@(posedge sclk or negedge s_rst_n)begin
if(!s_rst_n)
	baud_cnt <= 'd0;
else if (baud_cnt == BAUD_END )
	baud_cnt <= 'd0;
else if(tx_flag == 1'b1)
	baud_cnt <= baud_cnt + 1'b1;
else 
	baud_cnt <= 'd0;
end
//bit_flag
always	@(posedge sclk or negedge s_rst_n)begin
if (!s_rst_n)
	bit_flag <= 1'b0;
else if (baud_cnt == BAUD_END)
	bit_flag <= 1'b1;
else 
	bit_flag <= 1'b0;
end
//bit_cnt 
always	@(posedge sclk or negedge s_rst_n)begin
if (!s_rst_n)
	bit_cnt <= 'd0;
else if (bit_cnt == BIT_END && bit_flag == 1'b1)
	bit_cnt <= 'd0;
else if(bit_flag == 1'b1 && tx_flag ==1'b1)
	bit_cnt <=bit_cnt + 1'b1;
end
//rs232_tx
always 	@(posedge sclk or negedge s_rst_n)begin
if(!s_rst_n)
	rs232_tx <= 1'b1;
else if(tx_flag ==1'b1)
	case(bit_cnt)
	0:	rs232_tx <=1'b0;
	1:	rs232_tx <= uart_tx_reg[0];
	2:	rs232_tx <= uart_tx_reg[1];
	3:	rs232_tx <= uart_tx_reg[2];
	4:	rs232_tx <= uart_tx_reg[3];
	5:	rs232_tx <= uart_tx_reg[4];
	6:	rs232_tx <= uart_tx_reg[5];
	7:	rs232_tx <= uart_tx_reg[6];
	8:	rs232_tx <= uart_tx_reg[7];		
	default: rs232_tx <= 1'b1;
	endcase	
else
	rs232_tx <= 1'b1;
end

endmodule