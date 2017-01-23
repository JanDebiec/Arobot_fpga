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
-- default settings:
-- pwm period 20 kHz,
-- input real resolution 12 bits
-- pwm pulse period: clock period, 50 MHz
Library ieee;           use ieee.std_logic_1164.all;
                        --use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
--
package pwm_pulse_pkg is
    component pwm_pulse 
	generic (pwm_cycle_time_pulses : integer := 2500); -- for F = 20 kHz 
    port (
		isl_clk50Mhz 	: in std_logic;
		isl_rst 		: in std_logic;
		osl_PwmPeriodPulse 		: out std_logic;
		ou16_loopCounter : out integer
    );        
    end component pwm_pulse;
            
end package pwm_pulse_pkg;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_pulse is
	generic (pwm_cycle_time_pulses : integer := 2500); -- for F = 20 kHz 
	port (
		isl_clk50Mhz 	: in std_logic;
		isl_rst 		: in std_logic;
		osl_PwmPeriodPulse 		: out std_logic;
		ou16_loopCounter : out integer
	);
end entity pwm_pulse;

architecture RTL of pwm_pulse is
	signal u16_loopCounter : integer;
	constant cu16_loopCounter : unsigned (15 DOWNTO 0) := to_unsigned(pwm_cycle_time_pulses, 16);
begin
	ou16_loopCounter <= u16_loopCounter;
	
	osl_PwmPeriodPulse <= '1' when (u16_loopCounter = 0) else
						'0';
	 
P_Generator_loop_proc : process (
	isl_clk50Mhz,
	isl_rst,
	u16_loopCounter
) is
begin
	if (isl_rst = '1') then
		u16_loopCounter <= 0;
	else	
		if(rising_edge(isl_clk50Mhz)) then
			if(u16_loopCounter >= cu16_loopCounter) then
				u16_loopCounter <= 0;
			else
				u16_loopCounter <= u16_loopCounter + 1;
			end if;		
		end if;
	end if;	
end process;	
	
end architecture RTL;
	