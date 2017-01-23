Library ieee;           use ieee.std_logic_1164.all;
                        --use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
                        --use ieee.numeric.std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
                        --use work.treatment_tcc.all;
                        --use work.fpga_main_tcc.all;
                        --use work.fpga_main_stim_tcc.all;
                        --use work.fpga_main_stim_fp.all;
                        use work.bit_filter_pkg.all;
entity bit_filter_TB is
end bit_filter_TB;

architecture behave of bit_filter_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_inputRaw : std_logic := '0';
	signal sl_outputFiltered : std_logic;
--	signal slv_inputValue : STD_LOGIC_VECTOR(31 downto 0);
	--signal slv_ModuloValue : std_logic_vector(7 downto 0);
	--signal slv_OutputValue : std_logic_vector(7 downto 0);
begin	

U_DUT : bit_filter
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		isl_inputRaw => sl_inputRaw,--: in std_logic;
		osl_outputFiltered => sl_outputFiltered--: out std_logic
          
);

-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 12 ns;
 
 U_INPUT: process
 begin
 	wait for 500 ns;
 	sl_inputRaw <= '1';
 	wait for 2000 ns;
 	sl_inputRaw <= '0';
 	wait for 5000 ns;
 	sl_inputRaw <= '1';
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