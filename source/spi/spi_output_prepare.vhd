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
    osl_DataReq      : out std_logic;
    isl_dataValid    : in std_logic;
    isl_reset        : in std_logic;
-- spi clock
    isl_SpiClock     : in std_logic;    
    isl_transferData : in std_logic;
    isl_trDataReq    : in std_logic;
    isl_trReady      : in std_logic;
    oslv8_outData    : out std_logic_vector(7 downto 0);
    osl_firstByteValid  : out std_logic;
    osl_DataValid    : out std_logic;
    osl_txActive     : out std_logic
    );        
    end component spi_output_prepare;
            
end package spi_output_prepare_pkg;

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.mono_on_border_pkg.all;
    use work.monoshot_pkg.all;
    use work.flipflop_d1_pkg.all;
 
entity spi_output_prepare is
    port (
-- system side
    isl_SystemClock  : in STD_LOGIC;
    islv8_MagicWord  : in std_logic_vector(7 downto 0);
    islv8_Header     : in std_logic_vector(7 downto 0);
    islv32_DataL     : in std_logic_vector(31 downto 0);
    islv32_DataR     : in std_logic_vector(31 downto 0);
    osl_DataReq      : out std_logic;
    isl_dataValid    : in std_logic;
    isl_reset        : in std_logic;
-- spi clock
    isl_SpiClock     : in std_logic;    
    isl_transferData : in std_logic;
    isl_trDataReq    : in std_logic;
    isl_trReady      : in std_logic;
    oslv8_outData    : out std_logic_vector(7 downto 0);
    osl_firstByteValid  : out std_logic;
    osl_DataValid    : out std_logic;
    osl_txActive     : out std_logic
    );
end entity spi_output_prepare;

