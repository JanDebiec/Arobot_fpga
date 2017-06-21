----------------------------------------------------------------------
--! @file  
--! @brief top file for c4 arobot
--! interface SPI
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
Library work;           
	use work.arobot_constant_pkg.all;
	use work.arobot_component_pkg.all;
    use work.flipflop_d1_pkg.all;
    use work.monoshot_pkg.all;
    use work.spi_receiver_pkg.all;
    use work.spi_transmitter_pkg.all;
    use work.spi_output_pkg.all;
    use work.convPos2Pwm_pkg.all;
    use work.slice_tick_gen_pkg.all;
    use work.pwm_pulse_pkg.all;
    use work.convVel2Pulse_pkg.all;
    use work.convPulse2Pos_pkg.all;
    use work.position_issp_pkg.all;
    use work.velocity_issp_pkg.all;
    use work.one_axis_pkg.all;
    use work.uart_pkg.all;
    use work.cmdVel_parser_pkg.all;
    use work.version_pkg.all;

--!
entity c4_1703 is
    generic(
			bModelSim : boolean := FALSE;
			bISSP     : boolean := FALSE
--            bISSP     : boolean := TRUE
--			bModelSim : boolean;
--			bISSP     : boolean
    );
	port (
		CLOCK_50 	: in std_logic;
		SW 		    : in std_logic_vector(3 downto 0) ; 
		KEY 		: in std_logic_vector(1 downto 0) ; --reset active low
--		GPIO_2 : out std_logic_vector (7 downto 0);
		GPIO_0 	: out std_logic_vector(31 downto 0);
        isl_SpiClk  : in std_logic;
        isl_SpiCSn  : in std_logic;
        isl_mosi    : in std_logic;--! input to SPI, 
        osl_miso    : out std_logic;--! output to SPI,
--!///////// Left Axis /////////
    osl_outL1A      : out std_logic;
    osl_outL1B      : out std_logic;
    osl_outL2A      : out std_logic;
    osl_outL2B      : out std_logic;
--!///////// Right Axis /////////
    osl_outR1A      : out std_logic;
    osl_outR1B      : out std_logic;
    osl_outR2A      : out std_logic;
    osl_outR2B      : out std_logic;
    osl_slice_tick  : out std_logic;    
--!
    isl_SerialRx    : in std_logic; 
    osl_SerialTx    : out std_logic 
	);
end entity c4_1703;

architecture RTL of c4_1703 is
	signal sl_clk50MHz  		: STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 			: STD_LOGIC := '0';
	signal slv4_switch       : std_logic_vector(3 downto 0);
	
	signal n16_rampValue  	: signed (15 downto 0);
	signal n16_outValue 		: signed (15 downto 0);
	signal n16_Value 			: signed (15 downto 0);
	signal sl_output1A		: std_logic;
	signal sl_output1B		: std_logic;
	signal sl_output2A		: std_logic;
	signal sl_output2B		: std_logic;
	signal n32_periodCount	: signed (31 downto 0) := x"004C4B40";--05-000-000 clocks = 100ms
	signal sl_slice_tick		: std_logic;	--!

	signal n16_inputVelocity : signed (15 downto 0);
	signal	sl_PwmPeriodPulse 		: std_logic;
	signal	u16_loopCounter : integer;
	signal	n16_inputVector : signed (15 downto 0);
	signal	n16_outputVector : signed (15 downto 0);
	signal	slv6_PosModulo : std_logic_vector(5 downto 0) := "011010";
	signal	slv6_InputIndexModulo : std_logic_vector(5 downto 0); 
	signal	slv6_OutputValueModulo : std_logic_vector(5 downto 0); 
	
	signal	slv6_InputIndexIssp : std_logic_vector(5 downto 0);
	signal sl_direction : std_logic;
--	signal sl_sliceTick : std_logic;
	signal sl_step : std_logic;
    signal uST_sl_sliceTick : std_logic;
	
	signal uAxisL_sl_output1A       : std_logic;
    signal uAxisL_sl_output1B       : std_logic;
    signal uAxisL_sl_output2A       : std_logic;
    signal uAxisL_sl_output2B       : std_logic;
    signal uAxisR_sl_output1A       : std_logic;
    signal uAxisR_sl_output1B       : std_logic;
    signal uAxisR_sl_output2A       : std_logic;
    signal uAxisR_sl_output2B       : std_logic;
