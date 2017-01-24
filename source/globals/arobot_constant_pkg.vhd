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
--! Use standard library
Library ieee; 			
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
  --! global constants and defines used in whole design
PACKAGE arobot_constant_pkg IS

    constant str_ISSP_SLICE_TICK        : string := "0001";
    constant str_ISSP_SLICE_TICK_MUX    : string := "0002";
    constant str_ISSP_VELOCITY        	: string := "0003";
    constant str_ISSP_VELOCITY_MUX     	: string := "0004";
    constant str_ISSP_POSITION     		: string := "0005";
    constant str_ISSP_POSITION_MUX     	: string := "0006";
    constant n32_100ms_tick_reload		: string := x"004C4B40";
    constant n16_velocity_55			: string := x"0055";
    constant slv6_position_08			: string := "001000";

-- addr 7,6 block, 5 .. 0 detail
-- 11 pll
-- 10 reserve
-- 01 read status
-- 00 write config
constant c_slv2_h2f_block_pll        : std_logic_vector(1 downto 0) :=  "11";
constant c_slv2_h2f_block_reserve    : std_logic_vector(1 downto 0) :=  "10";
constant c_slv2_h2f_block_read       : std_logic_vector(1 downto 0) :=  "01";
constant c_slv2_h2f_block_write      : std_logic_vector(1 downto 0) :=  "00";
-- h2f lw interface write address	8 bits 
constant c_slv8_h2f_address_PeriodCount  : std_logic_vector(7 downto 0) :=  x"04";
constant c_slv8_h2f_address_RampValue	 : std_logic_vector(7 downto 0) :=  x"08";
constant c_slv8_h2f_address_InputValue	 : std_logic_vector(7 downto 0) :=  x"0C";

-- h2f lw interface read address   8 bits 
constant c_slv8_h2f_address_Status       : std_logic_vector(7 downto 0) :=  x"80";
constant c_slv8_h2f_address_PosModulo : std_logic_vector(7 downto 0) :=  x"84";
constant c_slv8_h2f_address_Version      : std_logic_vector(7 downto 0) :=  x"8C";

end arobot_constant_pkg;