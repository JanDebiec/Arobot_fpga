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
                      --  use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
--
package pwm_single_pkg is
    component pwm_single 
    port (
		isl_clk50Mhz 	: in std_logic;
		isl_rst 		: in std_logic;
		isl_InputSync	: in std_logic;
		iu16_loopCounter : in unsigned (15 DOWNTO 0);
		islv16_input	: in std_logic_vector(15 downto 0);
		osl_output		: out std_logic
    );        
    end component pwm_single;
            
end package pwm_single_pkg;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_single is
	port (
		isl_clk50Mhz 	: in std_logic;
		isl_rst 		: in std_logic;
		isl_InputSync	: in std_logic;
		iu16_loopCounter : in unsigned (15 DOWNTO 0);
		islv16_input	: in std_logic_vector(15 downto 0);
		osl_output		: out std_logic
	);
end entity pwm_single;

architecture RTL of pwm_single is
	type sm_PwmSM_Type is (
		st_Idle,
		st_On,
		st_Off
	);
signal smPwm_cs, smPwm_ns : 	sm_PwmSM_Type;
signal slv16_inputShadow	: std_logic_vector(15 downto 0);
	
begin


osl_output <= '1' when (smPwm_cs = st_On) else '0';

p_Shadow_proc : process (
	isl_InputSync,
	slv16_inputShadow,
	islv16_input
	
)
begin
	if (rising_edge(isl_InputSync)) then
		slv16_inputShadow <= islv16_input;
	else
		slv16_inputShadow <= slv16_inputShadow;
	end if;	
end	process;

P_PwmComb_proc : process (
	smPwm_cs,
	slv16_inputShadow,
	isl_InputSync,
	iu16_loopCounter,
	islv16_input
)
begin
	case smPwm_cs is
		when st_Idle =>
			if (isl_InputSync = '1') then
				if(islv16_input = x"0000") then
					smPwm_ns <= st_Off;
				else	
					smPwm_ns <= st_On;
				end if;	
			else	
				smPwm_ns <= st_Off;
			end if;
		when st_On =>
			if(iu16_loopCounter >= unsigned(slv16_inputShadow)) then
				smPwm_ns <= st_Off;
			else	
				smPwm_ns <= st_On;
			end if;	
		when st_Off =>
			if (isl_InputSync = '1') then
				if(islv16_input = x"0000") then
					smPwm_ns <= st_Off;
				else	
					smPwm_ns <= st_On;
				end if;	
			else	
				smPwm_ns <= st_Off;
			end if;
		when others =>
					smPwm_ns <= st_Idle;
	end case;		
end process;

P_PwmSeq_proc : process (
		isl_clk50Mhz,
		isl_rst 	
)
begin
    if (isl_rst = '1') then
        smPwm_cs <= st_Idle;
    elsif (rising_edge(isl_clk50Mhz)) then
    	smPwm_cs <= smPwm_ns;
    END IF;
end process;
	
end architecture RTL;
