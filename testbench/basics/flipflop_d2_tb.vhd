library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all; 
library work;
use work.flipflop_dn_pkg.all;

entity flipflop_d2_tb is
end entity flipflop_d2_tb;

architecture behave of flipflop_d2_tb is
	signal sl_clk    : std_logic := '0';
	signal slv2_d    : std_logic_vector(1 downto 0) := "00";
	signal sl_ena  : std_logic := '0';
	signal sl_rst    : std_logic := '0';
	signal slv2_Output : std_logic_vector(1 downto 0) := "00";
	signal b_check : boolean := false; 
	shared variable 	sv_slCheckValue : std_logic_vector(1 downto 0);

begin

P_STIMUL: process
procedure checkState (constant eValue : std_logic_vector(1 downto 0)) is
	begin
		sv_slCheckValue := eValue;
		b_check <= true;
		wait for (5ns);
		b_check <= false;
	end;	
 begin
    --do nothing
    wait for 300 ns;
	checkState("00");

    wait for 300 ns;
    wait until rising_edge(sl_clk);
       slv2_d <= "11";  
    wait until rising_edge(sl_clk);
	checkState("00");
       slv2_d <= "00";
     wait for 100 ns;
	checkState("00");

    wait for 300 ns;
    wait until rising_edge(sl_clk);
		sl_ena <= '1';
    wait until rising_edge(sl_clk);
       slv2_d <= "11";  
    wait until rising_edge(sl_clk);
	checkState("11");
       slv2_d <= "00";
     wait for 100 ns;
	checkState("00");
         
    wait;
end process;

P_monitor : process(b_check)
	variable l : line;
begin
	if b_check = true then
		if slv2_Output /= sv_slCheckValue then
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


U_DUT : flipflop_dn
generic map( WIDTH => 2)
	port map(
		sl_clk,
		slv2_d,
		sl_ena,
		sl_rst,
		slv2_Output
	);

sl_clk <= not sl_clk after 10 ns;

end architecture behave;
