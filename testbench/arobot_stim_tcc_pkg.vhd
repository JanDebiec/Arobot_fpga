----------------------------------------------------------------------
--! @file  arobot_stim_tcc_pkg.vhd
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
    use std.textio.all;

package arobot_stim_tcc_pkg is

    
    type rec_SpiMosi_type is record
        sl_SpiClk   : std_logic;
        sl_SpiMosi  : std_logic;
        slv_Byte2Tx : std_logic_vector(7 downto 0);
        n_Index : integer;
    end record;    
    
    
    type rec_SpiMiso_type is record
        sl_SpiClk   : std_logic;
        n_Index : integer;
    end record;    
    
    type rec_SpiDataByte_type is record
        slv_Byte2Tx : std_logic_vector(7 downto 0);
    end record;    
  
end package arobot_stim_tcc_pkg;

package body arobot_stim_tcc_pkg is
    
end package body arobot_stim_tcc_pkg;
