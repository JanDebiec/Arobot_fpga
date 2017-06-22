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

    constant ADDR_WIDTH : integer := 2;
    constant DATA_WIDTH : integer := 16;
    constant MEM_DEPTH : integer := 2**ADDR_WIDTH;

  constant some_true_condition : boolean := true;
  constant some_false_condition : boolean := false;
-- new values for DpRAM    
    constant eClkTickCount : integer := 8;
    constant eAdc1SetTickCount : integer := 1;
    constant eAdc1ClearTickCount : integer := 2;
    constant eHalfClkTickCount : integer := 4;
    constant eAdc2SetTickCount : integer := 5;
    constant eAdc2ClearTickCount : integer := 6;
    constant eMemWrSetTickCount : integer := 10;
    constant eMemWrClearTickCount : integer := 11;
--old values for ILX
--    constant eClkTickCount : integer := 12;
--    constant eAdc1SetTickCount : integer := 2;
--    constant eAdc1ClearTickCount : integer := 3;
--    constant eHalfClkTickCount : integer := 6;
--    constant eAdc2SetTickCount : integer := 8;
--    constant eAdc2ClearTickCount : integer := 9;
--    constant eMemWrSetTickCount : integer := 10;
--    constant eMemWrClearTickCount : integer := 11;
    --type short_ascii_type is string(15 downto 0);
    type mem_type is array ( 0 to MEM_DEPTH-1) of signed(DATA_WIDTH-1 downto 0);
    type rec_RAMIn_type is record
        slv10_Addr      : STD_LOGIC_VECTOR(9 downto 0);
        sl_RdReq        : STD_LOGIC;
    end record;
    
    type rec_RAMOut_type is record
        slv16_outputValue : STD_LOGIC_VECTOR(15 downto 0);
        sl_outputValid    : STD_LOGIC;
        slv4_state        : STD_LOGIC_VECTOR(3 downto 0);
    end record;


    type rec_H2fIn_type is record
	    slv8_address       : std_logic_vector(7 downto 0);-- address
	    slv4_ext_lw_bus_byte_enable   : std_logic_vector(3 downto 0);-- byte_enable
   		sl_ext_lw_bus_acknowledge     : std_logic;             -- acknowledge--        slv32_outputValue : STD_LOGIC_VECTOR(31 downto 0);
    	slv32_ext_lw_bus_read_data    : std_logic_vector(31 downto 0); -- read_data        slv4_state        : STD_LOGIC_VECTOR(3 downto 0);
 	    slv32_ext_lw_bus_write_data   : std_logic_vector(31 downto 0);-- write_data
    end record;
    
    type rec_H2fOut_type is record
        slv8_ext_lw_bus_address       : std_logic_vector(7 downto 0);-- address
	    sl_ext_lw_bus_rw              : std_logic;                   -- rw
	    sl_ext_lw_bus_bus_enable      : std_logic;                  -- bus_enable
    	sl_ext_lw_bus_irq             : std_logic;             -- irq        sl_ack    : STD_LOGIC;
    	slv32_read_data    : std_logic_vector(31 downto 0); -- read_data        slv4_state        : STD_LOGIC_VECTOR(3 downto 0);
        slv4_state        : STD_LOGIC_VECTOR(3 downto 0);
    end record;
    
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
