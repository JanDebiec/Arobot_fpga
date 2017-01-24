----------------------------------------------------------------------
--! @file  c5_1701.vhd
--! @brief top level of ARobot C5 fpga 
--! version 1701, see notes
--!
--!
--! @author 
--! @date 
--! @version  
--! 
--! note 
--! @todo 
--! TODO: SW, KEY, LED -> configuration
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

--!
package c5_1701_pkg is
    component c5_1701 
    generic(
            bModelSim : boolean := FALSE;
            bISSP     : boolean := TRUE
    );
    port (
      CLOCK_50    : in std_logic;
--!///////// HPS /////////
      HPS_CONV_USB_N    : inout   std_logic;           
      HPS_DDR3_ADDR     : out  std_logic_vector(14 downto 0); 
      HPS_DDR3_BA       : out  std_logic_vector(2 downto 0);   
      HPS_DDR3_CAS_N    : out  std_logic;           
      HPS_DDR3_CKE      : out  std_logic;           
      HPS_DDR3_CK_N     : out  std_logic;           
      HPS_DDR3_CK_P     : out  std_logic;           
      HPS_DDR3_CS_N     : out  std_logic;           
      HPS_DDR3_DM       : out  std_logic_vector(3 downto 0);      
      HPS_DDR3_DQ       : inout   std_logic_vector(31 downto 0);   
      HPS_DDR3_DQS_N    : inout   std_logic_vector(3 downto 0);  
      HPS_DDR3_DQS_P    : inout   std_logic_vector(3 downto 0);   
      HPS_DDR3_ODT      : out  std_logic;           
      HPS_DDR3_RAS_N    : out  std_logic;           
      HPS_DDR3_RESET_N  : out  std_logic;           
      HPS_DDR3_RZQ      : in   std_logic;           
      HPS_DDR3_WE_N     : out  std_logic;           
      HPS_ENET_GTX_CLK  : out  std_logic;           
      HPS_ENET_INT_N    : inout   std_logic;           
      HPS_ENET_MDC      : out  std_logic;           
      HPS_ENET_MDIO     : inout   std_logic;           
      HPS_ENET_RX_CLK   : in   std_logic;           
      HPS_ENET_RX_DATA  : in   std_logic_vector(3 downto 0);  
      HPS_ENET_RX_DV    : in   std_logic;           
      HPS_ENET_TX_DATA  : out  std_logic_vector(3 downto 0);  
      HPS_ENET_TX_EN    : out  std_logic;           
      HPS_GSENSOR_INT   : inout   std_logic;           
      HPS_I2C0_SCLK     : inout   std_logic;           
      HPS_I2C0_SDAT     : inout   std_logic;           
      HPS_I2C1_SCLK     : inout   std_logic;           
      HPS_I2C1_SDAT     : inout   std_logic;           
      HPS_KEY           : inout   std_logic;           
      HPS_LED           : inout   std_logic;           
      HPS_LTC_GPIO      : inout   std_logic;           
      HPS_SD_CLK        : out  std_logic;           
      HPS_SD_CMD        : inout   std_logic;           
      HPS_SD_DATA       : inout   std_logic_vector(3 downto 0);  
      HPS_SPIM_CLK      : out  std_logic;           
      HPS_SPIM_MISO     : in   std_logic;           
      HPS_SPIM_MOSI     : out  std_logic;           
      HPS_SPIM_SS       : inout   std_logic;           
      HPS_UART_RX       : in   std_logic;           
      HPS_UART_TX       : out  std_logic;           
      HPS_USB_CLKOUT    : in   std_logic;           
      HPS_USB_DATA      : inout   std_logic_vector(7 downto 0);  
      HPS_USB_DIR       : in   std_logic;           
      HPS_USB_NXT       : in   std_logic;           
      HPS_USB_STP       : out  std_logic;           

--!///////// KEY /////////
        KEY         : in std_logic_vector(3 downto 0) ; --reset active low
--      input       [1:0]  KEY,

--!///////// LED /////////
--      output      [7:0]  LED,
        LED         : out std_logic_vector(7 downto 0);

--!///////// SW /////////
--      input       [3:0]  SW
        SW          : in std_logic_vector(3 downto 0) ; 

--!///////// X Axis /////////
	osl_outX1A		: out std_logic;
	osl_outX1B		: out std_logic;
	osl_outX2A		: out std_logic;
	osl_outX2B		: out std_logic;
	osl_slice_tick		: out std_logic;	--!
--! testing
    osl_PerfTest  : out std_logic
    );
    end component c5_1701;
            
