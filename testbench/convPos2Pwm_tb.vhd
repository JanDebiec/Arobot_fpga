Library std;
	use std.standard.all;
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
	use work.arobot_constant_pkg.all;
	use work.arobot_component_pkg.all;
    use work.convPos2Pwm_pkg.all;
    use work.pwm_pulse_pkg.all;
    use work.byte_reader_stim_fp.all;
                        
entity convPos2Pwm_TB is
end convPos2Pwm_TB;

architecture behave of convPos2Pwm_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	
	signal	sl_PwmPeriodPulse 		: std_logic;
	signal	u16_loopCounter : integer;
	
	--signal n16_inputVector : signed (15 downto 0) := x"0100";
	signal n16_rampValue  : signed (15 downto 0) := x"0040";
	signal n16_outValue : signed (15 downto 0) := x"0000";
	signal n16_Value : signed (15 downto 0) :=  x"0080";
	signal sl_output1A		:  std_logic;
	signal sl_output1B		:  std_logic;
	signal sl_output2A		:  std_logic;
	signal sl_output2B		:  std_logic;
	signal	slv6_InputIndex : std_logic_vector(5 downto 0); 

begin	

-- U_SIMUL: process
-- begin
-- 	wait for 20 us;
-- 	n16_inputVector <= x"0400";
-- 	wait for 20 us;
-- 	n16_inputVector <= x"fc00";
-- 	wait;
-- end process;	

P_STIMUL: process
 begin
 	--do nothing
 	--wait;
 	
 	
 	wait for 500 ns;
 	slv6_InputIndex <= "000010";
 	

 	wait for 300 us;
 	slv6_InputIndex <= "100010";

 	wait for 300 us;
 	slv6_InputIndex <= "001010";

 	wait for 500 us;
 	slv6_InputIndex <= "010010";

 	wait for 500 us;
 	slv6_InputIndex <= "110010";

 	wait for 300 us;
 	slv6_InputIndex <= "111010";

	wait; 	
 	end process;

-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;
    
    --sl_sliceTick   <= not sl_sliceTick after 1 us;

    U_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 100 ns;
    	sl_Reset <= '1';
    	
        wait for 100 ns;

    	sl_Reset <= '0';

        wait for 100 ns;
			--sl_sliceTick <= '1';
        wait;
    end process;

U_PwmPulseGen : pwm_pulse
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;	--!
	isl_rst 			=> sl_Reset,--: in std_logic;	--!
	osl_PwmPeriodPulse 	=> sl_PwmPeriodPulse,--: in std_logic;
	ou16_loopCounter	=> u16_loopCounter--: out integer	--!
);


U_DUT : convPos2Pwm
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		islv6_InputIndex 	=> slv6_InputIndex,--: in std_logic_vector(7 downto 0);
		iu16_loopCounter 	=> u16_loopCounter,--: in integer;
		isl_InputSync		=> sl_PwmPeriodPulse,--: in std_logic;
		osl_output1A	=> sl_output1A ,--	: out std_logic;
		osl_output1B	=> sl_output1B ,--	: out std_logic;
		osl_output2A	=> sl_output2A ,--	: out std_logic;
		osl_output2B	=> sl_output2B --	: out std_logic
);

end  behave;
