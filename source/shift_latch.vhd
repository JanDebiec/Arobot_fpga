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
-- a block with shift register, comparator
-- and output registers 
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
--
package shift_latch_pkg is
    component shift_latch 
    port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_inputBitValid : in std_logic;
		isl_bitValue : in std_logic;
		islv8_MagicWord : in std_logic_vector(7 downto 0);
		oslv_shortA : out signed(15 downto 0);
		oslv_shortB : out signed(15 downto 0);
		osl_outputValid : out std_logic
    );        
    end component shift_latch;
            
end package shift_latch_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	
	use work.arobot_component_pkg.all;	

entity shift_latch is
	port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_inputBitValid : in std_logic;
		isl_bitValue : in std_logic;
		islv8_MagicWord : in std_logic_vector(7 downto 0);
		oslv_shortA : out signed(15 downto 0);
		oslv_shortB : out signed(15 downto 0);
		osl_outputValid : out std_logic
	);
end entity shift_latch;

architecture RTL of shift_latch is
	signal slv48_regOutput : std_logic_vector(47 downto 0);
	signal slv16_OutputA : std_logic_vector(15 downto 0);
	signal slv16_OutputB : std_logic_vector(15 downto 0);
	signal slv8_FirstByte :std_logic_vector(7 downto 0);
	signal sl_MagicWordEqual : std_logic;
begin

oslv_shortA <= signed(slv16_OutputA);
oslv_shortB <= signed(slv16_OutputB);

slv8_FirstByte <= slv48_regOutput(47 downto 40);
P_setOutput : process (
	sl_MagicWordEqual
) is
begin
	if(sl_MagicWordEqual = '1') and (rising_edge(sl_MagicWordEqual))then
		slv16_OutputA <= slv48_regOutput(31 downto 16);
		slv16_OutputB <= slv48_regOutput(15 downto 0);
	end if;	
		
end process;	

P_compare : process (
	isl_clk50Mhz
)is
	variable vsl_equal : std_logic;
begin
	vsl_equal := '0';
	if(islv8_MagicWord = slv8_FirstByte) then
		vsl_equal := '1';
	end if;
	sl_MagicWordEqual <= vsl_equal;	
end process;	

U_ShiftReg : shift_reg_48bits
		port map(

		clock		=> isl_clk50Mhz,--,: IN STD_LOGIC ;
		enable		=> isl_inputBitValid,--: IN STD_LOGIC ;
		sclr		=> isl_rst,--: IN STD_LOGIC ;
		shiftin		=> isl_bitValue,--: IN STD_LOGIC ;
		q			=> slv48_regOutput--: OUT STD_LOGIC_VECTOR (47 DOWNTO 0)
	);

end architecture RTL;