end package c5_1701_pkg;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library work;           
	use work.arobot_constant_pkg.all;
	use work.arobot_component_pkg.all;
    use work.h2flw_interface_pkg.all;
    use work.convPos2Pwm_pkg.all;
    use work.deflipflop_pkg.all;
    use work.monoshot_pkg.all;
    use work.slice_tick_gen_pkg.all;
    use work.pwm_pulse_pkg.all;
    use work.one_axis_pkg.all;
    use work.velocity_issp_pkg.all;
    use work.version_pkg.all;

entity c5_1701 is
    generic(
            bModelSim : boolean := FALSE;
            bISSP     : boolean := TRUE
    );
port (
  CLOCK_50    : in std_logic;
--///////// HPS /////////
  HPS_CONV_USB_N    : inout   std_logic;           
  HPS_DDR3_ADDR     : out  std_logic_vector(14 downto 0); 
  HPS_DDR3_BA       : out  std_logic_vector(2 downto 0);   
  HPS_DDR3_CAS_N    : out  std_logic;           
  HPS_DDR3_CKE      : out  std_logic;           
  HPS_DDR3_CK_N     : out  std_logic;           
  HPS_DDR3_CK_P     : out  std_logic;           
  HPS_DDR3_CS_N     : out  std_logic;           
  HPS_DDR3_DM       : out  std_logic_vector(3 downto 0);      
  HPS_DDR3_DQ       : inout   std_logic_vector(31 downto 0);   
  HPS_DDR3_DQS_N    : inout   std_logic_vector(3 downto 0);  
  HPS_DDR3_DQS_P    : inout   std_logic_vector(3 downto 0);   
  HPS_DDR3_ODT      : out  std_logic;           
  HPS_DDR3_RAS_N    : out  std_logic;           
  HPS_DDR3_RESET_N  : out  std_logic;           
  HPS_DDR3_RZQ      : in   std_logic;           
  HPS_DDR3_WE_N     : out  std_logic;           
  HPS_ENET_GTX_CLK  : out  std_logic;           
  HPS_ENET_INT_N    : inout   std_logic;           
  HPS_ENET_MDC      : out  std_logic;           
  HPS_ENET_MDIO     : inout   std_logic;           
  HPS_ENET_RX_CLK   : in   std_logic;           
  HPS_ENET_RX_DATA  : in   std_logic_vector(3 downto 0);  
  HPS_ENET_RX_DV    : in   std_logic;           
  HPS_ENET_TX_DATA  : out  std_logic_vector(3 downto 0);  
  HPS_ENET_TX_EN    : out  std_logic;           
  HPS_GSENSOR_INT   : inout   std_logic;           
  HPS_I2C0_SCLK     : inout   std_logic;           
  HPS_I2C0_SDAT     : inout   std_logic;           
  HPS_I2C1_SCLK     : inout   std_logic;           
  HPS_I2C1_SDAT     : inout   std_logic;           
  HPS_KEY           : inout   std_logic;           
  HPS_LED           : inout   std_logic;           
  HPS_LTC_GPIO      : inout   std_logic;           
  HPS_SD_CLK        : out  std_logic;           
  HPS_SD_CMD        : inout   std_logic;           
  HPS_SD_DATA       : inout   std_logic_vector(3 downto 0);  
  HPS_SPIM_CLK      : out  std_logic;           
  HPS_SPIM_MISO     : in   std_logic;           
  HPS_SPIM_MOSI     : out  std_logic;           
  HPS_SPIM_SS       : inout   std_logic;           
  HPS_UART_RX       : in   std_logic;           
  HPS_UART_TX       : out  std_logic;           
  HPS_USB_CLKOUT    : in   std_logic;           
  HPS_USB_DATA      : inout   std_logic_vector(7 downto 0);  
  HPS_USB_DIR       : in   std_logic;           
  HPS_USB_NXT       : in   std_logic;           
  HPS_USB_STP       : out  std_logic;           

--///////// KEY /////////
    KEY         : in std_logic_vector(3 downto 0) ; --reset active low
--      input       [1:0]  KEY,

--///////// LED /////////
--      output      [7:0]  LED,
    LED         : out std_logic_vector(7 downto 0);

--///////// SW /////////
--      input       [3:0]  SW
    SW          : in std_logic_vector(3 downto 0) ; 

--!///////// X Axis /////////
	osl_outX1A		: out std_logic;
	osl_outX1B		: out std_logic;
	osl_outX2A		: out std_logic;
	osl_outX2B		: out std_logic;
	osl_slice_tick		: out std_logic;	--!
--! testing
    osl_PerfTest  : out std_logic
    );