-- SPI
	signal sl_SpiClk : STD_LOGIC;     -- clock 30 - 128 MHz
    signal sl_miso         :  std_logic;
    signal sl_dataReq      : std_logic;
    signal sl_TxReady         : std_logic;
    signal sl_FirstByteValid    : std_logic;
    signal sl_TxActive : std_logic := '0';
    signal sl_TxStart : std_logic := '0';
    signal sl_mosi         :  std_logic;
    signal sl_RxActive     : std_logic;
    signal uSpiRx_sl_validRxData    : std_logic;
    signal uSpiRx_slv8_RxData       : std_logic_vector(7 downto 0);
    signal slv8_command : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal slv11_OutWrAddr : STD_LOGIC_VECTOR (10 DOWNTO 0);
    signal sl_SysClkEna : STD_LOGIC;
    signal sl_OutWrEna : STD_LOGIC;
    signal slv8_WrData:  STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal slv8_status : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
-- axis
    signal  u8_microResProStepL : unsigned(7 downto 0);
    signal  u8_microResProStepR : unsigned(7 downto 0);
    
-- config spi or uart
    signal sl_configSpiOrUart : std_logic; -- high h2f, low uart
-- h2f
    signal uSpi_sl_inputValid : std_logic;
    signal  uSpi_n16_inputVectorL : signed (15 downto 0);
    signal  uSpi_n16_inputVectorR : signed (15 downto 0);
-- uart
    signal uRx_sl_inputValid : std_logic;
    signal  uRx_n16_inputVectorR : signed (15 downto 0);
    signal  uRx_n16_inputVectorL : signed (15 downto 0);
-- input for axis
    signal  inp_n16_inputVectorL : signed (15 downto 0); -- after input mux
    signal  IsspOut_n16_inputVectorL : signed (15 downto 0); -- after Issp
    signal  n16_inputVectorL : signed (15 downto 0);-- input to axis
    signal  n16_inputVectorR : signed (15 downto 0);
    signal uISSP_sl_mux : std_logic;
    
-- uart
    -- USER DATA INPUT INTERFACE
    signal  data_in     : std_logic_vector(7 downto 0);
    signal  data_send   : std_logic; -- when DATA_SEND = 1, data on DATA_IN will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    signal  uUart_busy        : std_logic; -- when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    -- USER DATA OUTPUT INTERFACE
    signal  uUart_data_out    : std_logic_vector(7 downto 0);
    signal  uUart_data_vld    : std_logic; -- when DATA_VLD = 1, data on DATA_OUT are valid
    signal  uUart_frame_error : std_logic;  -- when FRAME_ERROR = 1, stop bit was invalid, current and next data may be invalid
	-- signals for feedback
	signal uAxisL_oslv6_PosModulo : std_logic_vector(5 downto 0);
    signal uAxisR_oslv6_PosModulo : std_logic_vector(5 downto 0);

    signal  slv8_RxByte    : std_logic_vector(7 downto 0);
    signal  sl_RxByteValid    : std_logic;
	
	
begin

--GPIO_0(31 downto 16) <= slv16_testValue;
sl_clk50MHz <= CLOCK_50;
sl_Reset <= not (KEY(0));
    sl_SpiClk <= isl_SpiClk;

    osl_outL1A  <= uAxisL_sl_output1A;
    osl_outL1B  <= uAxisL_sl_output1B;
    osl_outL2A  <= uAxisL_sl_output2A;
    osl_outL2B  <= uAxisL_sl_output2B;
    osl_outR1A  <= uAxisR_sl_output1A;
    osl_outR1B  <= uAxisR_sl_output1B;
    osl_outR2A  <= uAxisR_sl_output2A;
    osl_outR2B  <= uAxisR_sl_output2B;
    osl_slice_tick <= uST_sl_sliceTick;
--!

pRamp : process (
   all 
)begin
    if (sl_Reset = '1') then
        n16_rampValue <= x"0040";
--    elsif (rising_edge(sl_clk50Mhz)) then
--        if (uH2flw_sl_rampValid = '1') then
--        n16_rampValue <= uH2flw_n16_rampValue;
--        end if;
    END IF;
