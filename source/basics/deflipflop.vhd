-----------------------------------------------------------------------------------
--! @ file
-- dffe flip flop
-- 01.10.2012
--! use standard library
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package deflipflop_pkg is
    COMPONENT deflipflop
    PORT
    (
    isl_clock   : in STD_LOGIC;
    isl_d       : in STD_LOGIC;
    isl_ena     : in STD_LOGIC;
    isl_reset   : in STD_LOGIC;
    osl_out     : out STD_LOGIC
    );
    END COMPONENT;    
end deflipflop_pkg;
    
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;

entity deflipflop is
port (
	isl_clock	: in STD_LOGIC;
	isl_d		: in STD_LOGIC;
	isl_ena		: in STD_LOGIC;
	isl_reset	: in STD_LOGIC;
	osl_out		: out STD_LOGIC
	);
end deflipflop;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture rtl of deflipflop is
begin
	process(isl_clock, isl_reset,isl_ena , isl_d) is 
	begin 
		if (isl_reset = '1') then
				osl_out <= '0';
		elsif (rising_edge(isl_clock)) then
			if(isl_ena = '1') then
				if (isl_d = '1') then
					osl_out <= '1';
				else 
					osl_out <='0';
				end if;	
			end if;	
		end if;
	end process;	
	
end rtl;	
