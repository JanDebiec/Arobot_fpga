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
constant c_slv8_h2f_address_Status       : std_logic_vector(7 downto 0) :=  x"00";
constant c_slv8_h2f_address_PosAbsolute  : std_logic_vector(7 downto 0) :=  x"04";
constant c_slv8_h2f_address_PosModulo    : std_logic_vector(7 downto 0) :=  x"08";
constant c_slv8_h2f_address_Version      : std_logic_vector(7 downto 0) :=  x"0C";

--! @page h2flw_addr H2F light-weigth bridge address space
--! 32 bits registers on H2F interface (rw seen from ARM side) 
--! | address | rw | name               | functionality  | link to doc          |
--! |:-------:|:--:|:------------------:|:-------------------------:|:--------------------:|
--! |   0x004 | w  | ramp period reg32  |                16 bits    |                      |
--! |         | w  |  (byte0)           | low byte                  |                      |
--! |         | w  |  (byte1)           | high byte                 |                      |
--! |         | w  |  (byte2)           |                           |                      |
--! |         | w  |  (byte3)           |                           |                      |
--! |   0x008 | w  | ramp value reg32   |                16 bits    |                      |
--! |         | w  |  (byte0)           | low byte                  |                      |
--! |         | w  |  (byte1)           | high byte                 |                      |
--! |         | w  |  (byte2)           |                           |                      |
--! |         | w  |  (byte3)           |                           |                      |
--! |   0x00C | w  | velocity  reg32    | L, R: 1 bit direction + 15 bits | |
--! |         | w  |  (byte0)           | Right axis low byte                  |                      |
--! |         | w  |  (byte1) bit 15    | Right axis direction                 |                      |
--! |         | w  |  (byte1) bits(14-8)| Right axis high 7 bits                 |                      |
--! |         | w  |  (byte2)           | Left axis low byte                  |                      |
--! |         | w  |  (byte3) bit 31    | Left axis direction                 |                      |
--! |         | w  |  (byte3) bits(30-24)| Left axis high 7 bits                 |                      |
--! |   0x100 | r  |  status reg32      | high level status of fpga                 | |
--! |   0x104 | r  | position absolute reg32      |              | |
--! |   0x108 | r  | position modulo reg32      |              | |
--! |   0x10C | r  | Revision reg32     |   | @ref fpga_version |
--! |         | w  |  (byte0)           | build nr                  |                      |
--! |         | w  |  (byte1)           | version subnumber                |                      |
--! |         | w  |  (byte2)           | version number                          |                      |
--! |         | w  |  (byte3)           |                           |                      |


end arobot_constant_pkg;