end entity c5_1701;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture RTL of c5_1701 is
--version
signal slv16_FpgaVersion    : std_logic_vector(15 downto 0);
signal slv16_FpgaSubVersion : std_logic_vector(15 downto 0);
signal slv32_FpgaVersion    : std_logic_vector(31 downto 0);

-- clocks
signal sl_NiosClk        : STD_LOGIC; -- clock 128 MHz
signal sl_clk50Mhz       : STD_LOGIC;   -- clock 50 MHz
signal slv4_keys         : std_logic_vector(3 downto 0);
signal slv4_switch       : std_logic_vector(3 downto 0);
signal sl_Reset          : STD_LOGIC;
signal sl_ResetN         : STD_LOGIC;
signal sl_OutResetN      : STD_LOGIC;
signal slv16_IrqAck      : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal slv32_IrqAck      : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal slv16_TestPoints  : STD_LOGIC_VECTOR(15 DOWNTO 0);


-------------------------------------------------------------
-- Status, mode
signal uSens2Buf_slv32_BufStatus   : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal uSens2Buf_sl_StatusValid : std_logic;
signal uH2flw_slv32_Modus    : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal uH2flw_sl_ModusValid  : std_logic;
signal uModeCtrl_slv4_Modus       : std_logic_vector(3 downto 0);
signal slv32_Modus   : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal slv32_TimerReload : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal uSens2Buf_slv32_ReadBufsNr   : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal slv32_Status   : STD_LOGIC_VECTOR(31 DOWNTO 0);--still TODO not used

-------------------------------------------------------------
-- Mode
signal locked_sig : std_logic;
signal areset_sig : std_logic;

-------------------------------------------------------------
-- h2f_lw bus
signal sl_h2f_lw_bus_acknowledge   : std_logic; -- acknowledge
signal sl_h2f_lw_bus_irq           : std_logic; -- irq
signal slv10_h2f_lw_bus_address     : std_logic_vector(9 downto 0); -- address
signal sl_h2f_lw_bus_bus_enable    : std_logic; -- bus_enable
signal slv4_h2f_lw_bus_byte_enable : std_logic_vector(3 downto 0); -- byte_enable
signal sl_h2f_lw_bus_rw            : std_logic; -- rw
signal slv32_h2f_lw_bus_write_data : std_logic_vector(31 downto 0); -- write_data
signal slv32_h2f_lw_bus_read_data  : std_logic_vector(31 downto 0);
signal uH2flw_slv32_TimerReload : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal uH2flw_sl_TimerRelValid  : std_logic;
signal uH2flw_slv32_ReadLock      : std_logic_vector(31 downto 0);

signal uH2flw_slv32_DACOffset : std_logic_vector(31 downto 0); 
signal uH2flw_sl_DacOffsetValid :  std_logic;
signal sl_ResMemSRdValid           : std_logic;
--signal sl_ResMemBRdValid           : std_logic;
signal uH2flw_slv32_ADCDelay : std_logic_vector(31 downto 0); 
signal un_ADCDelay : unsigned(15 downto 0); 
signal uH2flw_sl_AdcDelayValid : std_logic;

