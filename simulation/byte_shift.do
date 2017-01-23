
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
vcom -93 -work work $localpath/ip/shift_reg_48bits.vhd
vcom -93 -work work $localpath/source/arobot_tcc_pkg.vhd
#vcom -93 -work work $localpath/source/bit_filter.vhd
vcom -93 -work work $localpath/source/byte_reader.vhd
vcom -93 -work work $localpath/source/pulse_generator.vhd
vcom -93 -work work $localpath/source/shift_latch.vhd
vcom -93 -work work $localpath/source/byte_and_shift.vhd

# from testbench
vcom -93 -work work $localpath/testbench/byte_reader_stim_fp_pkg.vhd
vcom -93 -work work $localpath/testbench/byte_and_shift_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  byte_and_shift_tb

add wave byte_and_shift_tb/U_DUT/*
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/U_ShiftReg/enable
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/U_ShiftReg/q
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/U_ShiftReg/sclr
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/U_ShiftReg/shiftin
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/U_ShiftReg/sub_wire0
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/islv8_MagicWord
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/osl_outputValid
#add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/oslv_shortA
#add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/oslv_shortB
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/sl_MagicWordEqual
#add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/slv16_OutputA
#add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/slv16_OutputB
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/slv48_regOutput
add wave -position end  byte_and_shift_tb/U_DUT/U_ShiftReg/slv8_FirstByte
add wave -position end  byte_and_shift_tb/slv8_byteValue

radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 2000 us
wave zoom full
