Library ieee;           use ieee.std_logic_1164.all;
                        --use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
                        use work.pwm_single_pkg.all;
entity pwm_single_TB is
end pwm_single_TB;

architecture behave of pwm_single_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_InputSync : std_logic := '0';
	signal u16_loopCounter : unsigned (15 DOWNTO 0) := x"00aa";
	signal slv16_input	: std_logic_vector(15 downto 0);
	signal sl_output		:  std_logic;
constant pwm_cycle_time_pulses : integer := 250;
constant cu16_loopCounter : unsigned (15 DOWNTO 0) := to_unsigned(pwm_cycle_time_pulses, 16);
begin	

sl_InputSync <= '1' when (u16_loopCounter = x"0000") else '0';

U_DUT : pwm_single
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		isl_InputSync	=> sl_InputSync,--: in std_logic;
		iu16_loopCounter => u16_loopCounter,--: in unsigned (15 DOWNTO 0);
		islv16_input	=> slv16_input,--: in std_logic_vector(15 downto 0);
		osl_output		=> sl_output--: out std_logic
          
);

-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;
 
 P_INPUT_proc: process
 begin
 	slv16_input <= x"0000";
 	wait for 1000 ns;
 	
 	slv16_input <= x"0010";
 	wait for 1000 ns;

 	slv16_input <= x"0100";
 	wait for 1000 ns;

 	slv16_input <= x"0022";
 	
	wait; 	
end process;
    
P_Generator_loop_proc : process (
	sl_clk50Mhz,
	u16_loopCounter
) is
begin
	if(rising_edge(sl_clk50Mhz)) then
		if(u16_loopCounter = cu16_loopCounter) then
			u16_loopCounter <= x"0000";
		else
			u16_loopCounter <= u16_loopCounter + '1';
		end if;		
	end if;	
end process;	
        
P_RESET_proc: process
begin
	sl_Reset <= '0';

    wait for 100 ns;
	sl_Reset <= '1';
	
    wait for 100 ns;

	sl_Reset <= '0';

    wait;
end process;

end  behave;