-- motion signals
	signal n16_outValue 		: signed (15 downto 0) := x"0000";
	signal n16_Value 			: signed (15 downto 0) :=  x"0080";
	signal sl_output1A		: std_logic;
	signal sl_output1B		: std_logic;
	signal sl_output2A		: std_logic;
	signal sl_output2B		: std_logic;
	signal sl_slice_tick		: std_logic;	--!

	signal	uIssp_n16_outputVector : signed (15 downto 0);

	signal uST_sl_sliceTick : std_logic;
	signal sl_step : std_logic;
	signal isl_extStep : std_logic;
	signal sl_extStep_m : std_logic;
	signal isl_extStepEnable : std_logic;
	signal isl_extDir : std_logic;
	signal sl_extStepEnable : std_logic;
	signal sl_extDir : std_logic;
	signal uISSP_sl_mux : std_logic;
-- signals io for the h2f:
	signal uH2flw_n16_rampValue  	: signed (15 downto 0);
	signal uH2flw_n32_periodCount	: signed (31 downto 0);
	signal	in16_inputVector : signed (15 downto 0);
	signal	n16_inputVector : signed (15 downto 0);
	signal uAxis_oslv6_PosModulo : std_logic_vector(5 downto 0);
	signal uH2flw_sl_periodValid : std_logic;
	signal uH2flw_sl_rampValid : std_logic;

begin
-------------------------------------------------------------
-- version
-------------------------------------------------------------


-------------------------------------------------------------
-- IOs global pins
-------------------------------------------------------------
sl_Reset     <= not KEY(0);
sl_ResetN    <= KEY(0);
areset_sig   <= sl_Reset;
sl_clk50Mhz  <= CLOCK_50;
--TODO: next line has no sense 
osl_PerfTest <= '1';-- when (uH2flw_slv32_TimerReload = uH2flw_slv32_Modus) else '0'; --slv16_TestPoints(15);
slv4_keys    <= KEY;
slv4_switch <= SW;
    -- LED, SW direct from H2F    
