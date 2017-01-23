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
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

package position_issp_pkg is
    component position_issp 
	generic(
		bModelSim : boolean := TRUE
	);
    port (
		isl_clk50Mhz 		: in std_logic;
		isl_rst 			: in std_logic;
		islv6_inputPosition : in std_logic_vector(5 downto 0);	--! output from integrator
		osl_mux 			: out std_logic;--_vector(0 downto 0);
		oslv6_outputPosition : out std_logic_vector(5 downto 0)	--! input from module_divider
    );        
    end component position_issp;
            
end package position_issp_pkg;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	

entity position_issp is
	generic(
		bModelSim : boolean := TRUE
	);
	port (
		isl_clk50Mhz 		: in std_logic;
		isl_rst 			: in std_logic;
		islv6_inputPosition : in std_logic_vector(5 downto 0);	--! output from integrator
		osl_mux 			: out std_logic;--_vector(0 downto 0);
		oslv6_outputPosition : out std_logic_vector(5 downto 0)	--! input from module_divider
	);
end entity position_issp;

--! @brief
--! @details
architecture RTL of position_issp is
	signal slv_PositionMux : std_logic_vector (0 downto 0);
	signal slv6_Position 	: std_logic_vector(5 downto 0);
	
begin
	
	osl_mux <= slv_PositionMux(0);
	
	--slv8_Position <= signed(slv16_Position);
oslv6_outputPosition <= slv6_Position  when (slv_PositionMux(0) = '1') else
	islv6_inputPosition;

    U_Position_CONFIGURE : entity work.issp_InOut
		generic map(
			bModelSim    => bModelSim,
			instance_id  => str_ISSP_POSITION,
			source_init  => slv6_position_08,
			probe_width  => slv6_Position'Length,
			source_width => slv6_Position'Length
		)
		port map(
			i_sl_source_clk => isl_clk50Mhz,
			i_slv_probe     => slv6_Position,
			o_slv_source    => slv6_Position
		);

    U_Position_MUX : entity work.issp_InOut
		generic map(
			bModelSim    => bModelSim,
			instance_id  => str_ISSP_POSITION_MUX,
			source_init  => "1",
			probe_width  => 1,
			source_width => 1
		)
		port map(
			i_sl_source_clk => isl_clk50Mhz,
			i_slv_probe     => slv_PositionMux,
			o_slv_source    => slv_PositionMux
		);

end architecture RTL;
