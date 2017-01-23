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
--! Use standard library
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

package velocity_issp_pkg is
    component velocity_issp 
	generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
	);
    port (
		isl_clk50Mhz 		: in std_logic;
		isl_rst 			: in std_logic;
		in16_inputVector 	: in signed (15 downto 0);
		osl_mux 			: out std_logic;--_vector(0 downto 0);
		on16_outputVector 	: out signed (15 downto 0)
    );        
    end component velocity_issp;
            
end package velocity_issp_pkg;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	

entity velocity_issp is
	generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
	);
	port(
		isl_clk50Mhz 		: in std_logic;
		isl_rst 			: in std_logic;
		in16_inputVector 	: in signed (15 downto 0);
		osl_mux 			: out std_logic;--_vector(0 downto 0);
		on16_outputVector 	: out signed (15 downto 0)
	);
end entity velocity_issp;

architecture RTL of velocity_issp is
	signal slv_VelocityMux : std_logic_vector (0 downto 0);
	signal n16_Velocity 	: signed (15 downto 0);
	signal slv16_Velocity 	: std_logic_vector (15 downto 0);
begin

	osl_mux <= slv_VelocityMux(0);
	
	n16_Velocity <= signed(slv16_Velocity);
on16_outputVector <= n16_Velocity  when (slv_VelocityMux(0) = '1') else
	in16_inputVector;

    U_Velocity_CONFIGURE : entity work.issp_InOut
		generic map(
			bModelSim    => bModelSim,
			instance_id  => str_ISSP_VELOCITY,
			source_init  => n16_velocity_55,
			probe_width  => n16_Velocity'Length,
			source_width => n16_Velocity'Length
		)
		port map(
			i_sl_source_clk => isl_clk50Mhz,
			i_slv_probe     => slv16_Velocity,
			o_slv_source    => slv16_Velocity
		);

    U_Velocity_MUX : entity work.issp_InOut
		generic map(
			bModelSim    => bModelSim,
			instance_id  => str_ISSP_VELOCITY_MUX,
			source_init  => "1",
			probe_width  => 1,
			source_width => 1
		)
		port map(
			i_sl_source_clk => isl_clk50Mhz,
			i_slv_probe     => slv_VelocityMux,
			o_slv_source    => slv_VelocityMux
		);

end architecture RTL;
