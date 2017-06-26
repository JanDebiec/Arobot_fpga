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
    isl_SystemClock  : in STD_LOGIC ;
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
    isl_SystemClock  : in STD_LOGIC ;
    isl_reset        : in std_logic
    );
end entity spi_output_prepare;

architecture RTL of spi_output_prepare is
    
begin

end architecture RTL;
