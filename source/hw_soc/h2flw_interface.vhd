--------------------------------------------------------------------
--! @file  h2flw_interface.vhd
--! @brief 
--!
--!
--! @author 
--! @date  22.01.2016
--! @version 0.2 
--! 
-- note 
--! @todo 2016.02.17: repair P_WriteVar : process(

--! @test 
--! @bug  
--!
----------------------------------------------------------------------
Library ieee;           
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
--
--!
package h2flw_interface_pkg is
    component h2flw_interface 
    port (
        isl_clk50Mhz        : in std_logic;
        isl_rst             : in std_logic;
 -- h2f-lw       
    osl_external_lw_bus_acknowledge     : out std_logic;             -- acknowledge
    osl_external_lw_bus_irq             : out std_logic;             -- irq
    islv10_external_lw_bus_address       : in  std_logic_vector(9 downto 0);-- address
    isl_external_lw_bus_bus_enable      : in  std_logic;                  -- bus_enable
    islv4_external_lw_bus_byte_enable   : in  std_logic_vector(3 downto 0);-- byte_enable
    isl_external_lw_bus_rw              : in  std_logic;                   -- rw
    islv32_external_lw_bus_write_data   : in  std_logic_vector(31 downto 0);-- write_data
    oslv32_external_lw_bus_read_data    : out std_logic_vector(31 downto 0); -- read_data
----pll_reconfig
--    pll_reconfig_slave_waitrequest : in std_logic;                                        -- waitrequest
--    pll_reconfig_slave_read        : out  std_logic;             -- read
--    pll_reconfig_slave_write       : out  std_logic;             -- write
--    pll_reconfig_slave_readdata    : in std_logic_vector(31 downto 0);                    -- readdata
--    pll_reconfig_slave_address     : out  std_logic_vector(5 downto 0)  := (others => 'X'); -- address
--    pll_reconfig_slave_writedata   : out  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
--buf-control
    islv32_BuffersStatus     : in std_logic_vector(31 downto 0);
    islv32_BufferNumber     : in std_logic_vector(31 downto 0);
--    islv32_BufValid    : in std_logic_vector(31 downto 0);
--    oslv32_RdBufNr     : out std_logic_vector(31 downto 0);
    oslv32_ReadLock    : out std_logic_vector(31 downto 0);
    osl_ReadLockValid  : out std_logic;
-- system control
    oslv32_Modus       : out std_logic_vector(31 downto 0); 
    osl_ModusValid     : out std_logic;
    oslv32_TimerReload : out std_logic_vector(31 downto 0); 
    osl_TimerRelValid  : out std_logic;
    oslv32_DACOffset   : out std_logic_vector(31 downto 0); 
    osl_DacOffsetValid : out std_logic;
    oslv32_ADCDelay    : out std_logic_vector(31 downto 0); 
    osl_AdcDelayValid  : out std_logic;
    islv32_Version     : in  std_logic_vector(31 downto 0); 
    islv32_Status      : in  std_logic_vector(31 downto 0); 
    isl_StatusValid    : in  std_logic
    );        
    end component h2flw_interface;
            
end package h2flw_interface_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;
    use work.monoshot_pkg.all;
    use work.delay2_pkg.all;

entity h2flw_interface is
    port (
    isl_clk50Mhz        : in std_logic;
    isl_rst             : in std_logic;
 -- h2f-lw       
    osl_external_lw_bus_acknowledge     : out std_logic;             -- acknowledge
    osl_external_lw_bus_irq             : out std_logic;             -- irq
    islv10_external_lw_bus_address       : in  std_logic_vector(9 downto 0);                     -- address
    isl_external_lw_bus_bus_enable      : in  std_logic;                                        -- bus_enable
    islv4_external_lw_bus_byte_enable   : in  std_logic_vector(3 downto 0);                     -- byte_enable
    isl_external_lw_bus_rw              : in  std_logic;                                        -- rw
    islv32_external_lw_bus_write_data   : in  std_logic_vector(31 downto 0);                    -- write_data
    oslv32_external_lw_bus_read_data    : out std_logic_vector(31 downto 0); -- read_data
----pll_reconfig
--    pll_reconfig_slave_waitrequest : in std_logic;                                        -- waitrequest
--    pll_reconfig_slave_read        : out  std_logic;             -- read
--    pll_reconfig_slave_write       : out  std_logic;             -- write
--    pll_reconfig_slave_readdata    : in std_logic_vector(31 downto 0);                    -- readdata
--    pll_reconfig_slave_address     : out  std_logic_vector(5 downto 0)  := (others => 'X'); -- address
--    pll_reconfig_slave_writedata   : out  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
--buf-control
    islv32_BuffersStatus     : in std_logic_vector(31 downto 0);
    islv32_BufferNumber     : in std_logic_vector(31 downto 0);
--    islv32_BufValid    : in std_logic_vector(31 downto 0);
--    oslv32_RdBufNr     : out std_logic_vector(31 downto 0);
    oslv32_ReadLock    : out std_logic_vector(31 downto 0);
    osl_ReadLockValid  : out std_logic;
-- system control
    oslv32_Modus       : out std_logic_vector(31 downto 0); 
    osl_ModusValid     : out std_logic;
    oslv32_TimerReload : out std_logic_vector(31 downto 0); 
    osl_TimerRelValid  : out std_logic;
    oslv32_DACOffset : out std_logic_vector(31 downto 0); 
    osl_DacOffsetValid  : out std_logic;
    oslv32_ADCDelay    : out std_logic_vector(31 downto 0); 
    osl_AdcDelayValid  : out std_logic;
    islv32_Version      : in  std_logic_vector(31 downto 0); 
    islv32_Status      : in  std_logic_vector(31 downto 0); 
    isl_StatusValid    : in  std_logic -- not used now
    );
end entity h2flw_interface;

--!
--!
--! @brief
--!
--! @detail 
--! 
--!
architecture RTL of h2flw_interface is
    signal sl_h2fReadReq               : std_logic;
    signal sl_h2fWriteReq              : std_logic;
    signal sl_h2fReadAck               : std_logic;
    signal sl_h2fWriteAck              : std_logic;
    signal sl_h2fReadAckMono           : std_logic;
    signal sl_h2fWriteAckMono          : std_logic;
    signal slv32_TimerReload_Next      : std_logic_vector(31 downto 0);
    signal sl_TimerRelValid_Next       : std_logic;
    signal slv32_Modus_Next            : std_logic_vector(31 downto 0);
    signal sl_ModusValid_Next          : std_logic;
    signal sl_TimerRelValid            : std_logic;
    signal sl_ModusValid               : std_logic;
    signal sl_ReadLockValid            : std_logic;
    signal sl_DacOffsetValid            : std_logic;
    signal sl_AdcDelayValid            : std_logic;

    signal slv_lw_bus_block_addr : std_logic_vector(1 downto 0);
    signal slv_lw_bus_item_addr : std_logic_vector(7 downto 0);
    
    
begin
    slv_lw_bus_block_addr <= islv10_external_lw_bus_address(9 downto 8);
    slv_lw_bus_item_addr <= islv10_external_lw_bus_address(7 downto 0);
--    pll_reconfig_slave_writedata <= islv32_external_lw_bus_write_data;
--    pll_reconfig_slave_address <= islv10_external_lw_bus_address(7 downto 2);
    
       sl_h2fReadReq               <= isl_external_lw_bus_bus_enable and isl_external_lw_bus_rw;
       sl_h2fWriteReq              <= isl_external_lw_bus_bus_enable and (not isl_external_lw_bus_rw);

       osl_TimerRelValid <= sl_TimerRelValid and sl_h2fWriteAck;
       osl_ModusValid    <= sl_ModusValid and sl_h2fWriteAck;
       osl_ReadLockValid <= sl_ReadLockValid;
       osl_DacOffsetValid <= sl_DacOffsetValid and sl_h2fWriteAck;
       osl_AdcDelayValid <= sl_AdcDelayValid and sl_h2fWriteAck;
 U_RdAckMono : monoshot 
    port map     (
        isl_clk        => isl_clk50Mhz,--: in std_logic; --! master clock 50 MHz
        isl_rst             => isl_rst,--: in std_logic; --! master reset active high
        isl_input           => sl_h2fReadReq,--: in std_logic; --!
        osl_outputMono      => sl_h2fReadAckMono--: out std_logic --! pwm output
    );        
U_RdAck: delay2 port map(isl_clk50Mhz, isl_rst, sl_h2fReadAckMono, sl_h2fReadAck);    

U_WrAckMono : monoshot 
    port map     (
        isl_clk        => isl_clk50Mhz,--: in std_logic; --! master clock 50 MHz
        isl_rst             => isl_rst,--: in std_logic; --! master reset active high
        isl_input           => sl_h2fWriteReq,--: in std_logic; --!
        osl_outputMono      => sl_h2fWriteAckMono--: out std_logic --! pwm output
    );        
U_WrAck: delay2 port map(isl_clk50Mhz, isl_rst, sl_h2fWriteAckMono, sl_h2fWriteAck);    

    osl_external_lw_bus_acknowledge <= sl_h2fWriteAck or sl_h2fReadAck;

P_Write : process(
	isl_clk50Mhz, sl_h2fWriteReq, islv10_external_lw_bus_address
)is
begin
	if rising_edge(isl_clk50Mhz) then
		if (isl_rst = '1') then
			oslv32_TimerReload <= x"00006000"; 
			sl_TimerRelValid <= '0';
	        oslv32_Modus <= x"00000000";--(others => '0');
	        sl_ModusValid <= '0';
--            pll_reconfig_slave_write <= '0';
            sl_ReadLockValid <= '0';
            sl_DacOffsetValid <= '0';
            sl_AdcDelayValid <= '0';
--            pll_reconfig_slave_write <= '0';
		elsif((sl_h2fWriteReq = '1')) then
            if(slv_lw_bus_block_addr = c_slv2_h2f_block_write) then -- old write area
--                pll_reconfig_slave_write <= '0';
                case (slv_lw_bus_item_addr) is
                when c_slv8_h2f_address_TimerReload =>  
                    oslv32_TimerReload <= islv32_external_lw_bus_write_data;
                    sl_TimerRelValid <= '1';
                when c_slv8_h2f_address_Modus =>
                    oslv32_Modus <= islv32_external_lw_bus_write_data;
                    sl_ModusValid <= '1';
                when c_slv8_h2f_address_ReadLock =>
                    oslv32_ReadLock <= islv32_external_lw_bus_write_data;
                    sl_ReadLockValid <= '1';
                when c_slv8_h2f_address_DAC_Offset =>
                    oslv32_DACOffset <= islv32_external_lw_bus_write_data;
                    sl_DacOffsetValid <= '1';
                when c_slv8_h2f_address_ADC_Delay =>
                    oslv32_ADCDelay <= islv32_external_lw_bus_write_data;
                    sl_AdcDelayValid <= '1';
                when others =>     
--                when others => null;    
                    sl_TimerRelValid <= '0';
                    sl_ModusValid <= '0';
                    sl_ReadLockValid <= '0';
                    sl_DacOffsetValid <= '0';
                    sl_AdcDelayValid <= '0';
                end case;
            elsif(slv_lw_bus_block_addr = c_slv2_h2f_block_pll) then -- new pll config    
--                pll_reconfig_slave_write <= '1';
            end if;    
                
			
		else
--            pll_reconfig_slave_write <= '0';
            sl_TimerRelValid <= '0';
            sl_ModusValid <= '0';
            sl_DacOffsetValid <= '0';
            sl_ReadLockValid <= '0';
            sl_AdcDelayValid <= '0';
		end if;	 	
	end if;
end process;		
--
P_Read : process(
    islv10_external_lw_bus_address--,islv32_Status,islv32_BuffersStatus,islv32_BufValid
)is
begin
    if((sl_h2fReadReq = '1')) then
        if(slv_lw_bus_block_addr = c_slv2_h2f_block_read) then -- old write area
--            pll_reconfig_slave_read <= '0';
            case (slv_lw_bus_item_addr) is
            when c_slv8_h2f_address_Status =>
                oslv32_external_lw_bus_read_data <= islv32_Status;
            when c_slv8_h2f_address_BufferNumber =>
                oslv32_external_lw_bus_read_data <= islv32_BufferNumber;
            when c_slv8_h2f_address_BufferStatus =>
                oslv32_external_lw_bus_read_data <= islv32_BuffersStatus;
            when c_slv8_h2f_address_Version =>
                oslv32_external_lw_bus_read_data <= islv32_Version;
            when others =>
                oslv32_external_lw_bus_read_data <= x"DEADBEEF";
            end case;    
        elsif(slv_lw_bus_block_addr = c_slv2_h2f_block_pll) then -- new pll config    
--            pll_reconfig_slave_read <= '1';
--            oslv32_external_lw_bus_read_data <= pll_reconfig_slave_readdata;
        else
--            pll_reconfig_slave_read <= '0';
        end if;    
    else
--        pll_reconfig_slave_read <= '0';
    end if;
        
end process;    

end architecture RTL;
