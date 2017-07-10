-----------------------------------------------------------------------------------
--! @ file
--! generic sre flip flop
--! 29.08.2016
--! use standard library
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package flipflop_sre_pkg is
    COMPONENT flipflop_sre
    PORT
    (
    isl_clock   : in STD_LOGIC;
    isl_s       : in STD_LOGIC;
    isl_r       : in STD_LOGIC;
    isl_ena     : in STD_LOGIC;
    isl_reset   : in STD_LOGIC;
    osl_out     : out STD_LOGIC
    );
    END COMPONENT;    
end flipflop_sre_pkg;
    
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;

entity flipflop_sre is
    PORT
    (
    isl_clock   : in STD_LOGIC;
    isl_s       : in STD_LOGIC;
    isl_r       : in STD_LOGIC;
    isl_ena     : in STD_LOGIC;
    isl_reset   : in STD_LOGIC;
    osl_out     : out STD_LOGIC
    );
end flipflop_sre;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture rtl of flipflop_sre is
    signal sl_out     : STD_LOGIC;
begin
    osl_out <= sl_out;
process(all) is 
--    variable vsl_out     :  STD_LOGIC;
begin 
--    vsl_out := sl_out; 
	if (isl_reset = '1') then
			sl_out <= '0';
	elsif (rising_edge(isl_clock)) then
		if(isl_ena = '1') then
            if(isl_s = '1') then
                sl_out <= '1';
            elsif (isl_r = '1') then
                sl_out <= '0';
            end if;
		end if;	
	end if;
end process;	
	
--process(isl_clock, isl_reset, isl_ena , isl_s, isl_r, sl_out) is 
--    variable vsl_out     :  STD_LOGIC;
--begin 
--    vsl_out := sl_out; 
--        if (isl_reset = '1') then
--                vsl_out := '0';
--        elsif (rising_edge(isl_clock)) then
--            if(isl_ena = '1') then
--                if(isl_s = '1') then
--                    vsl_out := '1';
--                elsif (isl_r = '1') then
--                    vsl_out := '0';
--                end if;
--            else    
--                vsl_out := sl_out; 
--            end if; 
--        else    
--            vsl_out := sl_out; 
--        end if;
--    sl_out <= vsl_out;
--    end process;    
    
end rtl;	
