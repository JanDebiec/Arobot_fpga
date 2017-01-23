----------------------------------------------------------------------
--! @file  
--! @brief 
--!
--!
--! @author 
--! @date 
--! @version  
--! 
--! note 
--! @todo 
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.numeric_std.all;
--
package modulo_divider_pkg is
    component modulo_divider 
    port (
		isl_clk50Mhz : in std_logic;
		in32_inputPosition : in signed(31 downto 0);
		iu8_ModuloValue : in unsigned(7 downto 0);
		oslv8_OutputValue : out std_logic_vector(7 downto 0)
    );        
    end component modulo_divider;
            
end package modulo_divider_pkg;


library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	
	use work.arobot_component_pkg.all;	

entity modulo_divider is
	port (
		isl_clk50Mhz : in std_logic;
		in32_inputPosition : in signed(31 downto 0);
		iu8_ModuloValue : in unsigned(7 downto 0);
		oslv8_OutputValue : out std_logic_vector(7 downto 0)
	);
end entity modulo_divider;

architecture RTL of modulo_divider is
	signal slv8_ModuloValue : std_logic_vector(7 downto 0);
	signal 	slv32_inputPosition : std_logic_vector(31 downto 0);
	signal 	slv8_ModuloOutput : std_logic_vector(7 downto 0);
begin

oslv8_OutputValue <= slv8_ModuloOutput;
slv32_inputPosition <= std_logic_vector(in32_inputPosition);
slv8_ModuloValue<= std_logic_vector(iu8_ModuloValue);

U_modulo : n32_modulo_u8
		port map(
		clock		=> isl_clk50Mhz,--,: IN STD_LOGIC ;
		denom		=> slv8_ModuloValue,--: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		numer		=> slv32_inputPosition,--: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		quotient	=> open,--: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		remain		=> slv8_ModuloOutput--: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);

end architecture RTL;
