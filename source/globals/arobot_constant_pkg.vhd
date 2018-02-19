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

-- serial magic word Byte
    constant eMagicRead         : std_logic_vector(7 downto 0) := x"A5";
-- SPI magic wird and defines      
    constant eslv8_MagicByte0   : std_logic_vector(7 downto 0) := x"AA";
    constant eslv8_MagicByte1   : std_logic_vector(7 downto 0) := x"55";
    constant eslv16_CmdVelocity : std_logic_vector(15 downto 0) := x"0000";
    constant eslv16_CmdRamp     : std_logic_vector(15 downto 0) := x"0000";
    constant eslv16_CmdMicroSt  : std_logic_vector(15 downto 0) := x"0000";


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
--! |   0x010 | w  | microstep/step reg32   |   max 0x10    |                      |
--! |         | w  |  (byte0)           | axis L                  |                      |
--! |         | w  |  (byte1)           |                  |                      |
--! |         | w  |  (byte2)           | axis R                          |                      |
--! |         | w  |  (byte3)           |                           |                      |
--! |   0x100 | r  |  status reg32      | high level status of fpga                 | |
--! |   0x104 | r  | position absolute reg32      |              | |
--! |   0x108 | r  | position modulo reg32      |              | |
--! |   0x10C | r  | Revision reg32     |   | @ref fpga_version |
--! |         | w  |  (byte0)           | build nr                  |                      |
--! |         | w  |  (byte1)           | version subnumber                |                      |
--! |         | w  |  (byte2)           | version number                          |                      |
--! |         | w  |  (byte3)           |                           |                      |


end arobot_constant_pkg;