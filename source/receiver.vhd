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
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
--
package receiver_pkg is
    component receiver 
    port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_inputRaw : in std_logic;
		osl_byteValid : out std_logic;
		oslv_byteValue : out std_logic_vector(7 downto 0)
    );        
    end component receiver;
            
end package receiver_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library work;           
	use work.byte_reader_pkg.all;
	use work.bit_filter_pkg.all;

entity receiver is
	port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_inputRaw : in std_logic;
		osl_byteValid : out std_logic;
		oslv_byteValue : out std_logic_vector(7 downto 0)
	);
end entity receiver;

architecture RTL of receiver is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_bitFiltered : std_logic := '1';
	signal sl_bitInputRaw : std_logic := '1';
	signal  sl_byteValid : std_logic := '0';
	signal  slv_byteValueRead : std_logic_vector(7 downto 0) := x"00" ;
	
begin

	sl_clk50MHz <= isl_clk50Mhz;
	sl_Reset <= isl_rst;
	sl_bitInputRaw <= isl_inputRaw;
	osl_byteValid <= sl_byteValid;
	oslv_byteValue <= slv_byteValueRead;
	
U_BitFilter : bit_filter
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		isl_inputRaw => sl_bitInputRaw,--: in std_logic;
		osl_outputFiltered => sl_bitFiltered--: out std_logic
          
);


U_Bytereader : byte_reader
port map
(
		isl_clk50Mhz	=> sl_clk50MHz,--: in std_logic;
		isl_rst 		=> sl_Reset,--: in std_logic;
		isl_bitInput 	=> sl_bitFiltered,--: in std_logic;
		osl_byteValid 	=> sl_byteValid,--: out std_logic;
		oslv_byteValue 	=> slv_byteValueRead--: out std_logic_vector(7 downto 0)
          
);

end architecture RTL;
