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
    use work.position_issp_pkg.all;

--!
entity c4_position is
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
end entity c4_position;

architecture RTL of c4_position is
	signal sl_clk50MHz  		: STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 			: STD_LOGIC := '0';
	signal n16_rampValue  	: signed (15 downto 0) := x"0040";
	signal n16_outValue 		: signed (15 downto 0) := x"0000";
	signal n16_Value 			: signed (15 downto 0) :=  x"0080";
	signal uAx_sl_output1A		: std_logic;
	signal uAx_sl_output1B		: std_logic;
	signal uAx_sl_output2A		: std_logic;
	signal uAx_sl_output2B		: std_logic;
	signal n32_periodCount	: signed (31 downto 0) := x"004C4B40";--05-000-000 clocks = 100ms
	signal sl_slice_tick		: std_logic;	--!

	signal n16_inputVelocity : signed (15 downto 0);
	signal	uPwmPG_sl_PwmPeriodPulse 		: std_logic;
	signal	uPwmPG_u16_loopCounter : integer;
	signal	n16_inputVector : signed (15 downto 0);
	signal	n16_outputVector : signed (15 downto 0);
	signal	i_slv6_PosModulo : std_logic_vector(5 downto 0) := "011010";
	signal	slv6_InputIndexModulo : std_logic_vector(5 downto 0); 
	signal	slv6_OutputValueModulo : std_logic_vector(5 downto 0); 
	
	signal	uISSP_slv6_InputIndexIssp : std_logic_vector(5 downto 0);
	signal sl_direction : std_logic;
	signal sl_sliceTick : std_logic;
	signal sl_step : std_logic;
--	signal slv1_mux : std_logic_vector(0 downto 0);
	signal uISSP_sl_mux : std_logic;
begin

sl_clk50MHz <= CLOCK_50;
sl_Reset <= not (KEY(0));
GPIO_2(1) <= sl_slice_tick;
GPIO_2(2) <= uAx_sl_output1A;
GPIO_2(3) <= uAx_sl_output1B;
GPIO_2(4) <= uAx_sl_output2A;
GPIO_2(5) <= uAx_sl_output2B;
GPIO_2(6) <= sl_step;
GPIO_2(7) <= uPwmPG_sl_PwmPeriodPulse;

--!
uPwmPG : pwm_pulse
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;	--!
	isl_rst 			=> sl_Reset,--: in std_logic;	--!
	osl_PwmPeriodPulse 	=> uPwmPG_sl_PwmPeriodPulse,--: in std_logic;
	ou16_loopCounter	=> uPwmPG_u16_loopCounter--: out integer	--!
);

i_slv6_PosModulo <= GPIO_0(5 downto 0);

uPOSITION_JTAG : if (bISSP = TRUE and bModelSim = FALSE) generate
begin
	uISSP : entity work.position_issp
	generic map(
--		bISSP     =>TRUE,
		bModelSim => FALSE
	)
	port map (
		isl_clk50Mhz 		=> sl_clk50Mhz,--: in std_logic;
		isl_rst 			=> sl_Reset,--: in std_logic;
		osl_mux				=> uISSP_sl_mux,
		islv6_inputPosition 	=> i_slv6_PosModulo,--: in signed (15 downto 0);
		oslv6_outputPosition 	=> uISSP_slv6_InputIndexIssp--: out signed (15 downto 0);
	);

slv6_InputIndexModulo <= uISSP_slv6_InputIndexIssp when (uISSP_sl_mux = '1') else
				i_slv6_PosModulo;
end generate;

uNISSP : if (bISSP = FALSE) generate
begin
	slv6_InputIndexModulo <= i_slv6_PosModulo;
	uISSP_sl_mux <= '0';
end generate;	



--!
uAx : convPos2Pwm
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	islv6_InputIndex 	=> slv6_InputIndexModulo,--: in std_logic_vector(7 downto 0);
	iu16_loopCounter 	=> uPwmPG_u16_loopCounter,--: in integer;
	isl_InputSync		=> uPwmPG_sl_PwmPeriodPulse,--: in std_logic;
	osl_output1A		=> uAx_sl_output1A ,--	: out std_logic;
	osl_output1B		=> uAx_sl_output1B ,--	: out std_logic;
	osl_output2A		=> uAx_sl_output2A ,--	: out std_logic;
	osl_output2B		=> uAx_sl_output2B --	: out std_logic
);


end architecture RTL;
