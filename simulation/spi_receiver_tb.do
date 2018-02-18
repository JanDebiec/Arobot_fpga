#on windows
set localpath "c:\\project\\msystem\\fpga\\design\\de0_c4"
#on linux
#set localpath "/home/jan/project/arobot/fpga/c4_base"

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
vcom -2008  -work work $localpath\\source\\msystem_tcc_pkg.vhd
vcom -2008  -work work $localpath\\source\\monoshot.vhd
vcom -2008  -work work $localpath\\source\\spi_receiver.vhd

# from testbench
vcom -2008  -work work $localpath\\testbench\\msystem_stim_tcc_pkg.vhd
vcom -2008  -work work $localpath\\testbench\\msystem_stim_fp_pkg.vhd
vcom -2008  -work work $localpath\\testbench\\spi_receiver_TB.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  spi_receiver_TB

#add wave spi_receiver_TB/*
add wave spi_receiver_TB/U_DUT/*

radix -hexadecimal
#view structure
#view signals

set StdArithNoWarnings 1


run 600 ns
wave zoom full