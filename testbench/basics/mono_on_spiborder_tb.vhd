Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
	use work.msystem_tcc_pkg.all;
    use work.mono_on_spiborder_pkg.all;
                        
entity mono_on_spiborder_TB is
end mono_on_spiborder_TB;

architecture behave of mono_on_spiborder_TB is
    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal sl_input		: std_logic := '0';
	signal sl_output	: std_logic := '0';
begin	

P_STIMUL: process
 begin
 	--do nothing
 	--wait;
 	
    wait for 100 ns;
--1
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--2
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--3
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--4
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--5
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--6
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--7
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--8
    sl_SpiClk <= '1';
    sl_input <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;



    wait for 200 ns;

--1
    sl_SpiClk <= '1';
    sl_input <= '0';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--2
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--3
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--4
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--5
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--6
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--7
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;

--8
    sl_SpiClk <= '1';
    sl_SpiClk <= '1';
    wait for 20 ns;
    sl_SpiClk <= '0';
    wait for 20 ns;


	wait; 	
end process;

    sl_clk50MHz    <= not sl_clk50MHz after 10 ns;
    --sl_OutputClk    <= not sl_OutputClk after 4 ns;
    U_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 30 ns;
    	sl_Reset <= '1';
    	
        wait for 30 ns;

    	sl_Reset <= '0';

        wait for 30 ns;
			--sl_sliceTick <= '1';
        wait for 100 ns;
        wait;
    end process;

U_DUT : mono_on_spiborder
port map
(
    i_SpiClock    => sl_SpiClk ,--: in  STD_LOGIC;--
    i_SystemClock   => sl_clk50MHz ,--: in  STD_LOGIC;--
    i_Input         => sl_input ,--: in  STD_LOGIC;--
    i_Reset         => sl_Reset ,--: in  STD_LOGIC;--
    o_Output        => sl_output --: out STD_LOGIC     --
);

end  behave;

