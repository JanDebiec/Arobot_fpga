
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
#vcom -2008 -work work $localpath/source/globals/arobot_constant_pkg.vhd
#vcom -2008 -work work $localpath/source/globals/arobot_component_pkg.vhd
vcom -2008 -work work $localpath/source/uart/uart_parity.vhd
vcom -2008 -work work $localpath/source/uart/uart_rx.vhd
vcom -2008 -work work $localpath/source/uart/uart_tx.vhd
vcom -2008 -work work $localpath/source/uart/uart.vhd

# from testbench
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_tcc_pkg.vhd
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_fp_pkg.vhd
vcom -2008 -work work $localpath/testbench/uart_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  uart_TB

add wave uart_TB/*
add wave uart_TB/utt/*
add wave uart_TB/utt/uart_tx_i/*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 1 ms
wave zoom full
