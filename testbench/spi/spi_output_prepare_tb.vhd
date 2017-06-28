Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
	use work.arobot_constant_pkg.all;
    use work.arobot_typedef_pkg.all;
    use work.arobot_component_pkg.all;
    use work.arobot_stim_tcc_pkg.all;
    use work.arobot_stim_fp_pkg.all;
    use work.spi_transmitter_pkg.all;
    use work.spi_output_prepare_pkg.all;
                            
entity spi_output_prepare_tb is
end spi_output_prepare_tb;

architecture behave of spi_output_prepare_tb is
--    signal sl_OutputClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_SystemClk : STD_LOGIC := '0';     -- clock 50Mhz
    
--    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_reset           : std_logic := '0';
    signal slv8_MagicWord  : std_logic_vector(7 downto 0) := x"a5"; 
    signal slv8_Header     : std_logic_vector(7 downto 0) := x"22";  
    signal slv32_DataL     : std_logic_vector(31 downto 0) := x"12345678"; 
    signal slv32_DataR     : std_logic_vector(31 downto 0) := x"9ABCDEF0"; 
    signal sl_transferData : std_logic;                     
    signal slv8_outData    : std_logic_vector(7 downto 0);  
    signal sl_firstByteValid : std_logic;                
    signal sl_DataValid    : std_logic;                     
    signal sl_txActive     : std_logic;                     
--    signal slv8_status : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"AA";
--    signal slv8_command : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"37";
--    signal slv11_OutWrAddr : STD_LOGIC_VECTOR (10 DOWNTO 0);
--    signal sl_SysClkEna : STD_LOGIC;
--    signal sl_OutWrEna : STD_LOGIC;
--    signal slv8_WrData:  STD_LOGIC_VECTOR (7 DOWNTO 0);
 begin	
    
      
P_STIMUL: process
 begin
 	--do nothing
    wait for 300 ns;

    wait until rising_edge(sl_SystemClk);
    sl_transferData <= '1';

    wait for 300 ns;
    wait until rising_edge(sl_SystemClk);
    sl_transferData <= '0';
--    
--    SpiMiso_TxByte(
--        clk => sl_OutputClk,
--        rec_SpiMiso => rec_SpiMiso
--    );
--    


	wait; 	
end process;

    sl_SystemClk    <= not sl_SystemClk after 12 ns;
    
    U_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 100 ns;
    	sl_Reset <= '1';
    	
        wait for 100 ns;

    	sl_Reset <= '0';

        wait for 100 ns;
			--sl_sliceTick <= '1';
        wait;
    end process;

U_DUT : spi_output_prepare
port map
(
-- system side
    isl_SystemClock  => sl_SystemClk,--: in STD_LOGIC ;
    islv8_MagicWord  => slv8_MagicWord  ,--: in std_logic_vector(7 downto 0);
    islv8_Header     => slv8_Header     ,--: in std_logic_vector(7 downto 0);
    islv32_DataL     => slv32_DataL     ,--: in std_logic_vector(31 downto 0);
    islv32_DataR     => slv32_DataR     ,--: in std_logic_vector(31 downto 0);
    isl_transferData => sl_transferData ,--: in std_logic;
    oslv8_outData    => slv8_outData    ,--: out std_logic_vector(7 downto 0);
    osl_firstByteValid  => sl_firstByteValid,--: out std_logic;
    osl_DataValid    => sl_DataValid,--: out std_logic;
    osl_txActive     => sl_txActive,--: out std_logic;
    isl_reset        => sl_reset--: in std_logic;
);

end  behave;

