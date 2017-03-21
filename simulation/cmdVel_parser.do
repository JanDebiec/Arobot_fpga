
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
vcom -2008 -work work $localpath\\source\\globals\\arobot_typedef_pkg.vhd
#vcom -2008 -work work $localpath\\source\\globals\\arobot_constant_pkg.vhd
#vcom -2008 -work work $localpath\\source\\globals\\arobot_component_pkg.vhd
vcom -2008 -work work $localpath\\source\\basics\\monoshot.vhd
vcom -2008 -work work $localpath\\source\\cmdVel_parser.vhd

# from testbench
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_tcc_pkg.vhd
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_fp_pkg.vhd
vcom -2008 -work work $localpath\\testbench\\cmdVel_parser_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  cmdVel_parser_TB

add wave cmdVel_parser_TB/*
add wave cmdVel_parser_TB/U_DUT/i*
add wave cmdVel_parser_TB/U_DUT/t*
add wave cmdVel_parser_TB/U_DUT/sl*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 20 us
wave zoom full
