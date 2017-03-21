----------------------------------------------------------------------
--! @file  
--! @brief 
--!
--!
--! @author 
--! @date 
--! @version  
--! 
-- note 
--! @todo 
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
-- a block with shift register, comparator
-- and output registers 
Library ieee;           
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
--
package cmdVel_parser_pkg is
component cmdVel_parser 
generic (
    eslv8_MagicWord : std_logic_vector(7 downto 0) := x"a5"
);
port (
    isl_clk50Mhz : in std_logic;
    isl_rst : in std_logic;
    isl_inByteValid : in std_logic;
    islv8_byteValue : in std_logic;
    oslv_shortA : out signed(15 downto 0);
    oslv_shortB : out signed(15 downto 0);
    osl_outputValid : out std_logic
);        
end component cmdVel_parser;
            
end package cmdVel_parser_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmdVel_parser is
generic (
    eslv8_MagicWord : std_logic_vector(7 downto 0) := x"a5"
);
port (
    isl_clk50Mhz : in std_logic;
    isl_rst : in std_logic;
    isl_inByteValid : in std_logic;
    islv8_byteValue : in std_logic;
    oslv_shortA : out signed(15 downto 0);
    oslv_shortB : out signed(15 downto 0);
    osl_outputValid : out std_logic
);
end entity cmdVel_parser;

architecture RTL of cmdVel_parser is
    
begin

end architecture RTL;
