----------------------------------------------------------------------
--! @file  
--! @brief 
--! input velocity, will be with ramp corrected
--! position will be generated
--!
--!
--! @author 
--! @date 
--! @version  
--! 
--! note 
--! @todo initialize the system vars, ev move to generic
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
package one_axis_pkg is
    component one_axis 
--    generic(
-- 		bISSP     : boolean := TRUE;
--        bModelSim : boolean := FALSE
--    );
    port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_sliceTick 		: in std_logic; --! 50 ms tick for velocity changes
		in16_inputVector 	: in signed (15 downto 0);--! input velocity 15 bits + sign
		in16_rampValue  	: in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
		isl_extStep			: in std_logic;
		isl_extDir			: in std_logic;
		isl_extStepEnable	: in std_logic;
		oslv6_PosModulo 	: out std_logic_vector(5 downto 0);
		osl_output1A		: out std_logic;--! pwm output
		osl_output1B		: out std_logic;--! pwm output
		osl_output2A		: out std_logic;--! pwm output
		osl_output2B		: out std_logic --! pwm output
    );        
    end component one_axis;
            
end package one_axis_pkg;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library work;           
	use work.arobot_constant_pkg.all;	
    use work.pwm_pulse_pkg.all;
    use work.convVel2Pulse_pkg.all;
    use work.convPulse2Pos_pkg.all;
    use work.convPos2Pwm_pkg.all;
--    use work.position_issp_pkg.all;
--    use work.velocity_issp_pkg.all;

--!
entity one_axis is
    generic(
			bModelSim : boolean := FALSE;
			bISSP     : boolean := TRUE
    );
	port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_sliceTick 		: in std_logic; --! 50 ms tick for velocity changes
		in16_inputVector 	: in signed (15 downto 0);--! input velocity 15 bits + sign
		in16_rampValue  	: in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
		isl_extStep			: in std_logic;
		isl_extDir			: in std_logic;
		isl_extStepEnable	: in std_logic;
		oslv6_PosModulo 	: out std_logic_vector(5 downto 0);
		osl_output1A		: out std_logic;--! pwm output
		osl_output1B		: out std_logic;--! pwm output
		osl_output2A		: out std_logic;--! pwm output
		osl_output2B		: out std_logic --! pwm output
	);
--add to readout:
--	signal	uP2P_slv6_PosModulo : std_logic_vector(5 downto 0) := "011010";
--	signal	uPwmPG_u16_loopCounter : integer;

end entity one_axis;

architecture RTL of one_axis is
	signal sl_clk50MHz  		: STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 			: STD_LOGIC := '0';
	signal n16_rampValue  	: signed (15 downto 0) := x"0040";
	signal n16_outValue 		: signed (15 downto 0) := x"0000";
	signal n16_Value 			: signed (15 downto 0) :=  x"0080";
	signal uAx_sl_output1A		: std_logic;
	signal uAx_sl_output1B		: std_logic;
	signal uAx_sl_output2A		: std_logic;
	signal uAx_sl_output2B		: std_logic;
--	signal n32_periodCount	: signed (31 downto 0) := x"004C4B40";--05-000-000 clocks = 100ms
--	signal sl_slice_tick		: std_logic;	--!

	signal n16_inputVelocity : signed (15 downto 0);
	signal	uPwmPG_sl_PwmPeriodPulse 		: std_logic;
	signal	uPwmPG_u16_loopCounter : integer;
	signal	n16_inputVector : signed (15 downto 0);
	signal	n16_outputVector : signed (15 downto 0);
	signal	uP2P_slv6_PosModulo : std_logic_vector(5 downto 0) := "011010";
--	signal	slv6_InputIndexModulo : std_logic_vector(5 downto 0); 
	signal	slv6_OutputValueModulo : std_logic_vector(5 downto 0); 
	
	signal	slv6_InputIndexIssp : std_logic_vector(5 downto 0);
	signal sl_direction : std_logic;
	signal sl_sliceTick : std_logic;
	signal uV2P_sl_step : std_logic;
	signal sl_step : std_logic;
begin
--system signals
--GPIO_0(31 downto 16) <= slv16_testValue;
sl_clk50MHz <= isl_clk50Mhz;
sl_Reset <= isl_rst;
sl_sliceTick <= isl_sliceTick;

--configuration
-- internal/external step/dir interface
sl_step <= uV2P_sl_step when (isl_extStepEnable = '0') else isl_extStep;
sl_direction <= n16_inputVector(15) when (isl_extStepEnable = '0') else isl_extDir;

-- main inputs
n16_inputVector 	<= in16_inputVector;
n16_rampValue  	<= in16_rampValue;

-- outputs
osl_output1A <= uAx_sl_output1A;
osl_output1B <= uAx_sl_output1B;
osl_output2A <= uAx_sl_output2A;
osl_output2B <= uAx_sl_output2B;

--!
uPwmPG : pwm_pulse
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;	--!
	isl_rst 			=> sl_Reset,--: in std_logic;	--!
	osl_PwmPeriodPulse 	=> uPwmPG_sl_PwmPeriodPulse,--: in std_logic;
	ou16_loopCounter	=> uPwmPG_u16_loopCounter--: out integer	--!
);

uV2P : convVel2Pulse
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	isl_sliceTick 		=> sl_sliceTick,--in std_logic; --! 50 ms tick for velocity changes
	in16_inputVector 	=> n16_inputVector,--in signed (15 downto 0);--! input velocity 15 bits + sign
	in16_rampValue  	=> n16_rampValue,--in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
--	oslv16_testValue  	=> ,--out std_logic_vector (15 downto 0);--! used for tesing
	osl_pulse			=> uV2P_sl_step--out std_logic--! used for tesing
);



uP2P : convPulse2Pos
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	isl_direction		=> sl_direction,--: in std_logic;
	isl_pulse			=> uV2P_sl_step,--: in std_logic;
	oslv6_OutputValue  	=> uP2P_slv6_PosModulo--: out std_logic_vector (5 downto 0)--! 
);


--slv6_InputIndexModulo <= uP2P_slv6_PosModulo;

--!
uAx : convPos2Pwm
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	islv6_InputIndex 	=> uP2P_slv6_PosModulo,--: in std_logic_vector(7 downto 0);
	iu16_loopCounter 	=> uPwmPG_u16_loopCounter,--: in integer;
	isl_InputSync		=> uPwmPG_sl_PwmPeriodPulse,--: in std_logic;
	osl_output1A		=> uAx_sl_output1A ,--	: out std_logic;
	osl_output1B		=> uAx_sl_output1B ,--	: out std_logic;
	osl_output2A		=> uAx_sl_output2A ,--	: out std_logic;
	osl_output2B		=> uAx_sl_output2B --	: out std_logic
);


end architecture RTL;
