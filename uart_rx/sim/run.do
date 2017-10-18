quit -sim
.main clear
vlib work

vlog ./tb_uart_rx.v
vlog ./../design/*.v

vsim -voptargs=+acc tb_uart_rx

add wave tb_uart_rx/uart_rx_inst/*


run 100us