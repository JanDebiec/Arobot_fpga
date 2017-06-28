----------------------------------------------------------------------
--! @file  spi_output_prepare.vhd
--! @brief shift reg
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
package spi_output_prepare_pkg is
    component spi_output_prepare 
    generic(
        bModelSim           : boolean := FALSE
    );
    port (
-- system side
    isl_SystemClock  : in STD_LOGIC;
    islv8_MagicWord  : in std_logic_vector(7 downto 0);
    islv8_Header     : in std_logic_vector(7 downto 0);
    islv32_DataL     : in std_logic_vector(31 downto 0);
    islv32_DataR     : in std_logic_vector(31 downto 0);
    isl_transferData : in std_logic;
    oslv8_outData    : out std_logic_vector(7 downto 0);
    osl_firstByteValid  : out std_logic;
    osl_DataValid    : out std_logic;
    osl_txActive     : out std_logic;
    isl_reset        : in std_logic
    );        
    end component spi_output_prepare;
            
end package spi_output_prepare_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_output_prepare is
    port (
-- system side
    isl_SystemClock  : in STD_LOGIC;
    islv8_MagicWord  : in std_logic_vector(7 downto 0);
    islv8_Header     : in std_logic_vector(7 downto 0);
    islv32_DataL     : in std_logic_vector(31 downto 0);
    islv32_DataR     : in std_logic_vector(31 downto 0);
    isl_transferData : in std_logic;
    oslv8_outData    : out std_logic_vector(7 downto 0);
    osl_firstByteValid  : out std_logic;
    osl_DataValid    : out std_logic;
    osl_txActive     : out std_logic;
    isl_reset        : in std_logic
    );
end entity spi_output_prepare;

architecture RTL of spi_output_prepare is
    type sm_OutputPrepare_Type is (
        st_Idle,
        st_loadFirst,
        st_loadSecond,
        st_loadThird,
        st_loadFourth,
        st_loadFifth,
        st_loadSixth,
        st_loadSeventh,
        st_loadEight,
        st_loadNinth,
        st_loadTenth,
        st_end
            
    );
    signal smLoad_cs, smLoad_ns : sm_OutputPrepare_Type;
    
    signal slv80_outputRegister : std_logic_vector(79 downto 0);

begin
    slv80_outputRegister <= islv8_MagicWord & islv8_Header & islv32_DataL & islv32_DataR;
    oslv8_outData <= slv80_outputRegister(79 downto 72 ) when (smLoad_cs = st_loadFirst) else
                    slv80_outputRegister(71 downto 64 ) when (smLoad_cs = st_loadSecond) else
                    slv80_outputRegister(63 downto 56 ) when (smLoad_cs = st_loadThird) else
                    slv80_outputRegister(55 downto 48 ) when (smLoad_cs = st_loadFourth) else
                    slv80_outputRegister(47 downto 40 ) when (smLoad_cs = st_loadFifth) else
                    slv80_outputRegister(39 downto 32 ) when (smLoad_cs = st_loadSixth) else
                    slv80_outputRegister(31 downto 24 ) when (smLoad_cs = st_loadSeventh) else
                    slv80_outputRegister(23 downto 16 ) when (smLoad_cs = st_loadEight) else
                    slv80_outputRegister(15 downto 8 ) when (smLoad_cs = st_loadNinth) else
                    slv80_outputRegister(7 downto 0 ) when (smLoad_cs = st_loadTenth) else
                    x"AA";
pLoad_comb : process (
    isl_transferData,
    smLoad_cs
)
begin
    case smLoad_cs is
    when st_Idle =>
        if isl_transferData = '1' then
            smLoad_ns <= st_loadFirst;
        end if;    
        when st_loadFirst =>
        when st_loadSecond =>
        when st_loadThird =>
        when st_loadFourth =>
        when st_loadFifth =>
        when st_loadSixth =>
        when st_end =>
        when others =>
            smLoad_ns <= st_Idle;
    end case;
end process;        

pLoad_seq : process (
        isl_SystemClock,
        isl_reset     
)
begin
    if (isl_reset = '1') then
        smLoad_cs <= st_Idle;
    elsif (rising_edge(isl_SystemClock)) then
        if(isl_transferData = '0') then
            smLoad_cs <= st_Idle;
        else    
            smLoad_cs <= smLoad_ns;
        end if;    
    END IF;
end process;

end architecture RTL;
