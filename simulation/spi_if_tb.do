#on windows
set localpath "c:\\project\\msystem\\fpga\\design\\de0_custom_nios"
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
vcom -2008  -work work $localpath\\source\\deflipflop.vhd
vcom -2008  -work work $localpath\\source\\srflipflop.vhd
vcom -2008  -work work $localpath\\source\\monoshot.vhd
vcom -2008  -work work $localpath\\source\\mono_on_spiborder.vhd
vcom -2008  -work work $localpath\\source\\deflipflop.vhd
vcom -2008  -work work $localpath\\source\\spi_transmitter.vhd
vcom -2008  -work work $localpath\\source\\spi_receiver.vhd
vcom -2008  -work work $localpath\\source\\spi_output.vhd
vcom -2008  -work work $localpath\\source\\spi_if.vhd

# from testbench
vcom -2008  -work work $localpath\\testbench\\msystem_stim_tcc_pkg.vhd
vcom -2008  -work work $localpath\\testbench\\msystem_stim_fp_pkg.vhd
vcom -2008  -work work $localpath\\testbench\\spi_if_TB.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  spi_if_TB

add wave spi_if_TB/*
add wave spi_if_TB/U_DUT/*
#add wave  spi_if_TB/U_DUT/U_output/*
add wave  spi_if_TB/U_DUT/U_Receiver/*
#add wave  spi_if_TB/U_DUT/U_output/U_mono/*
add wave  spi_if_TB/U_DUT/U_output/U_transmitter/*
#add wave  -label reg spi_output_TB/U_DUT/U_transmitter/tx_buf
#add wave  -label reg_low spi_output_TB/U_DUT/U_transmitter/tx_buf_low
#add wave  -label reg_high spi_output_TB/U_DUT/U_transmitter/tx_buf_high

#add wave -label isl_validData   spi_output_TB/U_DUT/U_transmitter/isl_validData 
#add wave -label islv8_Data   spi_output_TB/U_DUT/U_transmitter/islv8_Data 
#add wave -label pre_tx_buf   spi_output_TB/U_DUT/U_transmitter/pre_tx_buf 
#add wave -label tx_buf   spi_output_TB/U_DUT/U_transmitter/tx_buf 
#add wave -label tx_buf_high   spi_output_TB/U_DUT/U_transmitter/tx_buf_high 
#add wave -label tx_buf_low   spi_output_TB/U_DUT/U_transmitter/tx_buf_low 
#add wave -label slv8_cntReg   spi_output_TB/U_DUT/U_transmitter/slv8_cntReg 


#add wave -label osl_miso   spi_output_TB/U_DUT/U_transmitter/osl_miso 
#add wave -label slv16_cntReg   spi_output_TB/U_DUT/U_transmitter/slv16_cntReg 


radix -hexadecimal
#view structure
#view signals

set StdArithNoWarnings 1


run 2 us
wave zoom full