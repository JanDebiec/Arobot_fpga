----------------------------------------------------------------------
--! @file  
--! @brief 
--!
--!
--! @author 
--! @date 
--! @version  
--! 
-- note 
--! @todo 
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library work;           
	use work.arobot_constant_pkg.all;
	use work.arobot_component_pkg.all;
    use work.convPos2Pwm_pkg.all;
    use work.slice_tick_gen_pkg.all;
    use work.pwm_pulse_pkg.all;
    use work.convVel2Pulse_pkg.all;
    use work.convPulse2Pos_pkg.all;
    use work.position_issp_pkg.all;
    use work.velocity_issp_pkg.all;

--!
entity c4_base_top is
    generic(
--			bModelSim : boolean := FALSE;
--			bISSP     : boolean := TRUE
			bModelSim : boolean;
			bISSP     : boolean
    );
	port (
		CLOCK_50 	: in std_logic;
		SW 		: in std_logic_vector(3 downto 0) ; 
		KEY 		: in std_logic_vector(1 downto 0) ; --reset active low
--		SW[0] 		: in std_logic ;
		GPIO_2 : out std_logic_vector (7 downto 0);
		GPIO_0 	: out std_logic_vector(31 downto 0)
	);
end entity c4_base_top;

architecture RTL of c4_base_top is
	signal sl_clk50MHz  		: STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 			: STD_LOGIC := '0';
	signal n16_rampValue  	: signed (15 downto 0) := x"0040";
	signal n16_outValue 		: signed (15 downto 0) := x"0000";
	signal n16_Value 			: signed (15 downto 0) :=  x"0080";
	signal sl_output1A		: std_logic;
	signal sl_output1B		: std_logic;
	signal sl_output2A		: std_logic;
	signal sl_output2B		: std_logic;
	signal n32_periodCount	: signed (31 downto 0) := x"004C4B40";--05-000-000 clocks = 100ms
	signal sl_slice_tick		: std_logic;	--!

	signal n16_inputVelocity : signed (15 downto 0);
	signal	sl_PwmPeriodPulse 		: std_logic;
	signal	u16_loopCounter : integer;
	signal	n16_inputVector : signed (15 downto 0);
	signal	n16_outputVector : signed (15 downto 0);
	signal	slv6_PosModulo : std_logic_vector(5 downto 0) := "011010";
	signal	slv6_InputIndexModulo : std_logic_vector(5 downto 0); 
	signal	slv6_OutputValueModulo : std_logic_vector(5 downto 0); 
	
	signal	slv6_InputIndexIssp : std_logic_vector(5 downto 0);
	signal sl_direction : std_logic;
	signal sl_sliceTick : std_logic;
	signal sl_step : std_logic;
begin

--GPIO_0(31 downto 16) <= slv16_testValue;
sl_clk50MHz <= CLOCK_50;
sl_Reset <= not (KEY(0));
GPIO_2(1) <= sl_slice_tick;
GPIO_2(2) <= sl_output1A;
GPIO_2(3) <= sl_output1B;
GPIO_2(4) <= sl_output2A;
GPIO_2(5) <= sl_output2B;
GPIO_2(6) <= sl_step;
GPIO_2(7) <= sl_PwmPeriodPulse;

--!
U_PwmPulseGen : pwm_pulse
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;	--!
	isl_rst 			=> sl_Reset,--: in std_logic;	--!
	osl_PwmPeriodPulse 	=> sl_PwmPeriodPulse,--: in std_logic;
	ou16_loopCounter	=> u16_loopCounter--: out integer	--!
);

--!
U_slice_tick_gen : slice_tick_gen
generic map(
	bISSP => FALSE,
	bModelSim => FALSE
)
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;	--!
	isl_rst 			=> sl_Reset,--: in std_logic;	--!
	in32_periodCount 	=> n32_periodCount,--: in std_logic;
	osl_slice_tick		=> sl_sliceTick--: out integer	--!
);


U_VELOCITY_ISSP : velocity_issp
port map (
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	in16_inputVector 	=> n16_inputVector,--: in signed (15 downto 0);
	on16_outputVector 	=> n16_outputVector--: out signed (15 downto 0);
);

U_convVel2Pulse : convVel2Pulse
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	isl_sliceTick 		=> sl_sliceTick,--in std_logic; --! 50 ms tick for velocity changes
	in16_inputVector 	=> n16_inputVector,--in signed (15 downto 0);--! input velocity 15 bits + sign
	in16_rampValue  	=> n16_rampValue,--in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
--	oslv16_testValue  	=> ,--out std_logic_vector (15 downto 0);--! used for tesing
	osl_pulse			=> sl_step--out std_logic--! used for tesing
);



U_convPulse2Pos : convPulse2Pos
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	isl_direction		=> sl_direction,--: in std_logic;
	isl_pulse			=> sl_step,--: in std_logic;
	oslv6_OutputValue  	=> slv6_PosModulo--: out std_logic_vector (5 downto 0)--! 
);

U_POSITION_JTAG : if (bISSP = TRUE and bModelSim = FALSE) generate
begin
	U_POSITION_ISSP : entity work.position_issp
	generic map(
--		bISSP     =>TRUE,
		bModelSim => FALSE
	)
	port map (
		isl_clk50Mhz 		=> sl_clk50Mhz,--: in std_logic;
		isl_rst 			=> sl_Reset,--: in std_logic;
		islv6_inputPosition 	=> slv6_PosModulo,--: in signed (15 downto 0);
		oslv6_outputPosition 	=> slv6_InputIndexIssp--: out signed (15 downto 0);
	);
end generate;


slv6_InputIndexModulo <= slv6_InputIndexIssp when (bISSP = TRUE and bModelSim = FALSE) else
				slv6_PosModulo;

--!
U_SingleAxis : convPos2Pwm
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	islv6_InputIndex 	=> slv6_InputIndexModulo,--: in std_logic_vector(7 downto 0);
	iu16_loopCounter 	=> u16_loopCounter,--: in integer;
	isl_InputSync		=> sl_PwmPeriodPulse,--: in std_logic;
	osl_output1A		=> sl_output1A ,--	: out std_logic;
	osl_output1B		=> sl_output1B ,--	: out std_logic;
	osl_output2A		=> sl_output2A ,--	: out std_logic;
	osl_output2B		=> sl_output2B --	: out std_logic
);


end architecture RTL;
