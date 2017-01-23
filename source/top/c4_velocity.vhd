----------------------------------------------------------------------
--! @file  
--! @brief 
--!
--!
--! @author 
--! @date 
--! @version  
--! 
--! note 
--! @todo add issp for ramp
--! add external inputs
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
    use work.deflipflop_pkg.all;
    use work.monoshot_pkg.all;
    use work.slice_tick_gen_pkg.all;
    use work.pwm_pulse_pkg.all;
    use work.one_axis_pkg.all;
    use work.velocity_issp_pkg.all;

--!
entity c4_velocity is
    generic(
			bModelSim : boolean := FALSE;
			bISSP     : boolean := TRUE
    );
	port (
		CLOCK_50 	: in std_logic;
		SW 		: in std_logic_vector(3 downto 0) ; 
		KEY 		: in std_logic_vector(1 downto 0) ; --reset active low
--		SW[0] 		: in std_logic ;
		GPIO_2 : out std_logic_vector (7 downto 0);
		GPIO_0 	: in std_logic_vector(31 downto 0)
	);
end entity c4_velocity;

architecture RTL of c4_velocity is
	signal sl_clk50MHz  		: STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 			: STD_LOGIC := '0';
	signal n16_rampValue  	: signed (15 downto 0) := x"0040";
	signal n16_outValue 		: signed (15 downto 0) := x"0000";
	signal n16_Value 			: signed (15 downto 0) :=  x"0080";
	signal sl_output1A		: std_logic;
	signal sl_output1B		: std_logic;
	signal sl_output2A		: std_logic;
	signal sl_output2B		: std_logic;
	signal n32_periodCount	: signed (31 downto 0);
	signal sl_slice_tick		: std_logic;	--!

	signal	n16_inputVector : signed (15 downto 0);
	signal	in16_inputVector : signed (15 downto 0);
	signal	uIssp_n16_outputVector : signed (15 downto 0);

	signal uST_sl_sliceTick : std_logic;
	signal sl_step : std_logic;
	signal isl_extStep : std_logic;
	signal sl_extStep_m : std_logic;
	signal isl_extStepEnable : std_logic;
	signal isl_extDir : std_logic;
	signal sl_extStepEnable : std_logic;
	signal sl_extDir : std_logic;
	signal uISSP_sl_mux : std_logic;
begin

-- system signals
--GPIO_0(31 downto 16) <= slv16_testValue;
sl_clk50MHz <= CLOCK_50;
sl_Reset <= not (KEY(0));

-- input signals and regs
in16_inputVector <= signed(GPIO_0(15 downto 0));
n16_rampValue <= signed(GPIO_0(31 downto 16));

-- outputs
GPIO_2(1) <= sl_slice_tick;
GPIO_2(2) <= sl_output1A;
GPIO_2(3) <= sl_output1B;
GPIO_2(4) <= sl_output2A;
GPIO_2(5) <= sl_output2B;


n32_periodCount	<= x"004C4B40";--05-000-000 clocks = 100ms

uM : monoshot 
--generic(
--    bModelSim           : boolean := FALSE
--);
port map     (
    isl_clk        => sl_clk50MHz,--: in std_logic; --! master clock 50 MHz
    isl_rst             => sl_Reset,--: in std_logic; --! master reset active high
    isl_input           => isl_extStep,--: in std_logic; --!
    osl_outputMono      => sl_extStep_m--: out std_logic --! pwm output
);        

uRDir : deflipflop
port map
(
    isl_clock   => sl_clk50MHz,--: in STD_LOGIC;
    isl_d       => isl_extDir,--: in STD_LOGIC;
    isl_ena     => '1',--: in STD_LOGIC;
    isl_reset   => sl_Reset,--: in STD_LOGIC;
    osl_out     => sl_extDir--: out STD_LOGIC
);

uREna : deflipflop
port map
(
    isl_clock   => sl_clk50MHz,--: in STD_LOGIC;
    isl_d       => isl_extStepEnable,--: in STD_LOGIC;
    isl_ena     => '1',--: in STD_LOGIC;
    isl_reset   => sl_Reset,--: in STD_LOGIC;
    osl_out     => sl_extStepEnable--: out STD_LOGIC
);

--!
uST : slice_tick_gen
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;	--!
	isl_rst 			=> sl_Reset,--: in std_logic;	--!
	in32_periodCount 	=> n32_periodCount,--: in std_logic;
	osl_slice_tick		=> uST_sl_sliceTick--: out integer	--!
);


U_VELOCITY_JTAG : if (bISSP = TRUE and bModelSim = FALSE) generate
begin
uVelIssp : velocity_issp
port map (
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	osl_mux				=> uISSP_sl_mux,
	in16_inputVector 	=> in16_inputVector,--: in signed (15 downto 0);
	on16_outputVector 	=> uIssp_n16_outputVector--: out signed (15 downto 0);
);

n16_inputVector <= uIssp_n16_outputVector when (uISSP_sl_mux = '1') else
				in16_inputVector;
end generate;


uNISSP : if (bISSP = FALSE) generate
begin
	n16_inputVector <= in16_inputVector;
	uISSP_sl_mux <= '0';
end generate;	

--!
U_SingleAxis : one_axis
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	isl_sliceTick 		=> uST_sl_sliceTick,--in std_logic; --! 50 ms tick for velocity changes
	in16_inputVector 	=> n16_inputVector,--in signed (15 downto 0);--! input velocity 15 bits + sign
	in16_rampValue  	=> n16_rampValue,--in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
	isl_extStep			=> sl_extStep_m,--: in std_logic;
	isl_extDir			=> sl_extDir,--: in std_logic;
	isl_extStepEnable	=> sl_extStepEnable,--: in std_logic;
	osl_output1A		=> sl_output1A ,--	: out std_logic;
	osl_output1B		=> sl_output1B ,--	: out std_logic;
	osl_output2A		=> sl_output2A ,--	: out std_logic;
	osl_output2B		=> sl_output2B --	: out std_logic
);


end architecture RTL;
