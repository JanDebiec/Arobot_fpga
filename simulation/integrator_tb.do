vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  integrator_TB

add wave integrator_tb/U_pulse/*
add wave integrator_tb/U_Integrator/*

radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 3000 us
wave zoom full