end process;

pMicroL : process (
   all 
)begin
    if (sl_Reset = '1') then
        u8_microResProStepL <= x"10";
--    elsif (rising_edge(sl_clk50Mhz)) then
--        if (uH2flw_sl_microStepValid = '1') then
--        u8_microResProStepL <= uH2flw_u8_microResProStepL;
--        end if;
    END IF;
end process;

pMicroR : process (
   all 
)begin
    if (sl_Reset = '1') then
        u8_microResProStepR <= x"10";
--    elsif (rising_edge(sl_clk50Mhz)) then
--        if (uH2flw_sl_microStepValid = '1') then
--        u8_microResProStepR <= uH2flw_u8_microResProStepR;
--        end if;
    END IF;
end process;


--!
uST : slice_tick_gen
generic map(
    bISSP => FALSE,
    bModelSim => FALSE
)
port map
(
    isl_clk50Mhz        => sl_clk50MHz,--: in std_logic;    --!
    isl_rst             => sl_Reset,--: in std_logic;   --!
    in32_periodCount    => n32_periodCount,--: in std_logic;
    osl_slice_tick      => uST_sl_sliceTick--: out integer  --!
);


uVel_JTAG : if (bISSP = TRUE and bModelSim = FALSE) generate
begin
uISSP : velocity_issp
port map (
	isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
	isl_rst 			=> sl_Reset,--: in std_logic;
	in16_inputVector 	=> inp_n16_inputVectorL,--: in signed (15 downto 0);
	osl_mux            => uISSP_sl_mux,
	on16_outputVector 	=> IsspOut_n16_inputVectorL--: out signed (15 downto 0);
);
n16_inputVectorL <= IsspOut_n16_inputVectorL when (uISSP_sl_mux = '1') else
                inp_n16_inputVectorL;
end generate;

uNISSP : if (bISSP = FALSE) generate
begin
    n16_inputVectorL <= inp_n16_inputVectorL;
    uISSP_sl_mux <= '0';
end generate;   


slv4_switch <= SW;
sl_configSpiOrUart <= slv4_switch(0);



pInputL : process (
   all 
)begin
    if (sl_Reset = '1') then
        inp_n16_inputVectorL <= x"0000";
    elsif (rising_edge(sl_clk50Mhz)) then
        if uRx_sl_inputValid = '1' then
            inp_n16_inputVectorL <= uRx_n16_inputVectorL;
        end if;
    END IF;
end process;

pInputR : process (
   all 
)begin
    if (sl_Reset = '1') then
        n16_inputVectorR <= x"0000";
    elsif (rising_edge(sl_clk50Mhz)) then
        if uRx_sl_inputValid = '1' then
            n16_inputVectorR <= uRx_n16_inputVectorR;
        end if;
    END IF;
end process;

uAxisL : one_axis
generic map(
    bISSP => FALSE,
    bModelSim => FALSE
)
port map
(
    isl_clk50Mhz        => sl_clk50MHz,--: in std_logic;
    isl_rst             => sl_Reset,--: in std_logic;
    isl_sliceTick       => uST_sl_sliceTick,--in std_logic; --! 50 ms tick for velocity changes
    in16_inputVector    => n16_inputVectorL,--in signed (15 downto 0);--! input velocity 15 bits + sign
    in16_rampValue      => n16_rampValue,--in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
    iu8_microResProStep => u8_microResProStepL,-- in unsigned(7 downto 0);
    oslv6_PosModulo     => uAxisL_oslv6_PosModulo,--: out std_logic_vector(5 downto 0);
    osl_output1A        => uAxisL_sl_output1A ,--   : out std_logic;
    osl_output1B        => uAxisL_sl_output1B ,--   : out std_logic;
    osl_output2A        => uAxisL_sl_output2A ,--   : out std_logic;
    osl_output2B        => uAxisL_sl_output2B --    : out std_logic
);

