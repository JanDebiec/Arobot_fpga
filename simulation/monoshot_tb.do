#on windows
set localpath "c:\\project\\arobot\\fpga\\c4_base"
#on linux
#set localpath "/home/jan/project/arobot/fpga/c4_base"

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
vcom -93 -work work $localpath\\source\\arobot_tcc_pkg.vhd
vcom -93 -work work $localpath\\source\\monoshot.vhd

# from testbench
vcom -93 -work work $localpath\\testbench\\monoshot_TB.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  monoshot_TB

add wave monoshot_TB/U_DUT/*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 20 us
wave zoom full