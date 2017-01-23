Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
    use work.modulo_divider_pkg.all;
entity modulo_divider_TB is
end modulo_divider_TB;

architecture behave of modulo_divider_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal n32_inputValue : signed(31 downto 0) := x"00000000";
	signal u8_ModuloValue : unsigned(7 downto 0) := x"06";
	signal slv_OutputValue : std_logic_vector(7 downto 0);
begin	

U_DUT : modulo_divider
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		in32_inputPosition 	=> n32_inputValue,--: in std_logic_vector(31 downto 0);
		iu8_ModuloValue 	=> u8_ModuloValue,--: in std_logic_vector(7 downto 0);
		oslv8_OutputValue 	=> slv_OutputValue--: out std_logic_vector(7 downto 0)
);

P_SIMUL : process
begin
	wait for 1 us;
		n32_inputValue <= x"00000004";
		
	wait for 1 us;
		n32_inputValue <= n32_inputValue + 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue + 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue + 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue + 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue + 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue + 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue + 1;

	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	wait for 1 us;
		n32_inputValue <= n32_inputValue - 1;
	
	wait;		
	end process;
-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 12 ns;
        
    P_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 100 ns;
    	sl_Reset <= '1';
    	
        wait for 100 ns;

    	sl_Reset <= '0';

        wait;
    end process;
end  behave;