uAxisR : one_axis
generic map(
    bISSP => FALSE,
    bModelSim => FALSE
)
port map
(
    isl_clk50Mhz        => sl_clk50MHz,--: in std_logic;
    isl_rst             => sl_Reset,--: in std_logic;
    isl_sliceTick       => uST_sl_sliceTick,--in std_logic; --! 50 ms tick for velocity changes
    in16_inputVector    => n16_inputVectorR,--in signed (15 downto 0);--! input velocity 15 bits + sign
    in16_rampValue      => n16_rampValue,--in signed (15 downto 0);--! ramp, allowed changes of velocity per tick
    iu8_microResProStep => u8_microResProStepR,-- in unsigned(7 downto 0);
    oslv6_PosModulo     => uAxisR_oslv6_PosModulo,--: out std_logic_vector(5 downto 0);
    osl_output1A        => uAxisR_sl_output1A ,--   : out std_logic;
    osl_output1B        => uAxisR_sl_output1B ,--   : out std_logic;
    osl_output2A        => uAxisR_sl_output2A ,--   : out std_logic;
    osl_output2B        => uAxisR_sl_output2B --    : out std_logic
);

uSpiRx : spi_receiver
port map
(
--! signals on OutputCLock domain
    isl_SpiClk          => sl_SpiClk,
    isl_reset           => sl_Reset,--: in std_logic;
    isl_mosi            => isl_mosi,--: in std_logic;
    isl_RxActive        => sl_RxActive,--: in std_logic;
    osl_validData       => uSpiRx_sl_validRxData,--: out std_logic;
    oslv8_Data          => uSpiRx_slv8_RxData--: out std_logic_vector(7 downto 0)
);

uSpiTx : spi_output
port map
(
--! signals on OutputCLock domain
    isl_SpiClk       => sl_SpiClk,
    isl_TxActive     => sl_TxActive,--: in std_logic;
    osl_miso         => osl_miso,--,: out std_logic;
-- system side
    isl_SystemClock  => sl_clk50MHz,--: in STD_LOGIC ;
    isl_reset        => sl_reset,--: in std_logic;
    islv8_status     => slv8_status,--: STD_LOGIC_VECTOR (7 DOWNTO 0);
    islv8_command    => slv8_command--: STD_LOGIC_VECTOR (7 DOWNTO 0);
--    islv11_OutWrAddr => slv11_OutWrAddr,--: in STD_LOGIC_VECTOR (10 DOWNTO 0);
--    isl_SysClkEna    => sl_SysClkEna,--: in STD_LOGIC;
--    isl_OutWrEna     => sl_OutWrEna,--: in STD_LOGIC;
--    islv8_WrData     => slv8_WrData--: in STD_LOGIC_VECTOR (7 DOWNTO 0)
);

uRxCmd : cmdVel_parser
port map
(
    isl_clk50Mhz        => sl_clk50MHz,--: in std_logic;
    isl_rst             => sl_Reset,--: in std_logic;
    isl_inByteValid     => sl_RxByteValid,--: in std_logic;
    islv8_byteValue     => slv8_RxByte,--: in std_logic_vector(7 downto 0);
    oslv_shortA         => uRx_n16_inputVectorL,--: out signed(15 downto 0);
    oslv_shortB         => uRx_n16_inputVectorR,--: out signed(15 downto 0);
    osl_outputValid     => uRx_sl_inputValid--: out std_logic
);        

uUart: UART
generic map (
    CLK_FREQ    => 50e6,
--    BAUD_RATE   => 115200,
    BAUD_RATE   => 9600,
    PARITY_BIT  => "none"
)
port map (
    CLK         => sl_clk50MHz,
    RST         => sl_Reset,
    -- UART INTERFACE
    UART_TXD    => osl_SerialTx,
    UART_RXD    => isl_SerialRx,
    -- USER DATA INPUT INTERFACE
    DATA_OUT    => uUart_data_out,
    DATA_VLD    => uUart_data_vld,
    FRAME_ERROR => uUart_frame_error,
    -- USER DATA OUTPUT INTERFACE
    DATA_IN     => data_in,
    DATA_SEND   => data_send,
    BUSY        => uUart_busy
);

slv8_RxByte <= uSpiRx_slv8_RxData when (sl_configSpiOrUart = '1') else  uUart_data_out;
sl_RxByteValid <= uSpiRx_sl_validRxData when (sl_configSpiOrUart = '1') else  uUart_data_vld;

end architecture RTL;
