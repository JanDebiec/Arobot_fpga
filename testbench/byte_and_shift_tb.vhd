--TODO: include byte_adn_shift.vhd
Library ieee;           use ieee.std_logic_1164.all;
                        --use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
                        --use ieee.numeric.std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
                        use work.shift_latch_pkg.all;
                        use work.byte_reader_pkg.all;
                        use work.byte_and_shift_pkg.all;
                        use work.byte_reader_stim_fp.all;
                        
entity byte_and_shift_TB is
end byte_and_shift_TB;

architecture behave of byte_and_shift_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_inputRaw : std_logic := '0';
	signal sl_outputFiltered : std_logic;
	signal sl_bitInput : std_logic := '1';
	signal sl_bitValid : std_logic := '0';
	signal sl_byteValid : std_logic := '0';
	signal slv8_byteValue : std_logic_vector(7 downto 0) ;
	signal slv8_MagicWord: std_logic_vector(7 downto 0) := X"A5" ;
	signal slv_shortA: signed(15 downto 0) ;
	signal slv_shortB: signed(15 downto 0) ;
	signal sl_outputValid: std_logic := '0';
begin	

U_DUT : byte_and_shift
    port map
    (
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst 			=> sl_Reset,--: in std_logic;
		isl_bitInput 		=> sl_bitInput,--: in std_logic;
		islv8_MagicWord 	=> slv8_MagicWord,--: in std_logic_vector(7 downto 0);
		oslv_shortA 		=> slv_shortA,--: out signed(15 downto 0);
		oslv_shortB 		=> slv_shortB,--: out signed(15 downto 0);
		osl_outputValid 	=> sl_outputValid--: out std_logic
    );        

 
 U_SIMUL: process
 begin
 	wait for 1000 ns;
 	
 	slv8_byteValue <= x"a3";
 	
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

	--wait for 5000ns;

 	slv8_byteValue <= x"A5";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"00";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);
	 	
 	slv8_byteValue <= x"80";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"44";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"05";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"22";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"A5";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"01";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"c0";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"22";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"33";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"22";
 	byte_write(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		slv8_byteValue => slv8_byteValue,--: in std_logic_vector(7 downto 0);
		sl_bitValue => sl_bitInput--: out std_logic
 	);

 	slv8_byteValue <= x"A5";
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