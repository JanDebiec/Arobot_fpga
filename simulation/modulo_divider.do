
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
#vcom -93 -work work $localpath/source/fpga_main_tcc_pkg.vhd
vcom -93 -work work $localpath/ip/n32_modulo_u8.vhd
vcom -93 -work work $localpath/source/arobot_tcc_pkg.vhd
vcom -93 -work work $localpath/source/modulo_divider.vhd

# from testbench
#vcom -93 -work work $localpath/testbench/fpga_main_stim_tcc_pkg.vhd
#vcom -93 -work work $localpath/testbench/fpga_main_stim_fp_pkg.vhd
vcom -93 -work work $localpath/testbench/modulo_divider_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  modulo_divider_tb

add wave modulo_divider_tb/U_DUT/*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 50 us
wave zoom full