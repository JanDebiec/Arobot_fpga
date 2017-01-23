----------------------------------------------------------------------
--! @file  spi_if.vhd
--! @brief 
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
package spi_if_pkg is
    component spi_if 
    generic(
        bModelSim           : boolean := FALSE
    );
    port (
-- spi side
    isl_SpiClk       : in std_logic; --! output clock 
    isl_SpiCSn       : in std_logic;
    isl_mosi         : in std_logic;--! input to SPI, 
    osl_miso         : out std_logic;
-- system side
    isl_SystemClock  : in STD_LOGIC ;
    isl_reset        : in std_logic;
    islv16_status    : STD_LOGIC_VECTOR (15 DOWNTO 0);
    islv16_IrqAck     : in STD_LOGIC_VECTOR (15 DOWNTO 0);
    oslv8_commandL   : out STD_LOGIC_VECTOR (7 DOWNTO 0);
    oslv8_commandH   : out STD_LOGIC_VECTOR (7 DOWNTO 0)
--    islv11_OutWrAddr : in STD_LOGIC_VECTOR (10 DOWNTO 0);
--    isl_SysClkEna    : in STD_LOGIC;
--    isl_OutWrEna     : in STD_LOGIC;
--    islv8_WrData     : in STD_LOGIC_VECTOR (7 DOWNTO 0)
    );        
    end component spi_if;
            
end package spi_if_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
    use work.msystem_tcc_pkg.all;
    use work.deflipflop_pkg.all;
    use work.srflipflop_pkg.all;
    use work.monoshot_pkg.all;
    use work.mono_on_spiborder_pkg.all;
    use work.spi_transmitter_pkg.all;
    use work.spi_receiver_pkg.all;
    use work.spi_output_pkg.all;

entity spi_if is
    generic(
        bModelSim           : boolean := FALSE
    );
    port (
-- spi side
    isl_SpiClk       : in std_logic; --! output clock 
    isl_SpiCSn       : in std_logic;
    isl_mosi         : in std_logic;--! input to SPI, 
    osl_miso         : out std_logic;
-- system side
    isl_SystemClock  : in STD_LOGIC ;
    isl_reset        : in std_logic;
    islv16_status     : in STD_LOGIC_VECTOR (15 DOWNTO 0);
    islv16_IrqAck     : in STD_LOGIC_VECTOR (15 DOWNTO 0);
    oslv8_commandL    : out STD_LOGIC_VECTOR (7 DOWNTO 0);
    oslv8_commandH    : out STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
end entity spi_if;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture RTL of spi_if is
-- internal clocks, resets
    signal sl_NiosClk : STD_LOGIC := '0';     -- clock 128 MHz
    signal sl_clk50Mhz : STD_LOGIC;     -- clock 50 MHz
   -- signal sl_SpiClk : std_logic;
    signal sl_Reset     : STD_LOGIC := '0';
    signal sl_ResetN    : STD_LOGIC;
-- SPI sognals
    signal sl_SpiClk : STD_LOGIC := '0';     -- clock 30 - 128 MHz
    SIGNAL mode    : STD_LOGIC;  --groups modes by clock polarity relation to data
    SIGNAL cpol        : STD_LOGIC := '0';  --spi clock polarity mode
    SIGNAL cpha        : STD_LOGIC := '0';  --spi clock phase mode
    signal sl_mosi         :  std_logic;
    signal uOut_sl_miso         :  std_logic;
-- signals for spi_receiver
    signal sl_RxActive     : std_logic;
    signal uRx_usl_validRxData    : std_logic;
    signal sl_validRxDataN    : std_logic;
    signal uClkBrd_sl_validRxData128    : std_logic;
    signal uRx_slv8_RxData       : std_logic_vector(7 downto 0);
-- signals for transmitter
    signal sl_TxActive : std_logic := '0';
--signals for system side    
    signal slv8_command : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal slv16_command : STD_LOGIC_VECTOR (15 DOWNTO 0);
    signal slv8_statusL : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal slv8_statusH : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal slv16_status : STD_LOGIC_VECTOR (15 DOWNTO 0);
    signal sl_IrqReq : std_logic;
-- singel signals in status L and H
    signal sl_SearchReady : std_logic;
    signal sl_IrqAck : std_logic;
    
begin
    sl_NiosClk <= isl_SystemClock;
    sl_SpiClk <= isl_SpiClk;
    osl_miso <= uOut_sl_miso;
    sl_Reset <= isl_Reset;
    sl_TxActive <= not isl_SpiCSn;
    sl_RxActive <= not isl_SpiCSn;
    sl_mosi <= isl_mosi;

    slv8_statusL <= islv16_status(7 downto 0);
    slv8_statusH <= islv16_status(15 downto 8);
    oslv8_commandL <= slv8_command;
    oslv8_commandH <= sl_IrqReq & "0000000";
    
    sl_SearchReady <= slv8_statusL(0);
    sl_IrqAck <= islv16_IrqAck(15);

p_cmd : process(
    uClkBrd_sl_validRxData128
) is
begin
    if(uClkBrd_sl_validRxData128 = '1') then
        slv8_command <= uRx_slv8_RxData;
    end if;    
end process;   

--P_PrepIrq : process (
--    uClkBrd_sl_validRxData128, sl_IrqAck, sl_IrqReq
--) is
--begin
--    if(uClkBrd_sl_validRxData128 = '1') then
--        sl_IrqReqNext <= '1';
--    elsif (sl_IrqAck = '0') then   
--        sl_IrqReqNext <= '0';
--    else
--        sl_IrqReqNext <= sl_IrqReq;    
--    end if;    
--end process;   

U_PrepIrq : srflipflop 
PORT map
(
    isl_clock   => sl_NiosClk,--:    IN STD_LOGIC;
    isl_s       => uClkBrd_sl_validRxData128,--:    IN STD_LOGIC;
    isl_r       => sl_IrqAck,--:    IN STD_LOGIC;
    isl_reset   => sl_Reset,--:    IN STD_LOGIC;
    osl_out     => sl_IrqReq--:    OUT STD_LOGIC
);

    
uRx : spi_receiver
port map
(
--! signals on OutputCLock domain
    isl_SpiClk          => sl_SpiClk,
    isl_reset           => sl_Reset,--: in std_logic;
    isl_mosi            => sl_mosi,--: in std_logic;
    isl_RxActive        => sl_RxActive,--: in std_logic;
    osl_validData       => uRx_usl_validRxData,--: out std_logic;
    oslv8_Data          => uRx_slv8_RxData--: out std_logic_vector(7 downto 0)
);

uClkBrd : mono_on_spiborder
--U_ValidRxData : mono_on_rising
port map
(
    i_SpiClock    => sl_SpiClk ,--: in  STD_LOGIC;--
    i_SystemClock   => sl_NiosClk ,--: in  STD_LOGIC;--
    i_Input         => uRx_usl_validRxData ,--: in  STD_LOGIC;--
    i_Reset         => sl_reset ,--: in  STD_LOGIC;--
    o_Output        => uClkBrd_sl_validRxData128 --: out STD_LOGIC     --
);

uOut : spi_output
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_TxActive     => sl_TxActive,--: in std_logic;
    osl_miso         => uOut_sl_miso,--,: out std_logic;
-- system side
    isl_SystemClock  => sl_NiosClk,--: in STD_LOGIC ;
    isl_reset        => sl_reset,--: in std_logic;
    islv8_status     => slv8_statusL,--: STD_LOGIC_VECTOR (7 DOWNTO 0);
    islv8_command    => slv8_command--: STD_LOGIC_VECTOR (7 DOWNTO 0);
);


end architecture RTL;
