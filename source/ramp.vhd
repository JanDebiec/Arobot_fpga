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
-- ramp limiter for input.
-- sliceTime, ca 100 ms, in that time velocity is constant
-- in the next slice, v[i+1] is clipped to v[i] +/- rampValue
-- input 16 bits: signed 1 bit sign, 15 value
-- for easy of calculation, i set that input + ramp will be never bigger as 16 bits
Library ieee;           use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	
--
package ramp_pkg is
    component ramp 
    port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_sliceTick : in std_logic;
		in16_inputVector : in signed (15 downto 0);
		in16_rampValue  : in signed (15 downto 0);
		on16_outValue : out signed (15 downto 0)
    );        
    end component ramp;
            
end package ramp_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	

entity ramp is
	port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_sliceTick : in std_logic;
		in16_inputVector : in signed (15 downto 0);
		in16_rampValue  : in signed (15 downto 0);
		on16_outValue : out signed (15 downto 0)
	);
end entity ramp;

architecture RTL of ramp is

-- actual command from input	
--signal sl_sign : std_logic;
signal n16_inputVector : signed (15 downto 0);
-- actual last output value
signal n16_outValue : signed (15 downto 0) := x"0000";

-- accOutValue +/- ramp
signal n16_inputLimitPlus : signed (15 downto 0);
signal n16_inputLimitMinus : signed (15 downto 0);
-- calculated result for next slice
signal n16_inputNext : signed (15 downto 0);
-- merker for tagret velocity, is now is clipped
-- will be actualized with every new input
signal n16_inputTarget : signed (15 downto 0);
			
begin

n16_inputVector <= in16_inputVector;

n16_inputLimitPlus <= n16_outValue + in16_rampValue;
n16_inputLimitMinus <= n16_outValue - in16_rampValue;
on16_outValue  <= n16_outValue;	
	
rampProcess : process(
	n16_inputVector,
	isl_sliceTick
)	is
variable vn16_inputNext : signed (15 downto 0);
variable vn16_inputTarget : signed (15 downto 0);
begin
	if(n16_inputVector > n16_inputLimitPlus) then
		vn16_inputNext := n16_inputLimitPlus;
		vn16_inputTarget := n16_inputVector;
	elsif(n16_inputVector < n16_inputLimitMinus) then
		vn16_inputNext := n16_inputLimitMinus;
		vn16_inputTarget := n16_inputVector;
	else
		vn16_inputNext := n16_inputVector;
		vn16_inputTarget := n16_inputVector;
	end if;	
	n16_inputNext <= vn16_inputNext;
	n16_inputTarget <= vn16_inputTarget;
end process;	

rampProcessSM : process(
	isl_sliceTick
)	is
begin
    if (isl_rst = '1') then
        n16_outValue <= x"0000";
    elsif (rising_edge(isl_sliceTick)) then
    	n16_outValue <= n16_inputNext;
    END IF;
END PROCESS;

end architecture RTL;
