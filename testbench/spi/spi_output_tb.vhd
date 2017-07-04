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
    use work.spi_output_pkg.all;
                            
entity spi_output_tb is
end spi_output_tb;

architecture behave of spi_output_tb is
    signal sl_OutputClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_SystemClk : STD_LOGIC := '0';     -- clock 50Mhz
    
    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_reset           : std_logic := '0';
--    signal slv8_inputByte     : std_logic_vector(7 downto 0);
--    signal sl_dataReq      : std_logic := '0';
--    signal sl_TxReady         : std_logic := '0';
    signal sl_miso         :  std_logic;
    signal sl_TxActive     : std_logic := '0';
--    signal sl_validData    : std_logic;
--    signal slv8_Data       : std_logic_vector(7 downto 0);
    signal rec_SpiMiso  : rec_SpiMiso_type;
--    signal slv8_status : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"AA";
--    signal slv8_command : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"37";
--    signal slv11_OutWrAddr : STD_LOGIC_VECTOR (10 DOWNTO 0);
--    signal sl_SysClkEna : STD_LOGIC;
--    signal sl_OutWrEna : STD_LOGIC;
--    signal slv8_WrData:  STD_LOGIC_VECTOR (7 DOWNTO 0);

    signal slv8_MagicWord  : std_logic_vector(7 downto 0) := x"a5"; 
    signal slv8_Header     : std_logic_vector(7 downto 0) := x"22";  
    signal slv32_DataL     : std_logic_vector(31 downto 0) := x"12345678"; 
    signal slv32_DataR     : std_logic_vector(31 downto 0) := x"9ABCDEF0";
    signal sl_dataValid     : std_logic := '0'; 

 begin	
    
--    sl_SpiClk <= rec_SpiMiso.sl_SpiClk;
      sl_SpiClk <= sl_OutputClk;
P_STIMUL: process
 begin
 	--do nothing
    wait for 400 ns;

    wait until rising_edge(sl_OutputClk);
    sl_dataValid <= '1';
     wait until rising_edge(sl_OutputClk);
    sl_dataValid <= '0';

    wait for 100 ns;
    wait until rising_edge(sl_OutputClk);
    sl_TxActive <= '1';
     wait until rising_edge(sl_OutputClk);
    sl_TxActive <= '0';
    
    SpiMiso_TxByte(
        clk => sl_OutputClk,
        rec_SpiMiso => rec_SpiMiso
    );
    
     wait until rising_edge(sl_OutputClk);
    SpiMiso_TxByte(
        clk => sl_OutputClk,
        rec_SpiMiso => rec_SpiMiso
    );
     wait until rising_edge(sl_OutputClk);
    SpiMiso_TxByte(
        clk => sl_OutputClk,
        rec_SpiMiso => rec_SpiMiso
    );
    
     wait until rising_edge(sl_OutputClk);
    SpiMiso_TxByte(
        clk => sl_OutputClk,
        rec_SpiMiso => rec_SpiMiso
    );
    
     wait until rising_edge(sl_OutputClk);


--    slv8_inputByte <= x"36";

--    SpiMosi_TxByte(
--        clk => sl_OutputClk,
--        rec_SpiDataByte => rec_SpiDataByte,
--        rec_SpiMosi => rec_SpiMosi
--    );



	wait; 	
end process;

    sl_OutputClk    <= not sl_OutputClk after 32 ns;
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

U_DUT : spi_output
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_TxActive     => sl_TxActive,--: in std_logic;
    osl_miso         => sl_miso,--,: out std_logic;
-- system side
    isl_SystemClock  => sl_SystemClk,--: in STD_LOGIC ;
    isl_reset        => sl_reset,--: in std_logic;
    isl_dataValid    => sl_dataValid ,--: in std_logic;
    islv8_MagicWord  => slv8_MagicWord  ,--: in std_logic_vector(7 downto 0);
    islv8_Header     => slv8_Header     ,--: in std_logic_vector(7 downto 0);
    islv32_DataL     => slv32_DataL     ,--: in std_logic_vector(31 downto 0);
    islv32_DataR     => slv32_DataR     --: in std_logic_vector(31 downto 0);
--    islv11_OutWrAddr => slv11_OutWrAddr,--: in STD_LOGIC_VECTOR (10 DOWNTO 0);
--    isl_SysClkEna    => sl_SysClkEna,--: in STD_LOGIC;
--    isl_OutWrEna     => sl_OutWrEna,--: in STD_LOGIC;
--    islv8_WrData     => slv8_WrData--: in STD_LOGIC_VECTOR (7 DOWNTO 0)


);

end  behave;

