Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
--	use work.msystem_typedef_pkg.all;
    use work.mono_on_border_pkg.all;
                        
entity mono_on_border_TB is
end mono_on_border_TB;

architecture behave of mono_on_border_TB is
    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_input		: std_logic := '0';
	signal sl_output	: std_logic := '0';
begin	

P_STIMUL: process
 begin
 	
    wait for 1 us;

    wait until rising_edge(sl_clk50MHz);
    sl_input <= '1';
    wait until rising_edge(sl_clk50MHz);
    sl_input <= '0';

    wait for 1 us;

    wait until rising_edge(sl_clk50MHz);
    sl_input <= '1';
    wait for 50 ns;
    wait until rising_edge(sl_clk50MHz);
    sl_input <= '0';

	wait; 	
end process;

    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;
    sl_SpiClk <= not sl_SpiClk after 30 ns;
    --sl_OutputClk    <= not sl_OutputClk after 4 ns;
    U_RESET: process
    begin
    	sl_Reset <= '0';
        wait for 30 ns;
    	sl_Reset <= '1';
        wait for 30 ns;
    	sl_Reset <= '0';
        wait for 100 ns;
        wait;
    end process;

U_DUT : mono_on_border
port map
(
    i_InputClock   => sl_clk50MHz ,--: in  STD_LOGIC;--
    i_OutputClock    => sl_SpiClk ,--: in  STD_LOGIC;--
    i_Input         => sl_input ,--: in  STD_LOGIC;--
    i_Reset         => sl_Reset ,--: in  STD_LOGIC;--
    o_Output        => sl_output --: out STD_LOGIC     --
);

end  behave;

