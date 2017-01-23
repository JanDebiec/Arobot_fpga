
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
vcom -93 -work work $localpath\\source\\arobot_tcc_pkg.vhd
vcom -93 -work work $localpath\\source\\micro_lut.vhd
vcom -93 -work work $localpath\\source\\sinus_calc.vhd

# from testbench

vcom -93 -work work $localpath\\testbench\\arobot_base_stim_fp_pkg.vhd
vcom -93 -work work $localpath\\testbench\\sinus_calc_TB.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  sinus_calc_TB

add wave sinus_calc_TB/U_DUT/*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 20 us
wave zoom full