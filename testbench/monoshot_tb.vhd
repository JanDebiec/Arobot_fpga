Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
--	use work.arobot_tcc_pkg.all;
    use work.monoshot_pkg.all;
                        
entity monoshot_TB is
end monoshot_TB;

architecture behave of monoshot_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_input		: std_logic := '0';
	signal sl_output	: std_logic := '0';
begin	

P_STIMUL: process
 begin
 	--do nothing
 	--wait;
 	
 	
 	wait for 500 ns;
 	sl_input <= '1';
 	

 	wait for 100 ns;
 	sl_input <= '0';

 	wait for 100 ns;
 	sl_input <= '1';

 	wait for 100 ns;
 	sl_input <= '0';

 	wait for 500 us;
 	sl_input <= '1';

 	wait for 100 ns;
 	sl_input <= '0';

	wait; 	
end process;

    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;
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

U_DUT : monoshot
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		isl_input => sl_input,
		osl_outputMono => sl_output
);

end  behave;

