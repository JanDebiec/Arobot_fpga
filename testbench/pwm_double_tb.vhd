Library ieee;           use ieee.std_logic_1164.all;
                        --use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

Library work;           
                        use work.pwm_double_pkg.all;
entity pwm_double_TB is
end pwm_double_TB;

architecture behave of pwm_double_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_InputSync : std_logic := '0';
	signal n_loopCounter : integer;
	signal slv16_inputA	: std_logic_vector(15 downto 0) := x"0055";
	signal slv16_inputB	: std_logic_vector(15 downto 0) := x"000a";
	signal sl_outputA		:  std_logic;
	signal sl_outputB		:  std_logic;
constant pwm_cycle_time_pulses : integer := 250;
constant cu16_loopCounter : unsigned (15 DOWNTO 0) := to_unsigned(pwm_cycle_time_pulses, 16);
begin	

sl_InputSync <= '1' when (n_loopCounter = 0) else '0';

U_DUT : pwm_double
GENERIC MAP(pwm_cycle_time_pulses => 100)
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		isl_rst => sl_Reset,--: in std_logic;
		islv16_inputA	=> slv16_inputA ,--: in std_logic_vector(15 downto 0);
		islv16_inputB	=> slv16_inputB ,--: in std_logic_vector(15 downto 0);
		iu16_loopCounter => n_loopCounter,--: in integer;
		isl_InputSync	=> sl_InputSync,--: in std_logic;
		osl_outputA		=> sl_outputA ,--: out std_logic;
		osl_outputB		=> sl_outputB --: out std_logic
          
);

-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;
 
 P_INPUT_proc: process
 begin
 	slv16_inputA <= x"0000";
 	wait for 1000 ns;
 	
 	slv16_inputA <= x"0010";
 	wait for 1000 ns;

 	slv16_inputA <= x"0100";
 	wait for 1000 ns;

 	slv16_inputA <= x"0022";
 	
	wait; 	
end process;
    
Generator_loop_proc : process (
	sl_clk50Mhz,
	n_loopCounter
) is
begin
	if(rising_edge(sl_clk50Mhz)) then
		if(n_loopCounter = cu16_loopCounter) then
			n_loopCounter <= 0;
		else
			n_loopCounter <= n_loopCounter + 1;
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