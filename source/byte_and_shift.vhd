----------------------------------------------------------------------
--! @file  
--! @brief 
--!
--!
--! @author 
--! @date 
--! @version  
--! 
--! note 
--! @todo 
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
--
package byte_and_shift_pkg is
    component byte_and_shift 
    port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_bitInput : in std_logic;
		islv8_MagicWord : in std_logic_vector(7 downto 0);
		oslv_shortA : out signed(15 downto 0);
		oslv_shortB : out signed(15 downto 0);
		osl_outputValid : out std_logic
    );        
    end component byte_and_shift;
            
end package byte_and_shift_pkg;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
Library work;			
	use work.arobot_constant_pkg.all;	
	use work.byte_reader_pkg.all;
	use work.shift_latch_pkg.all;
	
LIBRARY lpm;
USE lpm.all;


entity byte_and_shift is
	generic (baudrate : integer := 115200);
	port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_bitInput : in std_logic;
		islv8_MagicWord : in std_logic_vector(7 downto 0);
		oslv_shortA : out signed(15 downto 0);
		oslv_shortB : out signed(15 downto 0);
		osl_outputValid : out std_logic
	);
end entity byte_and_shift;

architecture RTL of byte_and_shift is
	signal sl_clk50MHz  		: STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 			: STD_LOGIC := '0';
--	signal sl_bitFiltered 		: std_logic := '1';
	signal sl_bitInputRaw 		: std_logic := '1';
	signal sl_bitValid 			: STD_LOGIC := '0'; 
	signal sl_bitValue			: std_logic;
	signal sl_byteValid 		: STD_LOGIC := '0'; 
	signal slv_byteValueRead	: std_logic_vector(7 downto 0);
	
begin

	sl_clk50MHz <= isl_clk50Mhz;
--	sl_Reset <= isl_rst;
	--sl_bitInputRaw <= isl_inputRaw;
	
U_ByteReader : byte_reader
port map
(
		isl_clk50Mhz	=> sl_clk50MHz,--: in std_logic;
		isl_rst 		=> isl_rst,--: in std_logic;
		isl_bitInput 	=> isl_bitInput,--: in std_logic;
		osl_bitValid 	=>  sl_bitValid,--: out std_logic;
		osl_bitValue 	=>  sl_bitValue,--: out std_logic;
		osl_byteValid 	=> sl_byteValid,--: out std_logic;
		oslv_byteValue 	=> slv_byteValueRead--: out std_logic_vector(7 downto 0)
          
);

U_ShiftReg : shift_latch 
	port map (
		isl_clk50Mhz 		=> sl_clk50MHz ,--: in std_logic;
		isl_rst 			=>  isl_rst,--: in std_logic;
		isl_inputBitValid 	=>  sl_bitValid,--: in std_logic;
		isl_bitValue 		=>  sl_bitValue,--: in std_logic;
		islv8_MagicWord 	=>  islv8_MagicWord,--: in std_logic_vector(7 downto 0);
		oslv_shortA 		=>  oslv_shortA,--: out signed(15 downto 0);
		oslv_shortB 		=>  oslv_shortB,--: out signed(15 downto 0);
		osl_outputValid 	=>  osl_outputValid--: out std_logic
	);

end architecture RTL;

