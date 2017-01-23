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
-- default settings:
-- pwm period 20 kHz,
-- input real resolution 12 bits
-- pwm pulse period: clock period, 50 MHz
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.numeric_std.all;
--
package pwm_double_pkg is
    component pwm_double 
	generic (pwm_cycle_time_pulses : integer := 2500); -- for F = 20 kHz 
    port (
		isl_clk50Mhz 	: in std_logic;
		isl_rst 		: in std_logic;
		islv16_inputA	: in std_logic_vector(15 downto 0);
		islv16_inputB	: in std_logic_vector(15 downto 0);
		iu16_loopCounter : in integer;
		isl_InputSync	: in std_logic;
		osl_outputA		: out std_logic;
		osl_outputB		: out std_logic
    );        
    end component pwm_double;
            
end package pwm_double_pkg;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library work;           
    use work.pwm_single_pkg.all;

entity pwm_double is
	generic (pwm_cycle_time_pulses : integer := 2500); -- for F = 20 kHz 
	port (
		isl_clk50Mhz 	: in std_logic;
		isl_rst 		: in std_logic;
		islv16_inputA	: in std_logic_vector(15 downto 0);
		islv16_inputB	: in std_logic_vector(15 downto 0);
		iu16_loopCounter : in integer;
		isl_InputSync	: in std_logic;
		osl_outputA		: out std_logic;
		osl_outputB		: out std_logic
	);
end entity pwm_double;

architecture RTL of pwm_double is
signal sl_InputSync 	: STD_LOGIC;
--signal u16_loopCounter : unsigned (15 DOWNTO 0);
signal u16_loopCounter : integer;
constant cu16_loopCounter : unsigned (15 DOWNTO 0) := to_unsigned(pwm_cycle_time_pulses, 16);
	
begin

sl_InputSync <= isl_InputSync;
u16_loopCounter <= iu16_loopCounter;

U_pwm1 : pwm_single
port map (
		isl_clk50Mhz 	 => isl_clk50Mhz ,--: in std_logic;
		isl_rst 		 => isl_rst ,--: in std_logic;
		isl_InputSync	 => sl_InputSync ,--: in std_logic;
		iu16_loopCounter => to_unsigned(u16_loopCounter,16) ,-- : in unsigned (15 DOWNTO 0);
		islv16_input	 => islv16_inputA ,--: in std_logic_vector(15 downto 0);
		osl_output		 => osl_outputA --: out std_logic
	
);	

U_pwm2 : pwm_single
port map (
		isl_clk50Mhz 	 => isl_clk50Mhz ,--: in std_logic;
		isl_rst 		 => isl_rst ,--: in std_logic;
		isl_InputSync	 => sl_InputSync ,--: in std_logic;
		iu16_loopCounter => to_unsigned(u16_loopCounter,16 ),-- : in unsigned (15 DOWNTO 0);
		islv16_input	 => islv16_inputB ,--: in std_logic_vector(15 downto 0);
		osl_output		 => osl_outputB --: out std_logic
	
);	

end architecture RTL;
