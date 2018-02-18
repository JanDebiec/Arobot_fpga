
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source
#vcom -2008  -work work $localpath/source/msystem_tcc_pkg.vhd
vcom -2008 -work work $localpath/source/globals/arobot_constant_pkg.vhd
vcom -2008 -work work $localpath/source/globals/arobot_component_pkg.vhd
vcom -2008 -work work $localpath/source/globals/arobot_typedef_pkg.vhd
vcom -2008  -work work $localpath/source/basics/monoshot.vhd
vcom -2008  -work work $localpath/source/spi/spi_transmitter.vhd

# from testbench
vcom -2008  -work work $localpath/testbench/arobot_stim_tcc_pkg.vhd
vcom -2008  -work work $localpath/testbench/arobot_stim_fp_pkg.vhd
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_tcc_pkg.vhd
#vcom -2008 -work work $localpath/testbench/fpga_main_stim_fp_pkg.vhd
vcom -2008  -work work $localpath/testbench/spi_transmitter_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  spi_transmitter_tb

add wave spi_transmitter_tb/*
#add wave spi_transmitter_tb/U_DUT/*
add wave -label clk   spi_transmitter_tb/U_DUT/isl_SpiClk 


#add wave -label internSpiClk   spi_transmitter_TB/U_DUT/internSpiClk 
#add wave -label mode   spi_transmitter_TB/U_DUT/mode 
add wave -label isl_TxActive   spi_transmitter_TB/U_DUT/isl_TxActive 

add wave -label isl_validData   spi_transmitter_TB/U_DUT/isl_validData 
add wave -label islv8_Data   spi_transmitter_TB/U_DUT/islv8_Data 
add wave -label pre_tx_buf   spi_transmitter_TB/U_DUT/pre_tx_buf 
add wave -label tx_buf   spi_transmitter_TB/U_DUT/tx_buf 
add wave -label tx_buf_high   spi_transmitter_TB/U_DUT/tx_buf_high 
add wave -label tx_buf_low   spi_transmitter_TB/U_DUT/tx_buf_low 
add wave -label slv8_cntReg   spi_transmitter_TB/U_DUT/slv8_cntReg 


add wave -label osl_miso   spi_transmitter_TB/U_DUT/osl_miso 
add wave -label slv16_cntReg   spi_transmitter_TB/U_DUT/slv16_cntReg 




radix -hexadecimal
#view structure
#view signals

set StdArithNoWarnings 1


run 600 ns
wave zoom full