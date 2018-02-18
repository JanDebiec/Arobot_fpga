----------------------------------------------------------------------
--! @file  
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
-- a block with shift register, comparator
-- and output registers 
Library ieee;           
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
--
package host_interface_pkg is
component host_interface 
--generic (
--    eslv8_MagicWord : std_logic_vector(7 downto 0) := x"a5";
--    eslv8_CmdVelWord : std_logic_vector(7 downto 0) := x"00"
--);
port (
    isl_clk50Mhz    : in std_logic;
    isl_rst         : in std_logic;
    isl_enable   : in std_logic;
    isl_SerialRx    : in std_logic; 
    osl_SerialTx    : out std_logic; 
    oslv_shortA     : out signed(15 downto 0);
    oslv_shortB     : out signed(15 downto 0);
    osl_outputValid : out std_logic
);        
end component host_interface;
            
end package host_interface_pkg;

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
    use work.uart_pkg.all;
    use work.cmdVel_parser_serial_pkg.all;
 
entity host_interface is
    port(
    isl_clk50Mhz    : in std_logic;
    isl_rst         : in std_logic;
    isl_enable   : in std_logic;
    isl_SerialRx    : in std_logic; 
    osl_SerialTx    : out std_logic; 
    oslv_shortA     : out signed(15 downto 0);
    oslv_shortB     : out signed(15 downto 0);
    osl_outputValid : out std_logic
    );
end entity host_interface;

architecture RTL of host_interface is
    signal sl_clk50MHz          : STD_LOGIC := '0';     -- clock 50MHz
    signal sl_Reset             : STD_LOGIC := '0';
-- uart
    signal uRx_sl_inputValid : std_logic;
    signal  uRx_n16_inputVectorR : signed (15 downto 0);
    signal  uRx_n16_inputVectorL : signed (15 downto 0);
    -- USER DATA INPUT INTERFACE
    signal  data_in     : std_logic_vector(7 downto 0);
    signal  data_send   : std_logic; -- when DATA_SEND = 1, data on DATA_IN will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    signal  uUart_busy        : std_logic; -- when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    -- USER DATA OUTPUT INTERFACE
    signal  uUart_data_out    : std_logic_vector(7 downto 0);
    signal  uUart_data_vld    : std_logic; -- when DATA_VLD = 1, data on DATA_OUT are valid
    signal  uUart_frame_error : std_logic;  -- when FRAME_ERROR = 1, stop bit was invalid, current and next data may be invalid

    signal  slv8_RxByte    : std_logic_vector(7 downto 0);
    signal  sl_RxByteValid    : std_logic;

    -- signals for feedback
    signal uAxisL_oslv6_PosModulo : std_logic_vector(5 downto 0);
    signal uAxisR_oslv6_PosModulo : std_logic_vector(5 downto 0);

    
begin
    
    sl_clk50MHz <= isl_clk50MHz;
    sl_Reset <= isl_rst;
    
uRxCmd : cmdVel_parser_serial
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
    

end architecture RTL;
