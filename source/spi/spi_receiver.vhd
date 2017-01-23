----------------------------------------------------------------------
--! @file  spi_receiver.vhd
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
package spi_receiver_pkg is
    component spi_receiver 
    port (
    isl_SpiClk       : in std_logic; --! output clock 
    isl_reset        : in std_logic;
    isl_mosi         : in std_logic;
    isl_RxActive     : in std_logic;
    osl_validData    : out std_logic;
    oslv8_Data       : out std_logic_vector(7 downto 0)
   );
    end component spi_receiver;
            
end package spi_receiver_pkg;



library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.numeric_std.all;
library work;
--    use work.deflipflop_pkg.all;
    use work.msystem_tcc_pkg.all;
    use work.monoshot_pkg.all;

entity spi_receiver is
  GENERIC(
    cpol    : STD_LOGIC := '0';  --spi clock polarity mode
    cpha    : STD_LOGIC := '0';  --spi clock phase mode
    d_width : INTEGER := 8);     --data width in bits
    port (
    isl_SpiClk       : in std_logic; --! output clock 
    isl_reset        : in std_logic;
    isl_mosi         : in std_logic;
    isl_RxActive     : in std_logic;
    osl_validData    : out std_logic;
    oslv8_Data       : out std_logic_vector(7 downto 0)
   );
end entity spi_receiver;

--!
--! @brief
--!
--! @detail 
--! 
--!
architecture RTL of spi_receiver is
    SIGNAL mode                : STD_LOGIC; --groups modes by clock polarity relation to data
    SIGNAL internSpiClk        : STD_LOGIC; --clock
    SIGNAL bit_cnt             : STD_LOGIC_VECTOR(7 DOWNTO 0); --'1' for active transaction bit
    signal slv8_inputShiftReg  : std_logic_vector(d_width - 1 downto 0);
    signal slv8_shadowShiftReg : std_logic_vector(d_width - 1 downto 0);
    signal n_inputShiftIndex   : uShiftIndex8;
    signal sl_dataValid        : std_logic;
    --    signal sl_dataValid_m : std_logic;
begin

  mode <= cpol XOR cpha;  --'1' for modes that write on rising edge
--  WITH mode SELECT
--    internSpiClk <= isl_SpiClk WHEN '1',
--           NOT isl_SpiClk WHEN OTHERS;
    internSpiClk <= isl_SpiClk;
    
    sl_dataValid <= '1' when (bit_cnt = x"01") else '0';
    
    oslv8_Data <= slv8_inputShiftReg;
    osl_validData <= sl_dataValid;

P_Reset : process(isl_RxActive, internSpiClk, isl_reset, isl_mosi, slv8_inputShiftReg)
begin
    IF (isl_RxActive = '0' OR isl_reset = '1') THEN --this slave is not selected or being reset
        slv8_inputShiftReg <= x"00";
    else
        if rising_edge(internSpiClk) then
            slv8_inputShiftReg(0) <=  isl_mosi;
            slv8_inputShiftReg(7 downto 1) <= slv8_inputShiftReg(6 downto 0);
        end if;    
    end if;
end process;    


P_ShadowReg : process (
    sl_dataValid
)
begin
    if(sl_dataValid = '1') then
        slv8_shadowShiftReg <= slv8_inputShiftReg;
    end if;    
end process;    

-- seems not to be used
--U_mono : monoshot 
--    --generic(
--    --    bModelSim           : boolean := FALSE
--    --);
--    port map     (
--        isl_clk50Mhz        => internSpiClk,--: in std_logic; --! master clock 50 MHz
--        isl_rst             => '0',--: in std_logic; --! master reset active high
--        isl_input           => sl_dataValid,--: in std_logic; --!
--        osl_outputMono      => sl_dataValid_m--: out std_logic --! pwm output
--    );        

  --keep track of miso/mosi bit counts for data alignmnet
  PROCESS(isl_RxActive, internSpiClk)
  BEGIN
    IF(isl_RxActive = '0' OR isl_reset = '1') THEN                         --this slave is not selected or being reset
     --  bit_cnt <= (conv_integer(NOT cpha) => '1', OTHERS => '0'); --reset miso/mosi bit count
       bit_cnt <= x"01";--bit_cnt(0) => '1', OTHERS => '0'; --reset miso/mosi bit count
    ELSE                                                         --this slave is selected
      IF(rising_edge(internSpiClk)) THEN                                  --new bit on miso/mosi
        bit_cnt <= bit_cnt(6 DOWNTO 0) & bit_cnt(7);          --shift active bit indicator
      END IF;
    END IF;
  END PROCESS;

end architecture RTL;
