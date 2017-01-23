----------------------------------------------------------------------
--! @file  
--! @brief 
--!
--!
--! @author 
--! @date 
--! @version  
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

package slice_tick_issp_pkg is
    component slice_tick_issp 
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
    end component slice_tick_issp;
            
end package slice_tick_issp_pkg;

Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	
entity slice_tick_issp is
    generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
    );
    port (
		isl_clk50Mhz 		: in std_logic;	--!
		isl_rst 			: in std_logic;	--!
		in32_periodCount 	: in signed (31 downto 0);
		on32_periodCount 	: out signed (31 downto 0)
    );        
end entity slice_tick_issp;

architecture RTL of slice_tick_issp is
	signal slv32_periodCount 	: std_logic_vector (31 downto 0);
	signal slv_periodCountMux 	: std_logic_vector (0 downto 0);
begin
	on32_periodCount <= signed(slv32_periodCount) when (slv_periodCountMux(0) = '1') else
				in32_periodCount;
				
    U_PERIOD_CONFIGURE : entity work.issp_InOut
		generic map(
			bModelSim    => bModelSim,
			instance_id  => str_ISSP_SLICE_TICK,
			source_init  => n32_100ms_tick_reload,
			probe_width  => slv32_periodCount'Length,
			source_width => slv32_periodCount'Length
		)
		port map(
			i_sl_source_clk => isl_clk50Mhz,
			i_slv_probe     => slv32_periodCount,
			o_slv_source    => slv32_periodCount
		);

    U_PERIOD_MUX : entity work.issp_InOut
		generic map(
			bModelSim    => bModelSim,
			instance_id  => str_ISSP_SLICE_TICK_MUX,
			source_init  => "1",
			probe_width  => 1,
			source_width => 1
		)
		port map(
			i_sl_source_clk => isl_clk50Mhz,
			i_slv_probe     => slv_periodCountMux,
			o_slv_source    => slv_periodCountMux
		);

 end RTL;	
