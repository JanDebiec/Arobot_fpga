library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all; 
library work;
    use work.msystem_typedef_pkg.all;
    use work.msystem_stim_tcc_pkg.all;
    use work.msystem_stim_fp_pkg.all;
use work.flipflop_d1_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity flipflop_d1_tb is
  generic (runner_cfg : string := "");
end entity flipflop_d1_tb;

architecture behave of flipflop_d1_tb is
	signal sl_clk    : std_logic := '0';
	signal sl_d    : std_logic := '0';
	signal sl_ena  : std_logic := '0';
	signal sl_rst    : std_logic := '0';
	signal sl_Output : std_logic := '0';
	signal b_check : boolean := false; 
	shared variable 	sv_slCheckValue : std_logic;

begin

P_STIMUL: process
procedure checkState (constant eValue : std_logic) is
	begin
		sv_slCheckValue := eValue;
		b_check <= true;
		wait for (5ns);
		b_check <= false;
	end;	
 begin
    test_runner_setup(runner, runner_cfg);
    --do nothing
    wait for 300 ns;
	checkState('0');
    check(checkSL(sl_Output,'0'), "Output Q should 0");

    wait for 300 ns;
    wait until rising_edge(sl_clk);
       sl_d <= '1';  
    wait until rising_edge(sl_clk);
	checkState('0');
    check(checkSL(sl_Output,'0'), "Output Q should 0");
       sl_d <= '0';
     wait for 100 ns;
	checkState('0');
    check(checkSL(sl_Output,'0'), "Output Q should 0");

    wait for 300 ns;
    wait until rising_edge(sl_clk);
		sl_ena <= '1';
    wait until rising_edge(sl_clk);
       sl_d <= '1';  
    wait until rising_edge(sl_clk);
	checkState('1');
    check(checkSL(sl_Output,'1'), "Output Q should 1");
       sl_d <= '0';
     wait for 100 ns;
	checkState('0');
    check(checkSL(sl_Output,'0'), "Output Q should 0");

    test_runner_cleanup(runner); -- Simulation ends here
         
    wait;
end process;

P_monitor : process(b_check)
	variable l : line;
begin
	if b_check = true then
		if sl_Output /= sv_slCheckValue then
			assert false
				report "state is not correct"
			severity warning;
			write(l, string'("***************************"));	
			writeline(output,l);
			write(l, string'("    failure    "));	
			writeline(output,l);
			write(l, string'("***************************"));	
			writeline(output,l);
		else
			assert false
				report "state is correct"
			severity warning;	
		end if;	
	end if;	
end process;	

U_RESET : process
begin
	sl_rst <= '0';
	wait for 10 ns;
	sl_rst <= '1';
	wait for 10 ns;
	sl_rst <= '0';
	wait for 10 ns;
	wait;
end process;


U_DUT : flipflop_d1
generic map( WIDTH => 1)
	port map(
		sl_clk,
		sl_d,
		sl_ena,
		sl_rst,
		sl_Output
	);

sl_clk <= not sl_clk after 10 ns;

end architecture behave;
