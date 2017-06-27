----------------------------------------------------------------------
--! @file  spi_output_prepare.vhd
--! @brief shift reg
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

--!
package spi_output_prepare_pkg is
    component spi_output_prepare 
    generic(
        bModelSim           : boolean := FALSE
    );
    port (
-- system side
    isl_SystemClock  : in STD_LOGIC;
    islv8_MagicWord  : in std_logic_vector(7 downto 0);
    islv8_Header     : in std_logic_vector(7 downto 0);
    islv32_DataL     : in std_logic_vector(31 downto 0);
    islv32_DataR     : in std_logic_vector(31 downto 0);
    isl_transferData : in std_logic;
    oslv8_outData    : out std_logic_vector(7 downto 0);
    osl_firstByteValid  : out std_logic;
    osl_DataValid    : out std_logic;
    osl_txActive     : out std_logic;
    isl_reset        : in std_logic
    );        
    end component spi_output_prepare;
            
end package spi_output_prepare_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_output_prepare is
    port (
-- system side
    isl_SystemClock  : in STD_LOGIC;
    islv8_MagicWord  : in std_logic_vector(7 downto 0);
    islv8_Header     : in std_logic_vector(7 downto 0);
    islv32_DataL     : in std_logic_vector(31 downto 0);
    islv32_DataR     : in std_logic_vector(31 downto 0);
    isl_transferData : in std_logic;
    oslv8_outData    : out std_logic_vector(7 downto 0);
    osl_firstByteValid  : out std_logic;
    osl_DataValid    : out std_logic;
    osl_txActive     : out std_logic;
    isl_reset        : in std_logic
    );
end entity spi_output_prepare;

architecture RTL of spi_output_prepare is
    
    signal slv80_outputRegister : std_logic_vector(79 downto 0);

begin
    slv80_outputRegister <= islv8_MagicWord & islv8_Header & islv32_DataL & islv32_DataR;


end architecture RTL;
