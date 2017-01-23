----------------------------------------------------------------------
--! @file  input_dpram.vhd
--! @brief dpram for raw data from ADC
--!
--!
--! @author 
--! @date 
--! @version  
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
package spi_input_pkg is
    component spi_input 
    generic(
        bModelSim           : boolean := FALSE
    );
    port (
-- spi side
    isl_SpiClk       : in std_logic; --! output clock 
    isl_mosi         : in std_logic;
    isl_RxActive     : in std_logic;
-- system side
    isl_SystemClock  : in STD_LOGIC ;
    isl_reset        : in std_logic;
    islv11_rdAddr    : in STD_LOGIC_VECTOR (10 DOWNTO 0);
    isl_SysClkEna    : in STD_LOGIC;
    isl_RdEna        : in STD_LOGIC;
    oslv8_RdData     : out STD_LOGIC_VECTOR (7 DOWNTO 0)
    );        
    end component spi_input;
            
end package spi_input_pkg;

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
Library work;           
    use work.msystem_tcc_pkg.all;

entity spi_input is
    port (
-- spi side
    isl_SpiClk       : in std_logic; --! output clock 
    isl_mosi         : in std_logic;
    isl_RxActive     : in std_logic;
-- system side
    isl_SystemClock  : in STD_LOGIC ;
    isl_reset        : in std_logic;
    islv11_rdAddr    : in STD_LOGIC_VECTOR (10 DOWNTO 0);
    isl_SysClkEna    : in STD_LOGIC;
    isl_RdEna        : in STD_LOGIC;
    oslv8_RdData     : out STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
end entity spi_input;

architecture RTL of spi_input is
-- signals for receiver
    signal sl_SpiClk : std_logic;
    signal sl_Reset : std_logic;
    signal sl_mosi : std_logic;
    signal sl_RxActive : std_logic;
    signal sl_validData : std_logic;
    --signal slv8_Data : std_logic_vector(7 downto 0)

-- signals for transmitter
    signal sl_TxActive : std_logic;
    signal sl_validData : std_logic;
    signal slv8_Data : std_logic_vector(7 downto 0);
    signal uTx_sl_dataReq : std_logic;
    signal uTx_sl_TxReady : std_logic;
    signal uTx_sl_miso : std_logic;


-- signals for DpRam
-- read side    
    signal uDpRam_slv8_RdData : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal slv11_rdAddr : STD_LOGIC_VECTOR (10 DOWNTO 0);
    signal sl_SystemClock : STD_LOGIC ;
    signal sl_SysClkEna : STD_LOGIC;
    signal sl_RdEna : STD_LOGIC;
-- write side
    signal slv11_wrAddr : STD_LOGIC_VECTOR (10 DOWNTO 0);
    signal sl_SpiInternalClk : STD_LOGIC;
    signal sl_wrClkEna : STD_LOGIC;
    signal sl_wrEna : STD_LOGIC  ;
    signal slv8_WrData : STD_LOGIC_VECTOR (7 DOWNTO 0);

    signal slv8_status  : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal slv8_command : STD_LOGIC_VECTOR (7 DOWNTO 0);
    

begin
    sl_Reset <= isl_Reset;
-- input signals for receiver    
    sl_SpiClk <= isl_SpiClk;
    sl_mosi <= isl_mosi;
    sl_RxActive <= isl_RxActive; 
    
    
U_receiver : spi_receiver
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_reset        => sl_Reset,--: in std_logic;
    isl_mosi         => sl_mosi,--: in std_logic;
    isl_RxActive     => sl_RxActive,--: in std_logic;
    osl_validData    => sl_validData,--: out std_logic;
    oslv8_Data       => slv8_WrData--: out std_logic_vector(7 downto 0)
);

uTx : spi_transmitter
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_reset        => sl_Reset,--: in std_logic;
    isl_TxActive     => sl_TxActive,--: in std_logic;
    isl_validData    => sl_validData,--: in std_logic;
    islv8_Data       => slv8_Data,--: in std_logic_vector(7 downto 0);
    osl_dataReq      => uTx_sl_dataReq,--
    osl_TxReady      => uTx_sl_TxReady,--
    osl_miso         => uTx_sl_miso--: out std_logic := 'Z'
);

--U_timeoutCounter : counter_16_down
--port map
--(
--    
--);

-- write in spi side
--read on system side
uDpRam : dpram2048x8
PORT map
(
    data        => slv8_WrData,--: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    rdaddress   => slv11_rdAddr,--: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    rdclock     => sl_SystemClock,--: IN STD_LOGIC ;
    rdclocken   => sl_SysClkEna,--: IN STD_LOGIC  := '1';
    rden        => sl_RdEna,--: IN STD_LOGIC  := '1';
    wraddress   => slv11_wrAddr,--: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    wrclock     => sl_SpiInternalClk,--: IN STD_LOGIC  := '1';
    wrclocken   => sl_wrClkEna,--: IN STD_LOGIC  := '1';
    wren        => sl_wrEna,--: IN STD_LOGIC  := '0';
    q           => uDpRam_slv8_RdData--: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);

end architecture RTL;
