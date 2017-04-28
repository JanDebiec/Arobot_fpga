Library ieee;           use ieee.std_logic_1164.all;
                        --use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
                        --use ieee.numeric.std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
                        use work.byte_reader_pkg.all;
                        use work.byte_reader_stim_fp.all;
                        
entity byte_reader_TB is
end byte_reader_TB;

architecture behave of byte_reader_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_inputRaw : std_logic := '0';
	signal sl_outputFiltered : std_logic;
	signal sl_bitInput : std_logic := '1';
	signal sl_bitValid : std_logic := '0';
	signal  sl_byteValid : std_logic := '0';
	signal  slv_byteValueRead : std_logic_vector(7 downto 0) := x"00" ;
	signal  slv_byteValueOutput : std_logic_vector(7 downto 0) := x"00" ;
	signal slv8_byteValue : std_logic_vector(7 downto 0) ;
begin	

U_DUT : byte_reader
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		isl_bitInput => sl_bitInput,--: in std_logic;
		osl_byteValid => sl_byteValid,--: out std_logic;
		oslv_byteValue => slv_byteValueRead--: out std_logic_vector(7 downto 0)
          
);

readBytePr : process(
	sl_byteValid
)is
begin
	if(sl_byteValid = '1') then
		slv_byteValueOutput <= slv_byteValueRead;
	end if;	
	end process;
 
 
 
 U_SIMUL: process
 begin
 	wait for 10000 ns;
 	
 	slv8_byteValue <= x"A8";
 	
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

	wait for 5000ns;

 	slv8_byteValue <= x"A4";
 	
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);
 	slv8_byteValue <= x"A2";
 	
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);
	 	
 	wait; 	
 	end process;
        
-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;

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