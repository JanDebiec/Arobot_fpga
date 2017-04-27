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
PACKAGE arobot_typedef_pkg IS

TYPE SixBytesShiftRegs IS ARRAY (5 DOWNTO 0)OF STD_LOGIC_VECTOR(7 DOWNTO 0);
SUBTYPE uPingPongIndex IS INTEGER RANGE 0 TO 2;
SUBTYPE uShiftIndex8 IS INTEGER RANGE -1 TO 8;
end arobot_typedef_pkg;