----------------------------------------------------------------------
--! @file convPos2Pwm.vhd  
--! @brief control of one exis of stepper motor
--!
--! input: position (modulo) slv6, 0 .. 63 
--! ustep position in 4 full step area, 
--! outputs: pwms for both phases of stepper
--!
--! @author Jan Debiec
--! @date 13.05.2015
--! @version 0.4 
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
package convPos2Pwm_pkg is
    component convPos2Pwm 
--    generic(
-- 		bISSP     : boolean := TRUE;
--        bModelSim : boolean := FALSE
--    );
    port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		islv6_InputIndex 	: in std_logic_vector(5 downto 0);
		iu16_loopCounter 	: in integer;
		isl_InputSync		: in std_logic;
		iu8_microResProStep : in unsigned(7 downto 0);
		osl_output1A		: out std_logic;--! pwm output
		osl_output1B		: out std_logic;--! pwm output
		osl_output2A		: out std_logic;--! pwm output
		osl_output2B		: out std_logic --! pwm output
    );        
    end component convPos2Pwm;
            
end package convPos2Pwm_pkg;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library work;           
    use work.sinus_calc_pkg.all;
    use work.pwm_double_pkg.all;
    use work.position_issp_pkg.all;
 
--!
entity convPos2Pwm is
	port (
		isl_clk50Mhz 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		islv6_InputIndex 	: in std_logic_vector(5 downto 0);
		iu16_loopCounter 	: in integer;
		isl_InputSync		: in std_logic;
		iu8_microResProStep : in unsigned(7 downto 0);
		osl_output1A		: out std_logic;--! pwm output
		osl_output1B		: out std_logic;--! pwm output
		osl_output2A		: out std_logic;--! pwm output
		osl_output2B		: out std_logic --! pwm output
	);
end entity convPos2Pwm;

--!
architecture RTL of convPos2Pwm is

--	signal n16_outputVector 	: signed (15 downto 0);

--sinus input
--	signal slv6_InputIndex :  std_logic_vector(5 downto 0);
--	signal slv8_InputIndexIssp :  std_logic_vector(7 downto 0) := x"00";
--	signal u8_microResProStep : signed(7 downto 0);
--sinus output
	signal uSinCalc_slv16_sinus : std_logic_vector(15 downto 0);
	signal uSinCalc_slv16_sinusLeft : std_logic_vector(15 downto 0);
	signal uSinCalc_slv16_sinusRight : std_logic_vector(15 downto 0);
	signal uSinCalc_slv16_cosinusLeft : std_logic_vector(15 downto 0);
	signal uSinCalc_slv16_cosinusRight : std_logic_vector(15 downto 0);
	signal slv16_sinusLeft12 : std_logic_vector(15 downto 0);
	signal slv16_sinusRight12 : std_logic_vector(15 downto 0);
	signal slv16_cosinusLeft12 : std_logic_vector(15 downto 0);
	signal slv16_cosinusRight12 : std_logic_vector(15 downto 0);

-- pwm_double input
--	signal u16_loopCounter :  integer;
--	signal sl_InputSync	: std_logic;
	
begin
--	slv6_InputIndex <= islv6_InputIndex;
--u8_microResProStep <= x"10";
--u16_loopCounter <= iu16_loopCounter;
--sl_InputSync <= isl_InputSync;

slv16_sinusLeft12 <= "0000"& uSinCalc_slv16_sinusLeft(15 downto 4);
slv16_sinusRight12 <= "0000"&  uSinCalc_slv16_sinusRight(15 downto 4);
slv16_cosinusLeft12 <= "0000"&  uSinCalc_slv16_cosinusLeft(15 downto 4);
slv16_cosinusRight12 <= "0000"&  uSinCalc_slv16_cosinusRight(15 downto 4);


--!
uSinCalc : sinus_calc
port map (
	isl_clk50Mhz 		=> isl_clk50Mhz,--: in std_logic;
	islv6_InputIndex 	=> islv6_InputIndex,--: in std_logic_vector(7 downto 0);
	iu8_microResProStep => iu8_microResProStep,--: in unsigned(7 downto 0);
	oslv16_sinusLeft	=> uSinCalc_slv16_sinusLeft,--: out std_logic_vector(15 downto 0);
	oslv16_sinusRight	=> uSinCalc_slv16_sinusRight,--: out std_logic_vector(15 downto 0);
	oslv16_cosinusLeft	=> uSinCalc_slv16_cosinusLeft,--: out std_logic_vector(15 downto 0);
	oslv16_cosinusRight	=> uSinCalc_slv16_cosinusRight,--: out std_logic_vector(15 downto 0);
	oslv16_sinus 		=> uSinCalc_slv16_sinus--: out std_logic_vector(15 downto 0)
	
);

--!
uPwmD1 : pwm_double
port map (
	isl_clk50Mhz 	=> isl_clk50Mhz,--: in std_logic;
	isl_rst 		=> isl_rst,--: in std_logic;
	islv16_inputA	=> slv16_sinusLeft12 ,--: in std_logic_vector(15 downto 0);
	islv16_inputB	=> slv16_sinusRight12 ,--: in std_logic_vector(15 downto 0);
	iu16_loopCounter => iu16_loopCounter,--: in integer;
	isl_InputSync	=> isl_InputSync,--: in std_logic;
	osl_outputA		=> osl_output1A ,--: out std_logic;
	osl_outputB		=> osl_output1B --: out std_logic
	
);

--!
uPwmD2 : pwm_double
port map (
	isl_clk50Mhz 	=> isl_clk50Mhz,--: in std_logic;
	isl_rst 		=> isl_rst,--: in std_logic;
	islv16_inputA	=> slv16_cosinusLeft12 ,--: in std_logic_vector(15 downto 0);
	islv16_inputB	=> slv16_cosinusRight12 ,--: in std_logic_vector(15 downto 0);
	iu16_loopCounter => iu16_loopCounter,--: in integer;
	isl_InputSync	=> isl_InputSync,--: in std_logic;
	osl_outputA		=> osl_output2A ,--: out std_logic;
	osl_outputB		=> osl_output2B --: out std_logic
	
);

end architecture RTL;
