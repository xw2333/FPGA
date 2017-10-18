quit -sim
.main clear
vlib work

vlog ./tb_uart_tx.v
vlog ./../design/*.v

vsim -voptargs=+acc tb_uart_tx

add wave tb_uart_tx/uart_tx_inst/*


run 100us