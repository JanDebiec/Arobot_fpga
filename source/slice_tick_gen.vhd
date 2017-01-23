----------------------------------------------------------------------
--! @file  
--! @brief generator for slice tick
--! configured by input in32_periodCount.
--! default 50 msecs
--!
--! @author Jan Debiec
--! @date 13.05.2015
--! @version  0.3
--! 
-- note 
--! @todo 
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
--! Use standard library
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	

--!
package slice_tick_gen_pkg is
    component slice_tick_gen 
    generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
    );
    port (
		isl_clk50Mhz 		: in std_logic;	--!
		isl_rst 			: in std_logic;	--!
		in32_periodCount 	: in signed (31 downto 0);
		osl_slice_tick		: out std_logic	--!
    );        
    end component slice_tick_gen;
            
end package slice_tick_gen_pkg;

Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
--!
entity slice_tick_gen is
    generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
    );
    port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		in32_periodCount 	: in signed (31 downto 0);--! amount of clock ticks per period
		osl_slice_tick		: out std_logic	--! output tick for synchronizing ramp, integrator, .
    );        
end entity slice_tick_gen;

--!
architecture RTL of slice_tick_gen is
	signal n32_periodCount 		: signed (31 downto 0);	--! compare value for counter
	signal n32_periodCountIssp 	: signed (31 downto 0);	--! compare value for counter, used by issp 
	signal n32_periodCounter 	: signed (31 downto 0);	--! running counter 
	signal n32_Zero 			: signed(31 downto 0) := x"0000_0000";	--!

begin
	
--!
P_PeriodCounter : process(
	isl_clk50Mhz
) is
begin
    if (rising_edge(isl_clk50Mhz)) then
		if(n32_periodCounter = n32_Zero) then
			n32_periodCounter <= n32_periodCount;
			osl_slice_tick <= '1';
		else
			n32_periodCounter <= n32_periodCounter - 1;
			osl_slice_tick <= '0';
		end if;	 	
    END IF;
end process;

n32_periodCount <= n32_periodCountIssp when (bISSP = TRUE and bModelSim = FALSE) else
				in32_periodCount;

--!
U_ISSP_JTAG : if (bISSP = TRUE and bModelSim = FALSE) generate
begin
	U_ISSP_COMP : entity work.slice_tick_issp
		generic map(
			bModelSim => FALSE
		)
		port map(
			isl_clk50Mhz => isl_clk50Mhz,
			isl_rst       => isl_rst,
			in32_periodCount => in32_periodCount,
			on32_periodCount => n32_periodCountIssp
		);
end generate;
	
end architecture RTL;

	