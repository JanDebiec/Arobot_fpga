##########################  Altera IP
set_global_assignment -name VHDL_FILE ../ip/baudrate_counter.vhd
set_global_assignment -name QIP_FILE ../ip/baudrate_counter.qip
set_global_assignment -name VHDL_FILE ../ip/n32_modulo_u8.vhd
set_global_assignment -name QIP_FILE ../ip/n32_modulo_u8.qip
set_global_assignment -name VHDL_FILE ../ip/shift_reg_48bits.vhd
set_global_assignment -name QIP_FILE ../ip/shift_reg_48bits.qip
set_global_assignment -name VHDL_FILE ../ip/u32_div_u16.vhd
set_global_assignment -name QIP_FILE ../ip/u32_div_u16.qip
##########################
set_global_assignment -name VHDL_FILE ../source/globals/arobot_tcc_pkg.vhd
##########################
set_global_assignment -name VHDL_FILE ../source/issp/issp_inout.vhd
set_global_assignment -name VHDL_FILE ../source/pwm/pwm_pulse.vhd
set_global_assignment -name VHDL_FILE ../source/basics/flipflop_d1.vhd
set_global_assignment -name VHDL_FILE ../source/basics/monoshot.vhd
set_global_assignment -name VHDL_FILE ../source/slice_tick_issp.vhd
set_global_assignment -name VHDL_FILE ../source/slice_tick_gen.vhd
set_global_assignment -name VHDL_FILE ../source/velocity_issp.vhd
set_global_assignment -name VHDL_FILE ../source/position_issp.vhd
set_global_assignment -name VHDL_FILE ../source/bit_filter.vhd
set_global_assignment -name VHDL_FILE ../source/byte_reader.vhd
set_global_assignment -name VHDL_FILE ../source/receiver.vhd
set_global_assignment -name VHDL_FILE ../source/shift_latch.vhd
set_global_assignment -name VHDL_FILE ../source/byte_and_shift.vhd
set_global_assignment -name VHDL_FILE ../source/ramp.vhd
set_global_assignment -name VHDL_FILE ../source/pulse_generator.vhd
set_global_assignment -name VHDL_FILE ../source/integrator.vhd
set_global_assignment -name VHDL_FILE ../source/modulo_divider.vhd
set_global_assignment -name VHDL_FILE ../source/micro_lut.vhd
set_global_assignment -name VHDL_FILE ../source/sinus_calc.vhd
set_global_assignment -name VHDL_FILE ../source/pwm/pwm_single.vhd
set_global_assignment -name VHDL_FILE ../source/pwm/pwm_double.vhd
set_global_assignment -name VHDL_FILE ../source/convVel2Pulse.vhd
set_global_assignment -name VHDL_FILE ../source/convPulse2Pos.vhd
set_global_assignment -name VHDL_FILE ../source/convPos2Pwm.vhd
set_global_assignment -name VHDL_FILE ../source/one_axis.vhd
#set_global_assignment -name VHDL_FILE ../source/c4_base_top.vhd

