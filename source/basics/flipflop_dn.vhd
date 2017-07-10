-----------------------------------------------------------------------------------
--! @ file
--! generic dffe flip flop
--! 29.08.2016
--! use standard library
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package flipflop_dn_pkg is
    COMPONENT flipflop_dn
    generic(
        WIDTH : integer
    );
    PORT
    (
    isl_clock   : in STD_LOGIC;
    islv_d       : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    isl_ena     : in STD_LOGIC;
    isl_reset   : in STD_LOGIC;
    oslv_out     : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
    END COMPONENT;    
end flipflop_dn_pkg;
    
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;

entity flipflop_dn is
    generic(
        WIDTH : integer
    );
    PORT
    (
    isl_clock   : in STD_LOGIC;
    islv_d       : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    isl_ena     : in STD_LOGIC;
    isl_reset   : in STD_LOGIC;
    oslv_out     : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end flipflop_dn;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture rtl of flipflop_dn is
    signal slv_out     : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
begin
    oslv_out <= slv_out;
	process(isl_clock, isl_reset,isl_ena , islv_d) is 
    variable vslv_out     :  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
begin 
    vslv_out := slv_out; 
		if (isl_reset = '1') then
				vslv_out := (others => '0');
		elsif (rising_edge(isl_clock)) then
			if(isl_ena = '1') then
				vslv_out := islv_d;
			end if;	
		end if;
	slv_out <= vslv_out;
	end process;	
	
end rtl;	
