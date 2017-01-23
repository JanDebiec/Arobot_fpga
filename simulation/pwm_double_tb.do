vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv -L rtl_work -L work -voptargs="+acc"  pwm_double_TB

#add wave pwm_double_TB/*
add wave pwm_double_TB/U_DUT/*
radix -hexadecimal
view structure
view signals

set StdArithNoWarnings 1


run 20 us
wave zoom full