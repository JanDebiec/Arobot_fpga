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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmd_extractor is
	port (
		clk : in std_logic;
		rst : in std_logic
	);
end entity cmd_extractor;

architecture RTL of cmd_extractor is
	
begin

U_SHIFT_REG : shift_latch
port map(
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_inputBitValid : in std_logic;
		isl_bitValue : in std_logic;
		islv8_MagicWord : in std_logic_vector(7 downto 0);
		oslv_shortA : out signed(15 downto 0);
		oslv_shortB : out signed(15 downto 0);
		osl_outputValid : out std_logic
	
)

end architecture RTL;
