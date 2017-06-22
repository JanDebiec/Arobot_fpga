Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
--	use work.msystem_tcc_pkg.all;
    use work.msystem_stim_tcc_pkg.all;
    use work.msystem_stim_fp_pkg.all;
    use work.wire_transmitter_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;
                            
entity wire_transmitter_tb is
  generic (runner_cfg : string := "");
end wire_transmitter_tb;

architecture behave of wire_transmitter_tb is
    signal sl_clock : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_reset           : std_logic := '0';
    signal sl_dataReq      : std_logic := '0';
    signal sl_Sync         : std_logic := '0';
    signal sl_miso         :  std_logic := '0';
    signal sl_validData    : std_logic := '0';
    signal sl_wireClock    : std_logic := '0';
    
    signal slv16_Data       : std_logic_vector(15 downto 0) := x"0000";
    signal slv16_inputData       : std_logic_vector(15 downto 0) := x"0000";
 begin	
    
P_STIMUL: process
 begin
    test_runner_setup(runner, runner_cfg);
 	--do nothing
    wait for 150 ns;

    wait until rising_edge(sl_clock);
    slv16_inputData <= x"8732";
    
	wait for 1 us; 
    wait until rising_edge(sl_clock);
    Wire_TxWord(
    	sl_clock,
    	slv16_inputData,
    	sl_validData,
    	slv16_Data
    );
    
    
	wait for 1 us; 
    slv16_inputData <= x"AAAA";
    wait until rising_edge(sl_clock);
    Wire_TxWord(
    	sl_clock,
    	slv16_inputData,
    	sl_validData,
    	slv16_Data
    );
     wait until rising_edge(sl_clock);

    wait for 1 us; 
    test_runner_cleanup(runner); -- Simulation ends here
	wait; 	
end process;

    sl_clock    <= not sl_clock after 20 ns;
    U_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 50 ns;
    	sl_Reset <= '1';
    	
        wait for 50 ns;

    	sl_Reset <= '0';

        wait for 100 ns;
			--sl_sliceTick <= '1';
        wait;
    end process;

U_DUT : wire_transmitter
generic map (
    cnDataWidth => 16
)
port map
(
--! signals on OutputCLock domain
    isl_clock       => sl_clock,
    isl_reset        => sl_Reset,--: in std_logic;
    isl_validData    => sl_validData,--: in std_logic;
    islvn_Data       => slv16_Data,--: in std_logic_vector(7 downto 0);
    osl_wireClock   => sl_wireClock,
    osl_SyncN      => sl_Sync,--
    osl_output         => sl_miso--: out std_logic := 'Z'
);

end  behave;

