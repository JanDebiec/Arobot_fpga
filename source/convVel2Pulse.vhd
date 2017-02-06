----------------------------------------------------------------------
--! @file converter velocity to pulse.vhd  
--! @brief converter velocity to pulse
--!
--! input: velocity command, signed 16 bits, 
--! outputs: pulses , counts proportional to velocity, 
--! change in TickPeriod, limited to ramoValue
--!
--! @author Jan Debiec
--! @date 13.05.2015
--! @version 0.3 
--! 
--! note 
--! @todo test
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
--! Use standard library
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	
--
--!
package convVel2Pulse_pkg is
    component convVel2Pulse 
    generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
    );
    port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_sliceTick 		: in std_logic; --! 50 ms tick for velocity changes
		in16_inputVector 	: in signed (15 downto 0);--! input velocity 15 bits + sign
		in16_rampValue  	: in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
--		oslv16_testValue  	: out std_logic_vector (15 downto 0);--! used for tesing
		osl_DirAfterRamp	: out std_logic;
		osl_pulse			: out std_logic--! used for tesing
    );        
    end component convVel2Pulse;
            
end package convVel2Pulse_pkg;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library work;           
	use work.pulse_generator_pkg.all;
    use work.ramp_pkg.all;
    use work.pwm_double_pkg.all;
    use work.position_issp_pkg.all;
    use work.velocity_issp_pkg.all;
 
--!
entity convVel2Pulse is
    generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
    );
	port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_sliceTick 		: in std_logic; --! 50 ms tick for velocity changes
		in16_inputVector 	: in signed (15 downto 0);--! input velocity 15 bits + sign
		in16_rampValue  	: in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
--		oslv16_testValue  	: out std_logic_vector (15 downto 0);--! used for tesing
		osl_DirAfterRamp	: out std_logic;
		osl_pulse			: out std_logic--! used for tesing
	);
end entity convVel2Pulse;

--!
architecture RTL of convVel2Pulse is

	signal n16_outputVector 	: signed (15 downto 0);
-- ramp output
	signal uRamp_n16OutValue : signed (15 downto 0) := x"0000";

-- pulse generator
	signal sl_inputValid : std_logic := '0';
	signal sl_outputFiltered : std_logic;
	signal un32_timerSettings : unsigned(31 downto 0);
	signal uPG_sl_pulseOutput : std_logic;
	signal sl_sliceTick : std_logic;
	signal un15_VelAfterRamp : unsigned(14 downto 0);
	signal n16_VelAfterRamp : signed(15 downto 0);
	signal n_VelAfterRamp : integer;
	signal un16_VelAfterRamp : unsigned(15 downto 0);
	signal sl_DirAfterRamp : std_logic;
	
begin
--oslv16_testValue <= std_logic_vector(uRamp_n16OutValue);
osl_pulse <= uPG_sl_pulseOutput;
n16_outputVector <= in16_inputVector;
sl_sliceTick <= isl_sliceTick;
n16_VelAfterRamp <= abs(uRamp_n16OutValue);
sl_DirAfterRamp <= '1' when (uRamp_n16OutValue(15) = '1') else '0';
osl_DirAfterRamp <= sl_DirAfterRamp;
--!
uRamp : ramp
port map (
	isl_clk50Mhz 		=> isl_clk50Mhz,--: in std_logic;
	isl_rst 			=> isl_rst,--: in std_logic;
	isl_sliceTick   	=> sl_sliceTick,--: in std_logic;
	in16_inputVector	=> n16_outputVector,--: in signed(15 downto 0);
	in16_rampValue   	=> in16_rampValue,--: in signed(15 downto 0);
	on16_outValue  		=> uRamp_n16OutValue--: out signed(15 downto 0)
);

--!
uPG : pulse_generator
port map
(
	isl_clk50Mhz 		=> isl_clk50Mhz,--: in std_logic;
	isl_rst 			=> isl_rst,--: in std_logic;
	in16_Value 			=> n16_VelAfterRamp,--: in signed (15 downto 0);
	osl_pulseOutput 	=> uPG_sl_pulseOutput--: out std_logic
          
);

end architecture RTL;
