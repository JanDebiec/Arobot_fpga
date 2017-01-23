-----------------------------------------------------------------------------------
--! @ file
--! @brief rs flipflop
-- 01.10.2012
-----------------------------------------------------------------------------------
--! use standard library
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

--! srff component as package
package srflipflop_pkg is
    COMPONENT srflipflop
    PORT
    (
        isl_clock       :    IN STD_LOGIC;
        isl_s       :    IN STD_LOGIC;
        isl_r       :    IN STD_LOGIC;
        isl_reset       :    IN STD_LOGIC;
        osl_out     :    OUT STD_LOGIC
    );
    END COMPONENT;    
end srflipflop_pkg;
    
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;


--! standard sr flipflop

--! details
--!
entity srflipflop is
port (
	isl_clock	: in STD_LOGIC;--! input clock
	isl_s		: in STD_LOGIC;--! input set
	isl_r		: in STD_LOGIC;--! input clear
	isl_reset	: in STD_LOGIC;--! input reset
	osl_out		: out STD_LOGIC := '0'--! output
	);
end srflipflop;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture rtl of srflipflop is
begin
	process(isl_clock) is 
	begin 
		if (rising_edge(isl_clock)) then
			if (isl_reset = '1') then
				osl_out <= '0';
			else
				if(isl_s = '1') then
					osl_out <= '1';
				elsif (isl_r = '1') then
					osl_out <= '0';
				end if;
			end if;
		end if;
	end process;	
	
end rtl;	

--end package body srflipflop_c;
