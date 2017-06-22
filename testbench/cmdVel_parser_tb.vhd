Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
                        use work.cmdVel_parser_pkg.all;
                        
entity cmdVel_parser_TB is
end cmdVel_parser_TB;

architecture behave of cmdVel_parser_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_bitValid : std_logic := '0';
	signal sl_byteValid : std_logic := '0';
	signal slv8_byteValue : std_logic_vector(7 downto 0) ;
    signal slv8_Inputbyte : std_logic_vector(7 downto 0) ;
	signal slv_shortA: signed(15 downto 0) ;
	signal slv_shortB: signed(15 downto 0) ;
	signal sl_outputValid: std_logic := '0';
begin	

U_DUT : cmdVel_parser
    port map
    (
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst 			=> sl_Reset,--: in std_logic;
		isl_inByteValid 	=> sl_byteValid,--: in std_logic;
		islv8_byteValue 	=> slv8_Inputbyte,--: in std_logic_vector(7 downto 0);
		oslv_shortVelA 		=> slv_shortA,--: out signed(15 downto 0);
		oslv_shortVelB 		=> slv_shortB,--: out signed(15 downto 0);
		osl_outputValid 	=> sl_outputValid--: out std_logic
    );        

 
 U_SIMUL: process
 procedure byte_write(
    signal slv8_InputValue : in std_logic_vector(7 downto 0)
)
 is
 begin
    wait until (sl_clk50MHz = '1');
    slv8_Inputbyte <= slv8_InputValue;
    wait until ((sl_clk50MHz = '1'));
    sl_byteValid <= '1';
    wait until ((sl_clk50MHz = '1'));
    sl_byteValid <= '0';
    wait until ((sl_clk50MHz = '1'));
    slv8_Inputbyte <= x"00";
    wait for 1 us;
 end procedure;    
 begin
 	wait for 1000 ns;
 	
 	slv8_byteValue <= x"a3";
 	byte_write(slv8_byteValue );

 	slv8_byteValue <= x"A5";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"00";
    byte_write(slv8_byteValue );
	 	
 	slv8_byteValue <= x"80";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"44";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"05";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"22";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"A5";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"01";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"c0";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"22";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"33";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"22";
    byte_write(slv8_byteValue );

 	slv8_byteValue <= x"A5";
    byte_write(slv8_byteValue );
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