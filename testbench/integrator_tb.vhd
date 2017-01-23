Library ieee;           
	use ieee.std_logic_1164.all;
                        use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
	use work.pulse_generator_pkg.all;
	use work.integrator_pkg.all;
entity integrator_TB is
end integrator_TB;

architecture behave of integrator_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_inputValid : std_logic := '0';
	signal sl_outputFiltered : std_logic;
	signal n16_Value : signed (15 downto 0) :=  x"0080";
	signal un32_timerSettings : unsigned(31 downto 0);
	signal sl_pulseOutput : std_logic;
	signal n32_Position : signed (31 downto 0);
begin	

U_Integrator : integrator
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst 			=> sl_Reset,--: in std_logic;
		isl_direction 		=> n16_Value(15),--: in std_logic;
		isl_Pulse 			=> sl_pulseOutput,--: in std_logic;
		on32_Position 		=> n32_Position--: out signed(31 downto 0)
	
);

U_pulse : pulse_generator
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst 			=> sl_Reset,--: in std_logic;
		in16_Value 			=> n16_Value,--: in signed (15 downto 0);
	--	isl_inputValid 		=> sl_inputValid,--: in std_logic;
	--	iun32_timerSettings => un32_timerSettings,--: in unsigned(31 downto 0);-- 2625a0 internal 
		osl_pulseOutput 	=> sl_pulseOutput--: out std_logic
          
);

-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 12 ns;
 
 P_INPUT: process
 begin
 	--do nothing
 	--wait;
 	
 	
 	wait for 500 ns;
 	n16_Value <= x"0080";
 	

 	wait for 300 us;
 	n16_Value <= x"ff7f";

 	wait for 300 us;
 	n16_Value <= x"0000";

 	wait for 500 us;
 	n16_Value <= x"0002";

 	wait for 500 us;
 	n16_Value <= x"fff4";

 	wait for 300 us;
 	n16_Value <= x"0010";

	wait; 	
 	end process;
        
    U_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 100 ns;
    	sl_Reset <= '1';
    	
        wait for 100 ns;

    	sl_Reset <= '0';

        wait;
    end process;
end  behave;