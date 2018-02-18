Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
--	use work.msystem_tcc_pkg.all;
    use work.arobot_stim_tcc_pkg.all;
    use work.arobot_stim_fp_pkg.all;
    use work.spi_transmitter_pkg.all;
                            
entity spi_transmitter_tb is
end spi_transmitter_tb;

architecture behave of spi_transmitter_tb is
    signal sl_OutputClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_reset           : std_logic := '0';
    signal slv8_inputByte     : std_logic_vector(7 downto 0);
    signal sl_dataReq      : std_logic := '0';
    signal sl_TxReady         : std_logic := '0';
    --signal sl_ReadMode        : std_logic := '0'; --! 0 raw spectrum, 1: 3 peaks
    --signal sl_CmdWrite        : std_logic := '0';
    --signal slv4_writeType     : std_logic_vector(3 downto 0);
    --signal slv4_writeIndex    : std_logic_vector(3 downto 0);
    --signal slv8_writeValue   : std_logic_vector(7 downto 0);
    --signal sl_dataValid       : std_logic := '0';
    signal sl_miso         :  std_logic;
    signal sl_TxActive     : std_logic := '0';
    signal sl_validData    : std_logic;
    signal sl_FirstByteValid    : std_logic;
    
    signal slv8_Data       : std_logic_vector(7 downto 0);
    signal rec_SpiMiso  : rec_SpiMiso_type;
 --   signal rec_SpiDataByte : rec_SpiDataByte_type;
 begin	
    
    sl_SpiClk <= rec_SpiMiso.sl_SpiClk;
    sl_validData <= sl_dataReq;
 --   sl_mosi <= rec_SpiMosi.sl_SpiMosi;
 --   rec_SpiDataByte.slv_Byte2Tx <= slv8_inputByte;
      
P_STIMUL: process
 begin
 	--do nothing
    wait for 150 ns;

    wait until rising_edge(sl_OutputClk);
    slv8_Data <= x"aa";
     wait until rising_edge(sl_OutputClk);
    sl_TxActive <= '1';
     wait until rising_edge(sl_OutputClk);
     sl_FirstByteValid <= '1';
     wait until rising_edge(sl_OutputClk);
     sl_FirstByteValid <= '0';
    
    wait until rising_edge(sl_OutputClk);
    slv8_Data <= x"37";
 
     SpiMiso_TxByte(
        clk => sl_OutputClk,
        rec_SpiMiso => rec_SpiMiso
    );
    
    
    
     wait until rising_edge(sl_OutputClk);
   --  sl_validData <= '1';
     wait until rising_edge(sl_OutputClk);
  --   sl_validData <= '0';
     wait until rising_edge(sl_OutputClk);
    SpiMiso_TxByte(
        clk => sl_OutputClk,
        rec_SpiMiso => rec_SpiMiso
    );
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);


    slv8_inputByte <= x"36";

--    SpiMosi_TxByte(
--        clk => sl_OutputClk,
--        rec_SpiDataByte => rec_SpiDataByte,
--        rec_SpiMosi => rec_SpiMosi
--    );



	wait; 	
end process;

    sl_OutputClk    <= not sl_OutputClk after 8 ns;
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

U_DUT : spi_transmitter
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_reset        => sl_Reset,--: in std_logic;
    isl_TxActive     => sl_TxActive,--: in std_logic;
    isl_FirstByteValid => sl_FirstByteValid,
    isl_validData    => sl_validData,--: in std_logic;
    islv8_Data       => slv8_Data,--: in std_logic_vector(7 downto 0);
    osl_dataReq      => sl_dataReq,--
    osl_TxReady      => sl_TxReady,--
    osl_miso         => sl_miso--: out std_logic := 'Z'
);

end  behave;

