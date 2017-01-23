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
-- lut table for 16 values
-- will be used for setting 64 microsteps for 4 full steps
Library ieee;           use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
library work;
	use work.arobot_constant_pkg.all;	
--
package micro_lut_pkg is
    component micro_lut 
    port (
		isl_clk50Mhz : in std_logic;
		islv_index : in std_logic_vector(4 downto 0);
		oslv_value : out std_logic_vector(15 downto 0)
    );        
    end component micro_lut;
            
end package micro_lut_pkg;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	

entity micro_lut is
	port (
		isl_clk50Mhz : in std_logic;
		islv_index : in std_logic_vector(4 downto 0);
		oslv_value : out std_logic_vector(15 downto 0)
		
	);
end entity micro_lut;

architecture RTL of micro_lut is
type micro_lut is array (16 downto 0) of std_logic_vector(15 downto 0);
signal slva_microLut : micro_lut;	
signal slv16_value : std_logic_vector(15 downto 0);
begin
	oslv_value <= slv16_value;
	slva_microLut(0) <= x"0000";
	slva_microLut(1) <= x"0C8B";
	slva_microLut(2) <= x"18F8";
	slva_microLut(3) <= x"2528";
	slva_microLut(4) <= x"30FB";
	slva_microLut(5) <= x"3C56";
	slva_microLut(6) <= x"471C";
	slva_microLut(7) <= x"5133";
	slva_microLut(8) <= x"5A82";
	slva_microLut(9) <= x"62F2";
	slva_microLut(10) <= x"6A6D";
	slva_microLut(11) <= x"70E2";
	slva_microLut(12) <= x"7641";
	slva_microLut(13) <= x"7A7D";
	slva_microLut(14) <= x"7D8A";
	slva_microLut(15) <= x"7F62";
	slva_microLut(16) <= x"8000";
	
LutOutput : process (
	isl_clk50Mhz
) is
variable vslv16_value : std_logic_vector(15 downto 0);
variable vnIndex : integer;
variable vValue : std_logic_vector(15 downto 0);
begin
	if((isl_clk50Mhz = '1') and isl_clk50Mhz'event)	then
		vnIndex := to_integer(unsigned(islv_index));
		vValue := slva_microLut(vnIndex);
		
		slv16_value <= vValue;
	end if;
	end process;


end architecture RTL;

