
source local_path.tcl

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


# from source

vcom -93 -work work $localpath/ip/u32_div_u16.vhd
vcom -2008 -work work $localpath/source/globals/arobot_typedef_pkg.vhd
vcom -2008 -work work $localpath/source/globals/arobot_constant_pkg.vhd
vcom -2008 -work work $localpath/source/globals/arobot_component_pkg.vhd
vcom -2008 -work work $localpath/source/basics/monoshot.vhd
vcom -93 -work work $localpath/source/pulse_generator.vhd
#vcom -93 -work work $localpath/source/integrator.vhd

# from testbench
vcom -93 -work work $localpath/testbench/byte_reader_stim_fp_pkg.vhd
vcom -93 -work work $localpath/testbench/pulse_generator_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  pulse_generator_tb

add wave pulse_generator_tb/*
add wave pulse_generator_tb/U_DUT/*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 3000 us
wave zoom full
