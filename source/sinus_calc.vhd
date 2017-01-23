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
Library ieee;           
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	
--
package sinus_calc_pkg is
    component sinus_calc 
	port (
		isl_clk50Mhz 		: in std_logic;
		islv6_InputIndex 	: in std_logic_vector(5 downto 0);
		iu8_microResProStep : in signed(7 downto 0);
		oslv16_sinusLeft	: out std_logic_vector(15 downto 0);
		oslv16_sinusRight	: out std_logic_vector(15 downto 0);
		oslv16_cosinusLeft	: out std_logic_vector(15 downto 0);
		oslv16_cosinusRight	: out std_logic_vector(15 downto 0);
		oslv16_sinus 		: out std_logic_vector(15 downto 0)
    );        
    end component sinus_calc;
            
end package sinus_calc_pkg;

library ieee;
use ieee.std_logic_1164.all;
	--use ieee.numeric_std.all;
	--use ieee.std_logic_arith.all;
	use ieee.numeric_std.all;

library work;
	use work.arobot_constant_pkg.all;	
	use work.micro_lut_pkg.all;

entity sinus_calc is
	port (
		isl_clk50Mhz 		: in std_logic;
		islv6_InputIndex 	: in std_logic_vector(5 downto 0);-- only 6 will be used, max 63
		iu8_microResProStep : in signed(7 downto 0);
		oslv16_sinusLeft	: out std_logic_vector(15 downto 0);
		oslv16_sinusRight	: out std_logic_vector(15 downto 0);
		oslv16_cosinusLeft	: out std_logic_vector(15 downto 0);
		oslv16_cosinusRight	: out std_logic_vector(15 downto 0);
		
		oslv16_sinus 		: out std_logic_vector(15 downto 0)
	);
end entity sinus_calc;


architecture RTL of sinus_calc is
	signal slv6_index : std_logic_vector(5 downto 0);
	signal slv6_indexMicroCorrected : std_logic_vector(5 downto 0);
	signal slv6_indexMicroCorrectedDel : std_logic_vector(5 downto 0);
	signal uLutS_slv16_sinus 		: std_logic_vector(15 downto 0);
	signal uLutC_slv16_cosinus 		: std_logic_vector(15 downto 0);
	constant slv16_valueZero	: std_logic_vector(15 downto 0) := x"0000";


	
	signal slv_index : std_logic_vector(4 downto 0);
	signal slv5_TableIndexSinus : std_logic_vector(4 downto 0);
	signal slv5_TableIndexCosinus : std_logic_vector(4 downto 0);
	signal u6_TableIndexReversed : signed(5 downto 0);
	signal u6_TableIndexReversedCos : signed(5 downto 0);
	signal u6_TableIndexSecondQCos : signed(5 downto 0);
	
	constant cu5_16 : signed(4 downto 0) := "10000";
	constant cu6_16 : signed(5 downto 0) := "010000";
	constant cu6_15 : signed(5 downto 0) := "001111";
	constant cu6_32 : signed(5 downto 0) := "100000";
	constant cu8_1 :  signed(7 downto 0) := x"01";
	constant cu8_2 :  signed(7 downto 0) := x"02";
	constant cu8_4 :  signed(7 downto 0) := x"04";
	constant cu8_8 :  signed(7 downto 0) := x"08";
	constant cu8_16 :  signed(7 downto 0) := x"10";
	
	signal u5_index : signed(4 downto 0);
	signal u6_index : signed(5 downto 0);
	signal u5_TableIndex : signed(4 downto 0);
begin

P_IndexDel : process (
	isl_clk50Mhz
)
begin
	if((isl_clk50Mhz = '1') and isl_clk50Mhz'event) then
		slv6_indexMicroCorrectedDel <= slv6_indexMicroCorrected;
	end if;	
end process;	

oslv16_sinus <= uLutS_slv16_sinus;
oslv16_sinusLeft <= uLutS_slv16_sinus when (slv6_indexMicroCorrectedDel(5) = '0') else
					slv16_valueZero;
oslv16_sinusRight <= uLutS_slv16_sinus when (slv6_indexMicroCorrectedDel(5) = '1') else
					slv16_valueZero;

oslv16_cosinusLeft <= uLutC_slv16_cosinus when (slv6_indexMicroCorrectedDel(5 downto 4) = "00") else
					uLutC_slv16_cosinus when (slv6_indexMicroCorrectedDel(5 downto 4) = "11") else
					slv16_valueZero;
oslv16_cosinusRight <= uLutC_slv16_cosinus when (slv6_indexMicroCorrectedDel(5 downto 4) = "01") else
					uLutC_slv16_cosinus when (slv6_indexMicroCorrectedDel(5 downto 4) = "10") else
					slv16_valueZero;

slv6_index <= islv6_InputIndex(5 downto 0);
slv6_indexMicroCorrected <=
	slv6_index when (iu8_microResProStep = cu8_16) else
	(slv6_index(4 downto 0) & '0') when (iu8_microResProStep = cu8_8) else
	(slv6_index(3 downto 0) & '0'& '0') when (iu8_microResProStep = cu8_4) else
	(slv6_index(2 downto 0) & '0'& '0'& '0') when (iu8_microResProStep = cu8_2) else
	(slv6_index(1 downto 0) & '0'& '0'& '0' & '0') when (iu8_microResProStep = cu8_1) else
	slv6_index;

u6_index(5) <= '0';
u6_index(4 downto 0) <= signed(slv6_indexMicroCorrected(4 downto 0));

-- now only for 16 micro/full
-- first and theird  part TableIndex = InputIndex,
-- second and fourth part: TableIndex = 16 - InputIndex
u6_TableIndexReversed <= cu6_32 - u6_index;
u6_TableIndexSecondQCos <= u6_index - cu6_16;
u6_TableIndexReversedCos <= u6_TableIndexReversed - cu6_16;

slv5_TableIndexSinus <= std_logic_vector(u6_index(4 downto 0)) when(slv6_indexMicroCorrected(4) = '0') else
				std_logic_vector(u6_TableIndexReversed(4 downto 0));

slv5_TableIndexCosinus <= std_logic_vector(u6_TableIndexReversedCos(4 downto 0)) when(slv6_indexMicroCorrected(4) = '0') else
				std_logic_vector(u6_TableIndexSecondQCos(4 downto 0));

uLutS : micro_lut 
	port map(
		isl_clk50Mhz => isl_clk50Mhz,--: in std_logic;
		islv_index => slv5_TableIndexSinus,--: in std_logic_vector(4 downto 0);
		oslv_value => uLutS_slv16_sinus--: out std_logic_vector(15 downto 0)
	);

uLutC : micro_lut 
	port map(
		isl_clk50Mhz => isl_clk50Mhz,--: in std_logic;
		islv_index => slv5_TableIndexCosinus,--: in std_logic_vector(4 downto 0);
		oslv_value => uLutC_slv16_cosinus--: out std_logic_vector(15 downto 0)
	);

end architecture RTL;
