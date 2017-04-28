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
    islv10_external_lw_bus_address      : in  std_logic_vector(9 downto 0);-- address
    isl_external_lw_bus_bus_enable      : in  std_logic;                  -- bus_enable
    islv4_external_lw_bus_byte_enable   : in  std_logic_vector(3 downto 0);-- byte_enable
    isl_external_lw_bus_rw              : in  std_logic;                   -- rw
    islv32_external_lw_bus_write_data   : in  std_logic_vector(31 downto 0);-- write_data
    oslv32_external_lw_bus_read_data    : out std_logic_vector(31 downto 0); -- read_data
-- outputs
	on32_periodCount					: out  signed (31 downto 0);
	osl_periodValid						: out std_logic;
	on16_rampValue  					: out signed (15 downto 0);
	osl_rampValid						: out std_logic;
	on16_H2FinputVectorL				: out signed (15 downto 0);
	on16_H2FinputVectorR				: out signed (15 downto 0);
	osl_inputValid						: out std_logic;
	ou8_microResProStepL 				: out unsigned(7 downto 0);
	ou8_microResProStepR 				: out unsigned(7 downto 0);
	osl_microStepValid					: out std_logic;
-- inputs
	islv6_PosModulo						: in std_logic_vector(5 downto 0);

    islv32_Version     					: in  std_logic_vector(31 downto 0); 
    islv32_Status      					: in  std_logic_vector(31 downto 0); 
    isl_StatusValid    					: in  std_logic
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
    islv10_external_lw_bus_address      : in  std_logic_vector(9 downto 0);                     -- address
    isl_external_lw_bus_bus_enable      : in  std_logic;                                        -- bus_enable
    islv4_external_lw_bus_byte_enable   : in  std_logic_vector(3 downto 0);                     -- byte_enable
    isl_external_lw_bus_rw              : in  std_logic;                                        -- rw
    islv32_external_lw_bus_write_data   : in  std_logic_vector(31 downto 0);                    -- write_data
    oslv32_external_lw_bus_read_data    : out std_logic_vector(31 downto 0); -- read_data
-- outputs
	on32_periodCount					: out  signed (31 downto 0);
	osl_periodValid						: out std_logic;
	on16_rampValue  					: out signed (15 downto 0);
	osl_rampValid						: out std_logic;
	on16_H2FinputVectorL				: out signed (15 downto 0);
	on16_H2FinputVectorR				: out signed (15 downto 0);
	osl_inputValid						: out std_logic;
	ou8_microResProStepL 				: out unsigned(7 downto 0);
	ou8_microResProStepR 				: out unsigned(7 downto 0);
	osl_microStepValid					: out std_logic;
-- inputs
	islv6_PosModulo						: in std_logic_vector(5 downto 0);

    islv32_Version     					: in  std_logic_vector(31 downto 0); 
    islv32_Status      					: in  std_logic_vector(31 downto 0); 
    isl_StatusValid    					: in  std_logic
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

    signal slv_lw_bus_block_addr : std_logic_vector(1 downto 0);
    signal slv_lw_bus_item_addr : std_logic_vector(7 downto 0);
    
    signal sl_periodValid	: std_logic;
    signal sl_rampValid		: std_logic;
    signal sl_inputValid		: std_logic;
    signal sl_microStepValid		: std_logic;
    
    
begin
    slv_lw_bus_block_addr <= islv10_external_lw_bus_address(9 downto 8);
    slv_lw_bus_item_addr <= islv10_external_lw_bus_address(7 downto 0);
    
   sl_h2fReadReq               <= isl_external_lw_bus_bus_enable and isl_external_lw_bus_rw;
   sl_h2fWriteReq              <= isl_external_lw_bus_bus_enable and (not isl_external_lw_bus_rw);

   osl_periodValid <= sl_periodValid and sl_h2fWriteAck;
   osl_rampValid    <= sl_rampValid and sl_h2fWriteAck;
   osl_inputValid   <= sl_inputValid and sl_h2fWriteAck;
   osl_microStepValid <= sl_microStepValid and sl_h2fWriteAck;

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
			on32_periodCount <= x"00006000"; 
			sl_periodValid <= '0';
	        on16_rampValue <= x"0040";
	        sl_rampValid <= '0';
            on16_H2FinputVectorL <= x"0000";
            on16_H2FinputVectorR <= x"0000";
	        sl_inputValid <= '0';
            sl_microStepValid <= '0';
	        
		elsif((sl_h2fWriteReq = '1')) then
            if(slv_lw_bus_block_addr = c_slv2_h2f_block_write) then -- old write area
                case (slv_lw_bus_item_addr) is
                when c_slv8_h2f_address_PeriodCount =>  
                    on32_periodCount <= signed(islv32_external_lw_bus_write_data);
                    sl_periodValid <= '1';
                when c_slv8_h2f_address_RampValue =>
                    on16_rampValue <= signed(islv32_external_lw_bus_write_data(15 downto 0));
                    sl_rampValid <= '1';
                when c_slv8_h2f_address_InputValue =>
                    on16_H2FinputVectorL <= signed(islv32_external_lw_bus_write_data(31 downto 16));
                    on16_H2FinputVectorR <= signed(islv32_external_lw_bus_write_data(15 downto 0));
                    sl_inputValid <= '1';
                when c_slv8_h2f_address_MicroStepProStep =>
                    ou8_microResProStepL <= unsigned(islv32_external_lw_bus_write_data(23 downto 16));
                    ou8_microResProStepR <= unsigned(islv32_external_lw_bus_write_data(7 downto 0));
                    sl_microStepValid <= '1';
                when others =>     
                    sl_periodValid <= '0';
                    sl_rampValid <= '0';
                    sl_inputValid <= '0';
                    sl_microStepValid <= '0';
                end case;
            end if;    
		else
            sl_periodValid <= '0';
            sl_rampValid <= '0';
            sl_inputValid <= '0';
            sl_microStepValid <= '0';
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
            when c_slv8_h2f_address_PosModulo =>
                oslv32_external_lw_bus_read_data <= X"000000" & "00"& islv6_PosModulo;
            when c_slv8_h2f_address_Version =>
                oslv32_external_lw_bus_read_data <= islv32_Version;
            when others =>
                oslv32_external_lw_bus_read_data <= x"DEADBEEF";
            end case;    
        end if;    
    end if;
        
end process;    

end architecture RTL;
