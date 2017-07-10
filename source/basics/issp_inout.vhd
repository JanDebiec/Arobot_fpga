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
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--
package issp_InOut_pkg is
-- 
    component issp_InOut is
        generic (
            bModelSim    : boolean := FALSE;
            instance_id  : string  := "NONE";
            source_init  : string  :=  "0";
            probe_width  : integer := 4;
            source_width : integer := 4
        );
        port (
            i_sl_source_clk : in std_logic;
            i_slv_probe     : in STD_LOGIC_VECTOR( probe_width-1  downto 0 );
            o_slv_source    : out STD_LOGIC_VECTOR( source_width-1 downto 0 )
        );
    end component issp_InOut;
-- 
end issp_InOut_pkg;
--
--------------------------------------------------------------------------------------------------- entity
-- 
library ieee;
use ieee.std_logic_1164.all;

library altera_mf;
use altera_mf.all;

entity issp_InOut is
    generic (
        bModelSim    : boolean := FALSE;
        instance_id  : string  := "NONE";
        source_init  : string  :=  "0";
        probe_width  : integer := 4;
        source_width : integer := 4
    );
    port (
        i_sl_source_clk : in std_logic;
        i_slv_probe     : in STD_LOGIC_VECTOR( probe_width-1  downto 0 );
        o_slv_source    : out STD_LOGIC_VECTOR( source_width-1 downto 0 )
    );
end issp_InOut;
--
--------------------------------------------------------------------------------------------------- architectur
-- 
architecture SYN of issp_InOut is

    signal sub_wire0 : STD_LOGIC_VECTOR (source_width-1 downto 0) := (others => '0');

    component  altsource_probe
        generic(
            lpm_hint                : string    :=  "UNUSED";
            sld_instance_index      : natural   :=  0;
            source_initial_value    : string    :=  source_init;
            sld_ir_width            : natural   :=  4;
            probe_width             : natural   :=  probe_width;
            source_width            : natural   :=  source_width;
            instance_id             : string    :=  "UNUSED";
            lpm_type                : string    :=  "altsource_probe";
            sld_auto_instance_index : string    :=  "YES";
            SLD_NODE_INFO           : natural   :=  4746752;
            enable_metastability    : string    :=  "NO"
        );
        port(
            source_clk : in  std_logic := '0';
            probe      : in  std_logic_vector(probe_width-1 downto 0)  := (others => '0');
            source     : out  std_logic_vector(source_width-1 downto 0);
            source_ena : in  std_logic := '1'
        );
    end component altsource_probe;


    constant source_initial : std_logic_vector(source_width-1 downto 0) := (others => '0');

begin


    U_SIM : if bModelSim = TRUE generate
    -- There is no simulation model for the source. This means during simulation
    -- the values oft the sources aren't well defined. Therefore - when we simulate -
    -- we set the source value to a fix vector.

        sub_wire0(source_width-1 downto 0) <= (others => '0');

    end generate;

    U_NoSIM : if bModelSim = FALSE generate

        altsource_probe_component : altsource_probe
        generic map (
            enable_metastability => "NO",
            instance_id          => instance_id,
            probe_width          => probe_width,
            source_width         => source_width,
            lpm_type             => "altsource_probe"
        )
        port map (
            source_clk => i_sl_source_clk,
            probe      => i_slv_probe,
            source     => sub_wire0,
            source_ena => '1'
        );


    end generate;


    o_slv_source <= sub_wire0;


end SYN;
