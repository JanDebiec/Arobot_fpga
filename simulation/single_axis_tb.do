vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  single_axis_TB

add wave single_axis_TB/*
add wave single_axis_TB/U_DUT/U_RAMP/*
add wave single_axis_TB/U_DUT/U_Pulse_gen/*
add wave single_axis_TB/U_DUT/U_INTEGRATOR/*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 20 us
wave zoom full