architecture RTL of spi_output_prepare is
    type sm_OutputPrepareSpi_Type is (
        st_Idle,
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

    type sm_OutputPrepareSys_Type is (
        st_Idle,
        st_dataReq,
        st_wait1,  
        st_wait2,
        st_wait3,
        st_loadFirst,
        st_end
    );

    signal smLoadSpi_cs, smLoadSpi_ns : sm_OutputPrepareSpi_Type;
    signal smLoadSys_cs, smLoadSys_ns : sm_OutputPrepareSys_Type;
    
    signal slv80_outputRegister : std_logic_vector(79 downto 0);
    signal sl_trDataReqR : std_logic;
    signal sl_dataReq_Sys : std_logic;
    signal sl_dataReq_Spi : std_logic;
    
    signal sl_startdataReqSys : std_logic;
--    signal sl_dataValid : std_logic;
    signal sl_dataValidSpi : std_logic;
    signal sl_loadFirstSm : std_logic;
    signal sl_loadFirstSmSpi : std_logic;
        

begin
    
    sl_dataReq_Spi <= '1' when (smLoadSpi_cs = st_end) else '0';
uDataReq : mono_on_border
    PORT map
    (
    i_InputClock    => isl_SpiClock,--: in  STD_LOGIC;--
    i_OutputClock   => isl_SystemClock,--: in  STD_LOGIC;--
    i_Input         => sl_dataReq_Spi,--: in  STD_LOGIC;--
    i_Reset         => isl_reset,--: in  STD_LOGIC;--
    o_Output        => sl_dataReq_Sys--: out STD_LOGIC     --
    );
    
uDataVal : mono_on_border
    PORT map
    (
    i_InputClock    => isl_SystemClock,--: in  STD_LOGIC;--
    i_OutputClock   => isl_SpiClock,--: in  STD_LOGIC;--
    i_Input         => isl_dataValid,--: in  STD_LOGIC;--
    i_Reset         => isl_reset,--: in  STD_LOGIC;--
    o_Output        => sl_dataValidSpi--: out STD_LOGIC     --
    );
    
uloadFirst : mono_on_border
    PORT map
    (
    i_InputClock    => isl_SystemClock,--: in  STD_LOGIC;--
    i_OutputClock   => isl_SpiClock,--: in  STD_LOGIC;--
    i_Input         => sl_loadFirstSm,--: in  STD_LOGIC;--
    i_Reset         => isl_reset,--: in  STD_LOGIC;--
    o_Output        => sl_loadFirstSmSpi--: out STD_LOGIC     --
    );
    
    
    
    
    
    osl_DataReq <= sl_dataReq_Sys;
    
    osl_txActive <= '1' when (smLoadSpi_cs /= st_Idle) else '0';
    slv80_outputRegister <= islv8_MagicWord & islv8_Header & islv32_DataL & islv32_DataR;
    oslv8_outData <= 
                    slv80_outputRegister(71 downto 64 ) when (smLoadSpi_cs = st_loadSecond) else
                    slv80_outputRegister(63 downto 56 ) when (smLoadSpi_cs = st_loadThird) else
                    slv80_outputRegister(55 downto 48 ) when (smLoadSpi_cs = st_loadFourth) else
                    slv80_outputRegister(47 downto 40 ) when (smLoadSpi_cs = st_loadFifth) else
                    slv80_outputRegister(39 downto 32 ) when (smLoadSpi_cs = st_loadSixth) else
                    slv80_outputRegister(31 downto 24 ) when (smLoadSpi_cs = st_loadSeventh) else
                    slv80_outputRegister(23 downto 16 ) when (smLoadSpi_cs = st_loadEight) else
                    slv80_outputRegister(15 downto 8 ) when (smLoadSpi_cs = st_loadNinth) else
                    slv80_outputRegister(7 downto 0 ) when (smLoadSpi_cs = st_loadTenth) else
                    slv80_outputRegister(79 downto 72 );
    
    sl_startdataReqSys <= '1' when (smLoadSpi_cs = st_end) else '0';

uFDataReq : flipflop_d1
    PORT map
    (
    isl_clock   => isl_SpiClock,--: in STD_LOGIC;
    isl_d       => isl_trDataReq,--: in STD_LOGIC;
    isl_ena     => '1',--: in STD_LOGIC;
    isl_reset   => isl_reset,--: in STD_LOGIC;
    osl_out     => sl_trDataReqR--: out STD_LOGIC
    );

uOutDataVal : flipflop_d1
    PORT map
    (
    isl_clock   => isl_SpiClock,--: in STD_LOGIC;
    isl_d       => sl_trDataReqR,--: in STD_LOGIC;
    isl_ena     => '1',--: in STD_LOGIC;
    isl_reset   => isl_reset,--: in STD_LOGIC;
    osl_out     => osl_DataValid--: out STD_LOGIC
    );


--uFBVMono : monoshot 
--    port map (
--        isl_SystemClock,
--        isl_reset,
--        sl_dataValid,
--        sl_dataValidSpi
--    );        
osl_firstByteValid <= sl_dataValidSpi or sl_loadFirstSmSpi; 

pLoad_com : process (
    isl_transferData,
    sl_trDataReqR,
    isl_trReady,
    smLoadSpi_cs
)
begin
    case smLoadSpi_cs is
    when st_Idle =>
--        if isl_transferData = '1' then
--        if(sl_trDataReqR = '1') then
--            smLoadSpi_ns <= st_loadFirst;
--        end if;    
--    when st_loadFirst =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadSecond;
        end if;    
    when st_loadSecond =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadThird;
        end if;    
    when st_loadThird =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadFourth;
        end if;    
    when st_loadFourth =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadFifth;
        end if;    
    when st_loadFifth =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadSixth;
        end if;    
    when st_loadSixth =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadSeventh;
        end if;    
    when st_loadSeventh =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadEight;
        end if;    
    when st_loadEight =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadNinth;
        end if;    
    when st_loadNinth =>
        if(sl_trDataReqR = '1') then
            smLoadSpi_ns <= st_loadTenth;
        end if;    
    when st_loadTenth =>
        if(isl_trReady = '1') then
            smLoadSpi_ns <= st_end;
        end if;    
    when st_end =>
        smLoadSpi_ns <= st_Idle;    
    when others =>
        smLoadSpi_ns <= st_Idle;
    end case;
end process;        

pLoad_seq : process (
        isl_SpiClock,
        isl_reset     
)
begin
    if (isl_reset = '1') then
        smLoadSpi_cs <= st_Idle;
    elsif (rising_edge(isl_SpiClock)) then
        smLoadSpi_cs <= smLoadSpi_ns;
    END IF;
end process;


pDataReq_com : process (
    sl_dataReq_Sys,
    smLoadSys_cs
)
begin
    case smLoadSys_cs is
    when st_Idle =>
        if sl_dataReq_Sys = '1' then
            smLoadSys_ns <= st_dataReq;
        end if;    
    when st_dataReq =>
        smLoadSys_ns <= st_wait1;
    when st_wait1 => 
        smLoadSys_ns <= st_wait2;
    when st_wait2 =>
        smLoadSys_ns <= st_wait3;
    when st_wait3 =>
        smLoadSys_ns <= st_loadFirst;
    when st_loadFirst =>
        smLoadSys_ns <= st_end;
    when st_end =>
        smLoadSys_ns <= st_Idle;
    when others =>
        smLoadSys_ns <= st_Idle;
    end case;    
        
end process;    

sl_loadFirstSm <= '1' when (smLoadSys_cs = st_loadFirst) else '0';

pDataReq_seq : process (
        isl_SystemClock,
        isl_reset     
)
begin
    if (isl_reset = '1') then
        smLoadSys_cs <= st_Idle;
    elsif (rising_edge(isl_SystemClock)) then
        smLoadSys_cs <= smLoadSys_ns;
    END IF;
end process;

end architecture RTL;
