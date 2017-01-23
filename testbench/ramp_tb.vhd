Library std;
	use std.standard.all;
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
	use work.arobot_constant_pkg.all;
	use work.arobot_component_pkg.all;
                        use work.ramp_pkg.all;
                        use work.byte_reader_stim_fp.all;
                        
entity ramp_TB is
end ramp_TB;

architecture behave of ramp_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_sliceTick :  std_logic := '0';
	signal n16_inputVector : signed (15 downto 0) := x"0010";
	signal n16_rampValue  : signed (15 downto 0) := x"0040";
	signal n16_outValue : signed (15 downto 0) := x"0000";

begin	

 U_SIMUL: process
 begin
 	wait for 20 us;
 	n16_inputVector <= x"0400";
 	wait for 20 us;
 	n16_inputVector <= x"fc00";
 	wait;
 end process;	

--sliceTickPr : process
--begin
--	if(sl_sliceTick = '0') then
--		wait for 10 ms;
--		sl_sliceTick <= '1';
--	else
--		wait for 20 ns;
--		sl_sliceTick <= '0';
--	end if;		
--	
--	end process;

U_DUT : ramp
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		isl_sliceTick   => sl_sliceTick,--: in std_logic;
		in16_inputVector  => n16_inputVector,--: in signed(15 downto 0);
		in16_rampValue   => n16_rampValue,--: in signed(15 downto 0);
		on16_outValue  => n16_outValue--: out signed(15 downto 0)
);

-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;
    
    sl_sliceTick   <= not sl_sliceTick after 1 us;

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
end  behave;
