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
--+++ synch len = 3
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;


package mono_on_spiborder_pkg is
    COMPONENT mono_on_spiborder
    PORT
    (
    i_SpiClock      : in  STD_LOGIC;--
    i_SystemClock   : in  STD_LOGIC;--
    i_Input         : in  STD_LOGIC;--
    i_Reset         : in  STD_LOGIC;--
    o_Output        : out STD_LOGIC     --
    );
    END COMPONENT;    
end mono_on_spiborder_pkg;
    
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
Library work;           
    use work.srflipflop_pkg.all;
    use work.deflipflop_pkg.all;
    use work.monoshot_pkg.all;



 entity mono_on_spiborder is
port
(
    i_SpiClock    : in  STD_LOGIC;--
    i_SystemClock   : in  STD_LOGIC;--
    i_Input         : in  STD_LOGIC;--
    i_Reset         : in  STD_LOGIC;--
    o_Output        : out STD_LOGIC     --
);
end mono_on_spiborder;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture rtl of mono_on_spiborder is

BEGIN
U_mono : monoshot
port map
(
    isl_clk50Mhz        => i_SystemClock,--: in std_logic; --! master clock 50 MHz
    isl_rst             => i_Reset,--: in std_logic; --! master reset active high
    isl_input           => i_Input,--: in std_logic; --!
    osl_outputMono      => o_Output--: out std_logic --! pwm output
);
    
------------------------------------------------------------------
END rtl;