--  slv4_Modus <= uH2flw_slv32_Modus(3 downto 0);
--u0 : component soc_search_non_jtag
u0 : soc_jtag_irq
port map (
    button_pio_external_connection_export => slv4_keys,--KEY,--CONNECTED_TO_button_pio_external_connection_export, -- button_pio_external_connection.export
    clk_clk                               => CLOCK_50,--CONNECTED_TO_clk_clk,                               --                            clk.clk
    dipsw_pio_external_connection_export  => SW,--CONNECTED_TO_dipsw_pio_external_connection_export,  --  dipsw_pio_external_connection.export

    external_lw_bus_acknowledge => sl_h2f_lw_bus_acknowledge   ,--CONNECTED_TO_external_lw_bus_acknowledge,           --                external_lw_bus.acknowledge
    external_lw_bus_irq         => sl_h2f_lw_bus_irq           ,--CONNECTED_TO_external_lw_bus_irq,                   --                               .irq
    external_lw_bus_address     => slv10_h2f_lw_bus_address     ,--CONNECTED_TO_external_lw_bus_address,               --                               .address
    external_lw_bus_bus_enable  => sl_h2f_lw_bus_bus_enable    ,--CONNECTED_TO_external_lw_bus_bus_enable,            --                               .bus_enable
    external_lw_bus_byte_enable => slv4_h2f_lw_bus_byte_enable ,--CONNECTED_TO_external_lw_bus_byte_enable,           --                               .byte_enable
    external_lw_bus_rw          => sl_h2f_lw_bus_rw            ,--CONNECTED_TO_external_lw_bus_rw,                    --                               .rw
    external_lw_bus_write_data  => slv32_h2f_lw_bus_write_data ,--CONNECTED_TO_external_lw_bus_write_data,            --                               .write_data
    external_lw_bus_read_data   => slv32_h2f_lw_bus_read_data,  --CONNECTED_TO_external_lw_bus_read_data              --                               .read_data

    hps_0_h2f_reset_reset_n               => sl_OutResetN,--CONNECTED_TO_hps_0_h2f_reset_reset_n,               --                hps_0_h2f_reset.reset_n

    hps_0_hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK,    --CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CLK, --                   hps_0_hps_io.hps_io_emac1_inst_TX_CLK
    hps_0_hps_io_hps_io_emac1_inst_TXD0   => HPS_ENET_TX_DATA(0),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD0,   --                               .hps_io_emac1_inst_TXD0
    hps_0_hps_io_hps_io_emac1_inst_TXD1   => HPS_ENET_TX_DATA(1),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD1,   --                               .hps_io_emac1_inst_TXD1
    hps_0_hps_io_hps_io_emac1_inst_TXD2   => HPS_ENET_TX_DATA(2),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD2,   --                               .hps_io_emac1_inst_TXD2
    hps_0_hps_io_hps_io_emac1_inst_TXD3   => HPS_ENET_TX_DATA(3),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD3,   --                               .hps_io_emac1_inst_TXD3
    hps_0_hps_io_hps_io_emac1_inst_RXD0   => HPS_ENET_RX_DATA(0),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD0,   --                               .hps_io_emac1_inst_RXD0
    hps_0_hps_io_hps_io_emac1_inst_MDIO   => HPS_ENET_MDIO,      --CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDIO,   --                               .hps_io_emac1_inst_MDIO
    hps_0_hps_io_hps_io_emac1_inst_MDC    => HPS_ENET_MDC ,      --CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDC,    --                               .hps_io_emac1_inst_MDC
    hps_0_hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,      --CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CTL, --                               .hps_io_emac1_inst_RX_CTL
    hps_0_hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,      --CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CTL, --                               .hps_io_emac1_inst_TX_CTL
    hps_0_hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,     --CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CLK, --                               .hps_io_emac1_inst_RX_CLK
    hps_0_hps_io_hps_io_emac1_inst_RXD1   => HPS_ENET_RX_DATA(1),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD1,   --                               .hps_io_emac1_inst_RXD1
    hps_0_hps_io_hps_io_emac1_inst_RXD2   => HPS_ENET_RX_DATA(2),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD2,   --                               .hps_io_emac1_inst_RXD2
    hps_0_hps_io_hps_io_emac1_inst_RXD3   => HPS_ENET_RX_DATA(3),--CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD3,   --                               .hps_io_emac1_inst_RXD3
    hps_0_hps_io_hps_io_sdio_inst_CMD     => HPS_SD_CMD    ,     --CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CMD,     --                               .hps_io_sdio_inst_CMD
    hps_0_hps_io_hps_io_sdio_inst_D0      => HPS_SD_DATA(0)     ,--CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D0,      --                               .hps_io_sdio_inst_D0
    hps_0_hps_io_hps_io_sdio_inst_D1      => HPS_SD_DATA(1)     ,--CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D1,      --                               .hps_io_sdio_inst_D1
    hps_0_hps_io_hps_io_sdio_inst_CLK     => HPS_SD_CLK   ,      --CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CLK,     --                               .hps_io_sdio_inst_CLK
    hps_0_hps_io_hps_io_sdio_inst_D2      => HPS_SD_DATA(2)     ,--CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D2,      --                               .hps_io_sdio_inst_D2
    hps_0_hps_io_hps_io_sdio_inst_D3      => HPS_SD_DATA(3)     ,--CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D3,      --                               .hps_io_sdio_inst_D3
--      //HPS USB           
    hps_0_hps_io_hps_io_usb1_inst_D0      => HPS_USB_DATA(0)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D0,      --                               .hps_io_usb1_inst_D0
    hps_0_hps_io_hps_io_usb1_inst_D1      => HPS_USB_DATA(1)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D1,      --                               .hps_io_usb1_inst_D1
    hps_0_hps_io_hps_io_usb1_inst_D2      => HPS_USB_DATA(2)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D2,      --                               .hps_io_usb1_inst_D2
    hps_0_hps_io_hps_io_usb1_inst_D3      => HPS_USB_DATA(3)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D3,      --                               .hps_io_usb1_inst_D3
    hps_0_hps_io_hps_io_usb1_inst_D4      => HPS_USB_DATA(4)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D4,      --                               .hps_io_usb1_inst_D4
    hps_0_hps_io_hps_io_usb1_inst_D5      => HPS_USB_DATA(5)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D5,      --                               .hps_io_usb1_inst_D5
    hps_0_hps_io_hps_io_usb1_inst_D6      => HPS_USB_DATA(6)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D6,      --                               .hps_io_usb1_inst_D6
    hps_0_hps_io_hps_io_usb1_inst_D7      => HPS_USB_DATA(7)    ,--CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D7,      --                               .hps_io_usb1_inst_D7
    hps_0_hps_io_hps_io_usb1_inst_CLK     => HPS_USB_CLKOUT    , --CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_CLK,     --                               .hps_io_usb1_inst_CLK
    hps_0_hps_io_hps_io_usb1_inst_STP     => HPS_USB_STP    ,    --CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_STP,     --                               .hps_io_usb1_inst_STP
    hps_0_hps_io_hps_io_usb1_inst_DIR     => HPS_USB_DIR    ,    --CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_DIR,     --                               .hps_io_usb1_inst_DIR
    hps_0_hps_io_hps_io_usb1_inst_NXT     => HPS_USB_NXT    ,    --CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_NXT,     --                               .hps_io_usb1_inst_NXT
--        //HPS SPI         
    hps_0_hps_io_hps_io_spim1_inst_CLK    => HPS_SPIM_CLK  , --  -CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_CLK,    --                               .hps_io_spim1_inst_CLK
    hps_0_hps_io_hps_io_spim1_inst_MOSI   => HPS_SPIM_MOSI , --  -CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MOSI,   --                               .hps_io_spim1_inst_MOSI
    hps_0_hps_io_hps_io_spim1_inst_MISO   => HPS_SPIM_MISO , --  -CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MISO,   --                               .hps_io_spim1_inst_MISO
    hps_0_hps_io_hps_io_spim1_inst_SS0    => HPS_SPIM_SS   , --  -CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_SS0,    --                               .hps_io_spim1_inst_SS0
--        //HPS UART                                          --  -
    hps_0_hps_io_hps_io_uart0_inst_RX     => HPS_UART_RX   , --  -CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_RX,     --                               .hps_io_uart0_inst_RX
    hps_0_hps_io_hps_io_uart0_inst_TX     => HPS_UART_TX   , --  -CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_TX,     --                               .hps_io_uart0_inst_TX
--        //HPS I2C1                                          -- 
    hps_0_hps_io_hps_io_i2c0_inst_SDA     => HPS_I2C0_SDAT  ,--  -CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SDA,     --                               .hps_io_i2c0_inst_SDA
    hps_0_hps_io_hps_io_i2c0_inst_SCL     => HPS_I2C0_SCLK  ,--  -CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SCL,     --                               .hps_io_i2c0_inst_SCL
--        //HPS I2C1                                          --  -
    hps_0_hps_io_hps_io_i2c1_inst_SDA     => HPS_I2C1_SDAT  ,--  -CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SDA,     --                               .hps_io_i2c1_inst_SDA
    hps_0_hps_io_hps_io_i2c1_inst_SCL     => HPS_I2C1_SCLK  ,--  -CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SCL,     --                               .hps_io_i2c1_inst_SCL
--        //GPIO                                              --  -
    hps_0_hps_io_hps_io_gpio_inst_GPIO09  => HPS_CONV_USB_N ,--  -CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO09,  --                               .hps_io_gpio_inst_GPIO09
    hps_0_hps_io_hps_io_gpio_inst_GPIO35  => HPS_ENET_INT_N ,--  -CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO35,  --                               .hps_io_gpio_inst_GPIO35
    hps_0_hps_io_hps_io_gpio_inst_GPIO40  => HPS_LTC_GPIO   ,--  -CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO40,  --                               .hps_io_gpio_inst_GPIO40
    hps_0_hps_io_hps_io_gpio_inst_GPIO53  => HPS_LED   ,   --  -CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO53,  --                               .hps_io_gpio_inst_GPIO53
    hps_0_hps_io_hps_io_gpio_inst_GPIO54  => HPS_KEY   ,   --  -CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO54,  --                               .hps_io_gpio_inst_GPIO54
    hps_0_hps_io_hps_io_gpio_inst_GPIO61  => HPS_GSENSOR_INT ,--, -CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO61,  --                               .hps_io_gpio_inst_GPIO61
                                             
    led_pio_external_connection_export    => LED, --CONNECTED_TO_led_pio_external_connection_export,    --    led_pio_external_connection.export
    memory_mem_a            => HPS_DDR3_ADDR,   --,CONNECTED_TO_memory_mem_a,                          --                         memory.mem_a
    memory_mem_ba           => HPS_DDR3_BA,     --,CONNECTED_TO_memory_mem_ba,                         --                               .mem_ba
    memory_mem_ck           => HPS_DDR3_CK_P,   --,CONNECTED_TO_memory_mem_ck,                         --                               .mem_ck
    memory_mem_ck_n         => HPS_DDR3_CK_N,   --,CONNECTED_TO_memory_mem_ck_n,                       --                               .mem_ck_n
    memory_mem_cke          => HPS_DDR3_CKE,    --,CONNECTED_TO_memory_mem_cke,                        --                               .mem_cke
    memory_mem_cs_n         => HPS_DDR3_CS_N,   --,CONNECTED_TO_memory_mem_cs_n,                       --                               .mem_cs_n
    memory_mem_ras_n        => HPS_DDR3_RAS_N,  --,CONNECTED_TO_memory_mem_ras_n,                      --                               .mem_ras_n
    memory_mem_cas_n        => HPS_DDR3_CAS_N,  --,CONNECTED_TO_memory_mem_cas_n,                      --                               .mem_cas_n
    memory_mem_we_n         => HPS_DDR3_WE_N,   --,CONNECTED_TO_memory_mem_we_n,                       --                               .mem_we_n
    memory_mem_reset_n      => HPS_DDR3_RESET_N,--,CONNECTED_TO_memory_mem_reset_n,                    --                               .mem_reset_n
    memory_mem_dq           => HPS_DDR3_DQ,     --,CONNECTED_TO_memory_mem_dq,                         --                               .mem_dq
    memory_mem_dqs          => HPS_DDR3_DQS_P,  --,CONNECTED_TO_memory_mem_dqs,                        --                               .mem_dqs
    memory_mem_dqs_n        => HPS_DDR3_DQS_N,  --,CONNECTED_TO_memory_mem_dqs_n,                      --                               .mem_dqs_n
    memory_mem_odt          => HPS_DDR3_ODT,    --,CONNECTED_TO_memory_mem_odt,                        --                               .mem_odt
    memory_mem_dm           => HPS_DDR3_DM,     --,CONNECTED_TO_memory_mem_dm,                         --                               .mem_dm
    memory_oct_rzqin        => HPS_DDR3_RZQ,    --,CONNECTED_TO_memory_oct_rzqin,                      --                               .oct_rzqin

    reset_reset_n           => sl_ResetN --CONNECTED_TO_reset_reset_n                          --                          reset.reset_n
);


