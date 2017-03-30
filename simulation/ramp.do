
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
vcom -2008 -work work $localpath\\ip\\baudrate_counter.vhd
vcom -2008 -work work $localpath\\source\\globals\\arobot_constant_pkg.vhd
vcom -2008 -work work $localpath\\source\\globals\\arobot_component_pkg.vhd
vcom -2008 -work work $localpath\\source\\bit_filter.vhd
vcom -2008 -work work $localpath\\source\\byte_reader.vhd
vcom -2008 -work work $localpath\\source\\receiver.vhd
vcom -2008 -work work $localpath\\source\\ramp.vhd

# from testbench
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_tcc_pkg.vhd
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_fp_pkg.vhd
vcom -2008 -work work $localpath\\testbench\\bit_filter_TB.vhd
vcom -2008 -work work $localpath\\testbench\\byte_reader_stim_fp_pkg.vhd
vcom -2008 -work work $localpath\\testbench\\byte_reader_TB.vhd
vcom -2008 -work work $localpath\\testbench\\ramp_TB.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  ramp_TB

add wave ramp_TB/U_DUT/*
#add wave -position end  byte_reader_tb/slv_byteValueOutput
#add wave -position end  ramp_tb/sl_sliceTick
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 1 ms
wave zoom full
