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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_generator is
	port (
		isl_clk50Mhz 		: in std_logic;
		isl_rst 			: in std_logic;
		in32_inputPosition 	: in signed(31 downto 0);
		iu8_ModuloValue 	: in unsigned(7 downto 0);
		islv_inputStep 		: in  STD_LOGIC_VECTOR(7 DOWNTO 0);
		islv_period 		: in STD_LOGIC_VECTOR(31 DOWNTO 0);
		osl_pwmAL 			: out std_logic;
		osl_pwmAR 			: out std_logic;
		osl_pwmBL 			: out std_logic;
		osl_pwmBR 			: out std_logic
	);
end entity pwm_generator;

architecture RTL of pwm_generator is
	
begin

U_MOD_DIVIDER : modulo_divider 
	port map(
		isl_clk50Mhz => isl_clk50Mhz,--: in std_logic;
	);

U_SINUS_CALC : sinus_calc 
	port map (
		isl_clk50Mhz 		: in std_logic;
		islv8_InputIndex 	: in std_logic_vector(7 downto 0);
		iu8_microResProStep : in unsigned(7 downto 0);
		oslv16_sinusLeft	: out std_logic_vector(15 downto 0);
		oslv16_sinusRight	: out std_logic_vector(15 downto 0);
		oslv16_cosinusLeft	: out std_logic_vector(15 downto 0);
		oslv16_cosinusRight	: out std_logic_vector(15 downto 0);
		oslv16_sinus 		: out std_logic_vector(15 downto 0)
    );        

U_PWM_A1
U_PWM_A2
U_PWM_B1
U_PWM_B2

end architecture RTL;