uH2flw : h2flw_interface
port map
(
    isl_clk50Mhz     => sl_clk50Mhz          ,--in std_logic;
    isl_rst          => sl_reset          ,--in std_logic;
  -- h2f-lw       
    osl_external_lw_bus_acknowledge     => sl_h2f_lw_bus_acknowledge   ,--: out std_logic;             -- acknowledge
    osl_external_lw_bus_irq             => sl_h2f_lw_bus_irq           ,--: out std_logic;             -- irq
    islv10_external_lw_bus_address       => slv10_h2f_lw_bus_address     ,--: in  std_logic_vector(6 downto 0);                     -- address
    isl_external_lw_bus_bus_enable      => sl_h2f_lw_bus_bus_enable    ,--: in  std_logic;                                        -- bus_enable
    islv4_external_lw_bus_byte_enable   => slv4_h2f_lw_bus_byte_enable ,--: in  std_logic_vector(3 downto 0);                     -- byte_enable
    isl_external_lw_bus_rw              => sl_h2f_lw_bus_rw            ,--: in  std_logic;                                        -- rw
    islv32_external_lw_bus_write_data   => slv32_h2f_lw_bus_write_data ,--: in  std_logic_vector(31 downto 0);                    -- write_data
    oslv32_external_lw_bus_read_data    => slv32_h2f_lw_bus_read_data  ,--: out std_logic_vector(31 downto 0); -- read_data
-- outputs
	on32_periodCount	=> uH2flw_n32_periodCount,--: out  signed (31 downto 0);
	osl_periodValid		=> uH2flw_sl_periodValid,--: out std_logic;
	on16_rampValue  	=> uH2flw_n16_rampValue,--: out signed (15 downto 0);
	osl_rampValid		=> uH2flw_sl_rampValid,--	: out std_logic;
-- inputs
	islv6_PosModulo		=> uAxis_oslv6_PosModulo,--: in std_logic_vector(5 downto 0);

    islv32_Version     => slv32_FpgaVersion,
    islv32_Status      => slv32_Status      ,--: in  std_logic_vector(31 downto 0); 
    isl_StatusValid    => uSens2Buf_sl_StatusValid    --: in  std_logic
 );
