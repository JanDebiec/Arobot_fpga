Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
	use work.pulse_generator_pkg.all;
entity pulse_generator_TB is
end pulse_generator_TB;

architecture behave of pulse_generator_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	--signal sl_inputValid : std_logic := '0';
	--signal sl_outputFiltered : std_logic;
--	signal n16_Value : signed (15 downto 0) :=  x"0080";
    signal n16_Value : signed (15 downto 0) :=  x"7E00";
--	signal un32_timerSettings : unsigned(31 downto 0);
	signal sl_pulseOutput : std_logic;
begin	

U_DUT : pulse_generator
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst 			=> sl_Reset,--: in std_logic;
		in16_Value 			=> n16_Value,--: in signed (15 downto 0);
--		isl_inputValid 		=> sl_inputValid,--: in std_logic;
--		iun32_timerSettings => un32_timerSettings,--: in unsigned(31 downto 0);-- 2625a0 internal 
		osl_pulseOutput 	=> sl_pulseOutput--: out std_logic
          
);

-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 12 ns;
 
 P_INPUT: process
 begin
 	--do nothing
 	--wait;
 	
 	
 	wait for 5000 ns;
 	n16_Value <= x"4080";
 	

 	wait for 10 us;
 	n16_Value <= x"2001";

 	wait for 30 us;
 	n16_Value <= x"1000";

 	wait for 500 us;
 	n16_Value <= x"0802";

 	wait for 500 us;
 	n16_Value <= x"0408";

 	wait for 300 us;
 	n16_Value <= x"3010";

	wait; 	
 	end process;
        
pRESET: process
    begin
    	sl_Reset <= '0';

        wait for 100 ns;
    	sl_Reset <= '1';
    	
        wait for 100 ns;

    	sl_Reset <= '0';

        wait;
    end process;
end  behave;