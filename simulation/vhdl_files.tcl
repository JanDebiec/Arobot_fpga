

set ProjectFileList {
	pkg_LIB {
		../source/globals/arobot_constant_pkg.vhd
		../source/globals/arobot_component_pkg.vhd
		../testbench/byte_reader_stim_fp_pkg.vhd
		../testbench/arobot_base_stim_fp_pkg.vhd
	}
	ip_LIB {
	    ../source/issp/issp_inout.vhd
	}

	design_LIB {
		../source/globals/version.vhd
		../source/basics/deflipflop.vhd
		../source/basics/monoshot.vhd
		../source/basics/delay2.vhd
		../source/bit_filter.vhd
		../source/byte_reader.vhd
		../source/receiver.vhd
		../source/shift_latch.vhd
		../source/byte_and_shift.vhd
		../source/issp/velocity_issp.vhd
		../source/issp/slice_tick_issp.vhd
		../source/ramp.vhd
		../source/pulse_generator.vhd
		../source/integrator.vhd
		../source/issp/position_issp.vhd
		../source/modulo_divider.vhd
		../source/micro_lut.vhd
		../source/sinus_calc.vhd
		../source/pwm/pwm_pulse.vhd
		../source/pwm/pwm_single.vhd
		../source/pwm/pwm_double.vhd
		../source/convPos2Pwm.vhd
		../source/convVel2Pulse.vhd
		../source/convPulse2Pos.vhd
		../source/slice_tick_gen.vhd
		../source/one_axis.vhd
		../source/top/c4_base_top.vhd
		../source/top/c4_position.vhd
		../source/top/c4_velocity.vhd
		../source/hw_soc/h2flw_interface.vhd
		../source/top/c5_1701.vhd
	
	}
	sim_LIB {
		../testbench/bit_filter_tb.vhd
		../testbench/byte_reader_tb.vhd
		../testbench/byte_and_shift_tb.vhd
		../testbench/integrator_tb.vhd
		../testbench/modulo_divider_tb.vhd
		../testbench/pulse_generator_tb.vhd
		../testbench/ramp_tb.vhd
		../testbench/receiver_tb.vhd
		../testbench/sinus_calc_tb.vhd
		../testbench/pwm_single_tb.vhd
		../testbench/pwm_double_tb.vhd
		../testbench/convPos2Pwm_tb.vhd
		
	}
}




