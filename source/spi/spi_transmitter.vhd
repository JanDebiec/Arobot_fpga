----------------------------------------------------------------------
--! @file  spi_transmitter.vhd
--! @brief  
--!
--!
--! @author 
--! @date 
--! @version  16.11.2015
--! 
--! note 
--! @todo 
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

--!
package spi_transmitter_pkg is
    component spi_transmitter 
    port (
    isl_SpiClk       : in std_logic; --! output clock 
    isl_reset        : in std_logic;
    isl_TxActive     : in std_logic;
    isl_FirstByteValid    : in std_logic;
    isl_validData    : in std_logic;
    islv8_Data       : in std_logic_vector(7 downto 0);
    osl_dataReq      : out std_logic;
    osl_TxReady      : out std_logic;
    osl_miso         : out std_logic := 'Z'
   );
    end component spi_transmitter;
            
end package spi_transmitter_pkg;


library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.msystem_tcc_pkg.all;

entity spi_transmitter is
    port (
    isl_SpiClk       : in std_logic; --! output clock 
    isl_reset        : in std_logic;
    isl_TxActive     : in std_logic;
    isl_FirstByteValid    : in std_logic;
    isl_validData    : in std_logic;
    islv8_Data       : in std_logic_vector(7 downto 0);
    osl_dataReq      : out std_logic;
    osl_TxReady      : out std_logic;
    osl_miso         : out std_logic := 'Z'
    );
end entity spi_transmitter;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture RTL of spi_transmitter is
   SIGNAL tx_buf            : STD_LOGIC_VECTOR(8 DOWNTO 0); --transmit buffer
   --   SIGNAL tx_buf  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');  --transmit buffer
   SIGNAL tx_buf_high       : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0'); --transmit buffer
   SIGNAL tx_buf_low        : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0'); --transmit buffer
   SIGNAL pre_tx_buf        : STD_LOGIC_VECTOR(7 DOWNTO 0); --transmit buffer
   SIGNAL slv8_cntReg       : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0'); --transmit buffer
   SIGNAL slv16_cntReg      : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0'); --transmit buffer
   SIGNAL mode              : STD_LOGIC; --groups modes by clock polarity relation to data
   SIGNAL internSpiClk      : STD_LOGIC; --clock
   signal n_LoadByteIndex   : uPingPongIndex;
   signal n_TxByteIndex     : uPingPongIndex;
   signal n_TxByteIndexNext : uPingPongIndex;
   signal sl_dataReq        : std_logic;
   signal sl_TxReady        : std_logic;
   signal sl_takeOverData   : std_logic;
    
    
begin

    internSpiClk <= isl_SpiClk;
    sl_dataReq <= slv8_cntReg(1);
    sl_TxReady<= slv8_cntReg(7);
    osl_dataReq <= sl_dataReq;
    osl_TxReady <= sl_TxReady;
    
    -- for simulations:
    tx_buf_high <= tx_buf(8 downto 1);
    tx_buf_low <= tx_buf(7 downto 0);
    

P_ctnReg : process(isl_SpiClk, isl_reset)
begin
        --count registers
    IF(isl_reset = '1') THEN
      slv8_cntReg <= x"01";
    elsif falling_edge(isl_SpiClk) then 
        slv8_cntReg <= slv8_cntReg(6 downto 0) & slv8_cntReg(7); 
    END IF;
end process;

P_PreTxBuf : process(isl_reset, isl_validData)
begin
    IF(isl_reset = '1') THEN
      pre_tx_buf <= (OTHERS => 'Z');
    elsif falling_edge(isl_validData) then 
        pre_tx_buf <= islv8_Data; 
    END IF;
end process;    

P_txBuf : process(isl_SpiClk, isl_reset, sl_TxReady, isl_FirstByteValid)
begin
    --transmit registers
    IF (isl_reset = '1') THEN
        tx_buf <= (OTHERS => 'Z');
    ELSIF (isl_FirstByteValid = '1') THEN    --load transmit register from user logic
            tx_buf(8 downto 1) <= islv8_Data;
    elsif falling_edge(isl_SpiClk)  then
        IF (sl_TxReady = '1') THEN    --load transmit register from user logic
            tx_buf(8 downto 1) <=  pre_tx_buf;
        else    
            tx_buf <= tx_buf(7 downto 0) & tx_buf(8);
        end if;    
    END IF;
end process;

--    osl_miso <= 'Z' when ((isl_TxActive = '0') OR (isl_reset = '1')  or (slv8_cntReg(0) = '1')) else
    osl_miso <= 'Z' when ((isl_TxActive = '0') OR (isl_reset = '1')) else
                tx_buf(8);

end architecture RTL;
