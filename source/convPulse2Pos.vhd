----------------------------------------------------------------------
--! @file .vhd  
--! @brief converter pulse to position-modulo
--!
--! input: puls and direction 
--! outputs: position (modulo 64) // four full steps with 16 microsteps/step
--!
--! @author Jan Debiec
--! @date 13.05.2015
--! @version 0.3 
--! 
-- note 
--! @todo test
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
--
--!
package convPulse2Pos_pkg is
    component convPulse2Pos 
    generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
    );
    port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_direction		: in std_logic;
		isl_pulse			: in std_logic;
		oslv6_OutputValue  	: out std_logic_vector (5 downto 0)--! 
    );        
    end component convPulse2Pos;
            
end package convPulse2Pos_pkg;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library work;           
	use work.pulse_generator_pkg.all;
	use work.integrator_pkg.all;
    use work.modulo_divider_pkg.all;
 
--!
entity convPulse2Pos is
    generic(
 		bISSP     : boolean := TRUE;
        bModelSim : boolean := FALSE
    );
	port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_direction		: in std_logic;
		isl_pulse			: in std_logic;
		oslv6_OutputValue  	: out std_logic_vector (5 downto 0)--! 
	);
end entity convPulse2Pos;

--!
architecture RTL of convPulse2Pos is

-- integrator
	signal n32_OutPosition : signed (31 downto 0);
	signal n32_InPosition : signed (31 downto 0);

-- modulo divider
	constant cu8_ModuloValue : unsigned(7 downto 0) := x"40";
	signal slv6_OutputValue : std_logic_vector(5 downto 0);
	signal slv8_OutputValue : std_logic_vector(7 downto 0);
	
	
begin
n32_InPosition <= n32_OutPosition;
oslv6_OutputValue <= slv8_OutputValue(5 downto 0);

--!
U_INTEGRATOR : integrator
port map (
	isl_clk50Mhz 		=> isl_clk50Mhz,--: in std_logic;
	isl_rst 			=> isl_rst,--: in std_logic;
	isl_direction 		=> isl_direction,--: in std_logic;
	isl_Pulse 			=> isl_pulse,--: in std_logic;
	on32_Position 		=> n32_OutPosition--: out signed(31 downto 0)
);

--!
U_MODULO_DIVIDER : modulo_divider
port map (
	isl_clk50Mhz 		=> isl_clk50Mhz,--: in std_logic;
	in32_inputPosition 	=> n32_InPosition,--: in std_logic_vector(31 downto 0);
	iu8_ModuloValue 	=> cu8_ModuloValue,--: in std_logic_vector(7 downto 0);
	oslv8_OutputValue 	=> slv8_OutputValue--: out std_logic_vector(5 downto 0)
	
);
end architecture RTL;
