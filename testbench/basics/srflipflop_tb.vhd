library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all; 
library work;
use work.srflipflop_pkg.all;

entity srflipflop_tb is
end entity srflipflop_tb;

architecture behave of srflipflop_tb is
	signal sl_clk    : std_logic := '0';
	signal sl_Set    : std_logic := '0';
	signal sl_Reset  : std_logic := '0';
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
		wait for (100ns);
		b_check <= false;
	end;	
 begin
    --do nothing
    wait for 300 ns;
	checkState('0');

    wait for 300 ns;
    wait until rising_edge(sl_clk);
       sl_Set <= '1';  
    wait until rising_edge(sl_clk);
       sl_Set <= '0';
     wait for 100 ns;
	checkState('1');

    wait for 300 ns;
    wait until rising_edge(sl_clk);
       sl_Reset <= '1';  
    wait until rising_edge(sl_clk);
       sl_Reset <= '0';
     wait for 100 ns;
	checkState('0');

    wait for 300 ns;
    wait until rising_edge(sl_clk);
       sl_Reset <= '1';  
    wait until rising_edge(sl_clk);
       sl_Reset <= '0';
     wait for 100 ns;
	checkState('0');

    wait for 300 ns;
    wait until rising_edge(sl_clk);
       sl_Set <= '1';  
    wait until rising_edge(sl_clk);
       sl_Set <= '0';
     wait for 100 ns;
	checkState('1');

    wait for 300 ns;
    wait until rising_edge(sl_clk);
       sl_Set <= '1';  
    wait until rising_edge(sl_clk);
       sl_Set <= '0';
     wait for 100 ns;
	checkState('1');

         
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


U_DUT : srflipflop
	port map(
		sl_clk,
		sl_Set,
		sl_Reset,
		sl_rst,
		sl_Output
	);

sl_clk <= not sl_clk after 10 ns;

end architecture behave;