-- outputs to control from h2f
--uH2flw_n32_periodCount	<= x"004C4B40";--05-000-000 clocks = 100ms
--uH2flw_n16_rampValue  	<= x"0040";
-- inputs for h2f
	-- uAxis_oslv6_PosModulo;--: out std_logic_vector(5 downto 0);

uM : monoshot 
port map     (
    isl_clk        => sl_clk50MHz,--: in std_logic; --! master clock 50 MHz
    isl_rst             => sl_Reset,--: in std_logic; --! master reset active high
    isl_input           => isl_extStep,--: in std_logic; --!
    osl_outputMono      => sl_extStep_m--: out std_logic --! pwm output
);        

uRDir : deflipflop
port map
(
    isl_clock   => sl_clk50MHz,--: in STD_LOGIC;
    isl_d       => isl_extDir,--: in STD_LOGIC;
    isl_ena     => '1',--: in STD_LOGIC;
    isl_reset   => sl_Reset,--: in STD_LOGIC;
    osl_out     => sl_extDir--: out STD_LOGIC
);

uREna : deflipflop
port map
(
    isl_clock   => sl_clk50MHz,--: in STD_LOGIC;
    isl_d       => isl_extStepEnable,--: in STD_LOGIC;
    isl_ena     => '1',--: in STD_LOGIC;
    isl_reset   => sl_Reset,--: in STD_LOGIC;
    osl_out     => sl_extStepEnable--: out STD_LOGIC
);

