Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
	use work.msystem_tcc_pkg.all;
    use work.msystem_stim_tcc_pkg.all;
    use work.msystem_stim_fp_pkg.all;
    use work.spi_transmitter_pkg.all;
    use work.spi_output_pkg.all;
    use work.spi_if_pkg.all;
                            
entity spi_if_tb is
end spi_if_tb;

architecture behave of spi_if_tb is
    signal sl_OutputClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_SystemClk : STD_LOGIC := '0';     -- clock 50Mhz
    
    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_reset           : std_logic := '0';
    signal slv8_inputByte     : std_logic_vector(7 downto 0);
    signal sl_dataReq      : std_logic := '0';
    signal sl_TxReady         : std_logic := '0';
    signal sl_miso         :  std_logic;
    signal sl_TxActive     : std_logic := '0';
--    signal sl_validData    : std_logic;
    signal slv8_Data       : std_logic_vector(7 downto 0);
    signal rec_SpiMiso  : rec_SpiMiso_type;
    signal slv16_status : STD_LOGIC_VECTOR (15 DOWNTO 0) := x"1327";
    signal slv16_command : STD_LOGIC_VECTOR (15 DOWNTO 0) := x"3755";
    signal slv8_commandL : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"55";
    signal slv8_commandH : STD_LOGIC_VECTOR (7 DOWNTO 0) := x"37";
    signal slv11_OutWrAddr : STD_LOGIC_VECTOR (10 DOWNTO 0);
    signal sl_SysClkEna : STD_LOGIC;
    signal sl_OutWrEna : STD_LOGIC;
    signal slv8_WrData:  STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal sl_SpiCSn : STD_LOGIC := '1';
    signal sl_mosi : STD_LOGIC;
    signal rec_SpiMosi  : rec_SpiMosi_type;
    signal rec_SpiDataByte : rec_SpiDataByte_type;
    
    
 begin	
    
    --sl_SpiClk <= rec_SpiMiso.sl_SpiClk;
    sl_SpiClk <= rec_SpiMosi.sl_SpiClk;
    sl_mosi <= rec_SpiMosi.sl_SpiMosi;
    rec_SpiDataByte.slv_Byte2Tx <= slv8_inputByte;
      
P_STIMUL: process
 begin
 	--do nothing
    wait for 300 ns;

    wait until rising_edge(sl_OutputClk);
     slv8_inputByte <= eMagicRead;
    slv8_Data <= slv16_status(7 downto 0);
     wait until rising_edge(sl_OutputClk);
    sl_SpiCSn <= '0';
     wait until rising_edge(sl_OutputClk);
 --    sl_validData <= '1';
     wait until rising_edge(sl_OutputClk);
 --    sl_validData <= '0';
    
   Spi_TxRxByte(
        clk => sl_OutputClk,
        rec_SpiDataByte => rec_SpiDataByte,
        rec_SpiMosi => rec_SpiMosi,
        rec_SpiMiso => rec_SpiMiso
    );
    
--    SpiMiso_TxByte(
--        clk => sl_OutputClk,
--        rec_SpiMiso => rec_SpiMiso
--    );
      wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
    
    slv8_inputByte <= x"36";
     wait until rising_edge(sl_OutputClk);
--    SpiMiso_TxByte(
--        clk => sl_OutputClk,
--        rec_SpiMiso => rec_SpiMiso
--    );
     wait until rising_edge(sl_OutputClk);


   Spi_TxRxByte(
        clk => sl_OutputClk,
        rec_SpiDataByte => rec_SpiDataByte,
        rec_SpiMosi => rec_SpiMosi,
        rec_SpiMiso => rec_SpiMiso
    );
    

--    SpiMiso_TxByte(
--        clk => sl_OutputClk,
--        rec_SpiMiso => rec_SpiMiso
--    );
    
     wait until rising_edge(sl_OutputClk);
    SpiMiso_TxByte(
        clk => sl_OutputClk,
        rec_SpiMiso => rec_SpiMiso
    );
    
     wait until rising_edge(sl_OutputClk);


    slv8_inputByte <= x"36";

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

U_DUT : spi_if
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_SpiCSn     => sl_SpiCSn,--: in std_logic;
    isl_mosi         => sl_mosi,--: in std_logic;--! input to SPI, 
    osl_miso         => sl_miso,--,: out std_logic;
-- system side
    isl_SystemClock  => sl_SystemClk,--: in STD_LOGIC ;
    isl_reset        => sl_reset,--: in std_logic;
    islv16_status     => slv16_status,--: STD_LOGIC_VECTOR (7 DOWNTO 0);
    oslv8_commandL    => slv8_commandL,--: STD_LOGIC_VECTOR (7 DOWNTO 0);
    oslv8_commandH    => slv8_commandH--: STD_LOGIC_VECTOR (7 DOWNTO 0);
);

end  behave;

