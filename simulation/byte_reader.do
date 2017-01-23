
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
#vcom -93 -work work $localpath/source/fpga_main_tcc_pkg.vhd

vcom -93 -work work $localpath/ip/baudrate_counter.vhd
vcom -93 -work work $localpath/source/arobot_tcc_pkg.vhd
vcom -93 -work work $localpath/source/bit_filter.vhd
vcom -93 -work work $localpath/source/byte_reader.vhd

# from testbench
#vcom -93 -work work $localpath/testbench/fpga_main_stim_tcc_pkg.vhd
#vcom -93 -work work $localpath/testbench/fpga_main_stim_fp_pkg.vhd
vcom -93 -work work $localpath/testbench/bit_filter_tb.vhd
vcom -93 -work work $localpath/testbench/byte_reader_stim_fp_pkg.vhd
vcom -93 -work work $localpath/testbench/byte_reader_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  byte_reader_tb

add wave byte_reader_tb/U_DUT/*
add wave -position end  byte_reader_tb/slv_byteValueOutput
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 300 us
wave zoom full