--!
uST : slice_tick_gen
generic map(
	bISSP => FALSE,
	bModelSim => FALSE
)
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;	--!
	isl_rst 			=> sl_Reset,--: in std_logic;	--!
	in32_periodCount 	=> uH2flw_n32_periodCount,--: in std_logic;
	osl_slice_tick		=> uST_sl_sliceTick--: out integer	--!
);


U_VELOCITY_JTAG : if (bISSP = TRUE and bModelSim = FALSE) generate
begin
uVelIssp : velocity_issp
port map (
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	osl_mux				=> uISSP_sl_mux,
	in16_inputVector 	=> in16_inputVector,--: in signed (15 downto 0);
	on16_outputVector 	=> uIssp_n16_outputVector--: out signed (15 downto 0);
);

n16_inputVector <= uIssp_n16_outputVector when (uISSP_sl_mux = '1') else
				in16_inputVector;
end generate;


uNISSP : if (bISSP = FALSE) generate
begin
	n16_inputVector <= in16_inputVector;
	uISSP_sl_mux <= '0';
end generate;	

--!
uAxis : one_axis
generic map(
	bISSP => FALSE,
	bModelSim => FALSE
)
port map
(
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	isl_sliceTick 		=> uST_sl_sliceTick,--in std_logic; --! 50 ms tick for velocity changes
	in16_inputVector 	=> n16_inputVector,--in signed (15 downto 0);--! input velocity 15 bits + sign
	in16_rampValue  	=> uH2flw_n16_rampValue,--in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
	isl_extStep			=> sl_extStep_m,--: in std_logic;
	isl_extDir			=> sl_extDir,--: in std_logic;
	isl_extStepEnable	=> sl_extStepEnable,--: in std_logic;
	oslv6_PosModulo 	=> uAxis_oslv6_PosModulo,--: out std_logic_vector(5 downto 0);
	osl_output1A		=> sl_output1A ,--	: out std_logic;
	osl_output1B		=> sl_output1B ,--	: out std_logic;
	osl_output2A		=> sl_output2A ,--	: out std_logic;
	osl_output2B		=> sl_output2B --	: out std_logic
);


end architecture RTL;
