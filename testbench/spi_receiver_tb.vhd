Library std;
	use std.standard.all;
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

Library work;           
	use work.arobot_constant_pkg.all;
    use work.arobot_stim_tcc_pkg.all;
    use work.arobot_stim_fp_pkg.all;
    use work.spi_receiver_pkg.all;
                            
entity spi_receiver_tb is
end spi_receiver_tb;

architecture behave of spi_receiver_tb is
    signal sl_OutputClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    signal sl_reset           : std_logic := '0';
    signal slv8_inputByte     : std_logic_vector(7 downto 0);
    --signal sl_inputValid      : std_logic := '0';
    --signal sl_CmdRead         : std_logic := '0';
    --signal sl_ReadMode        : std_logic := '0'; --! 0 raw spectrum, 1: 3 peaks
    --signal sl_CmdWrite        : std_logic := '0';
    --signal slv4_writeType     : std_logic_vector(3 downto 0);
    --signal slv4_writeIndex    : std_logic_vector(3 downto 0);
    --signal slv8_writeValue   : std_logic_vector(7 downto 0);
    --signal sl_dataValid       : std_logic := '0';
    signal sl_mosi         :  std_logic;
    signal sl_RxActive     : std_logic := '0';
    signal sl_validData    : std_logic;
    signal slv8_Data       : std_logic_vector(7 downto 0);
    signal rec_SpiMosi  : rec_SpiMosi_type;
    signal rec_SpiDataByte : rec_SpiDataByte_type;
 begin	
    
    sl_SpiClk <= rec_SpiMosi.sl_SpiClk;
    sl_mosi <= rec_SpiMosi.sl_SpiMosi;
    rec_SpiDataByte.slv_Byte2Tx <= slv8_inputByte;
      
P_STIMUL: process
 begin
 	--do nothing
    wait for 100 ns;

    wait until rising_edge(sl_OutputClk);
    slv8_inputByte <= eMagicRead;
     wait until rising_edge(sl_OutputClk);
    sl_RxActive <= '1';
     wait until rising_edge(sl_OutputClk);
    
    SpiMosi_TxByte(
        clk => sl_OutputClk,
        rec_SpiDataByte => rec_SpiDataByte,
        rec_SpiMosi => rec_SpiMosi
    );
    
    
    
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);
     wait until rising_edge(sl_OutputClk);


    slv8_inputByte <= x"36";

    SpiMosi_TxByte(
        clk => sl_OutputClk,
        rec_SpiDataByte => rec_SpiDataByte,
        rec_SpiMosi => rec_SpiMosi
    );



	wait; 	
end process;

    sl_OutputClk    <= not sl_OutputClk after 8 ns;
    U_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 30 ns;
    	sl_Reset <= '1';
    	
        wait for 30 ns;

    	sl_Reset <= '0';

        wait for 30 ns;
			--sl_sliceTick <= '1';
        wait;
    end process;

U_DUT : spi_receiver
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_reset           => sl_Reset,--: in std_logic;
    isl_mosi            => sl_mosi,--: in std_logic;
    isl_RxActive        => sl_RxActive,--: in std_logic;
    osl_validData       => sl_validData,--: out std_logic;
    oslv8_Data          => slv8_Data--: out std_logic_vector(7 downto 0)
);

end  behave;

