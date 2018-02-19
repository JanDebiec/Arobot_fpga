
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
vcom -2008 -work work $localpath/source/globals/arobot_constant_pkg.vhd
vcom -2008 -work work $localpath/source/globals/arobot_component_pkg.vhd
vcom -2008 -work work $localpath/source/globals/arobot_typedef_pkg.vhd
vcom -2008  -work work $localpath/source/basics/monoshot.vhd
#vcom -2008  -work work $localpath/source/spi/spi_receiver.vhd
vcom -2008  -work work $localpath/source/cmd_parser_spi.vhd

# from testbench
vcom -2008  -work work $localpath/testbench/arobot_stim_tcc_pkg.vhd
vcom -2008  -work work $localpath/testbench/arobot_stim_fp_pkg.vhd
#vcom -2008  -work work $localpath/testbench/msystem_stim_fp_pkg.vhd
vcom -2008  -work work $localpath/testbench/spi_receiver_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  spi_receiver_tb

#add wave spi_receiver_tb/*
add wave spi_receiver_tb/U_DUT/*

radix -hexadecimal
#view structure
#view signals

set StdArithNoWarnings 1


run 600 ns
wave zoom full