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
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
--
package byte_reader_pkg is
    component byte_reader 
    port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_bitInput : in std_logic;
		--sl_bitValid : in std_logic;
		osl_bitValid : out std_logic;
		osl_bitValue : out std_logic;
		osl_byteValid : out std_logic;
		oslv_byteValue : out std_logic_vector(7 downto 0)
    );        
    end component byte_reader;
            
end package byte_reader_pkg;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
Library work;			
	use work.arobot_constant_pkg.all;	
	use work.arobot_component_pkg.all;	
--	use work.baudrate_counter_pkg.all;	
	
LIBRARY lpm;
USE lpm.all;


entity byte_reader is
	generic (baudrate : integer := 115200);
	port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_bitInput : in std_logic;
--		sl_bitValid : in std_logic;
		osl_bitValid : out std_logic;
		osl_bitValue : out std_logic;
		osl_byteValid : out std_logic;
		oslv_byteValue : out std_logic_vector(7 downto 0)
	);
end entity byte_reader;

architecture RTL of byte_reader is
type sm_ByteReaderSM_Type is (
        st_Idle    ,
        st_Start,--
        st_BitStart,
        st_Bit0,
        st_Bit1,
        st_Bit2,
        st_Bit3,
        st_Bit4,
        st_Bit5,
        st_Bit6,
        st_Bit7,
        st_BitStop0
        
);
signal sl_bitValid : std_logic;
signal sm_ByteReaderSM, sm_ByteReaderSM_next: sm_ByteReaderSM_Type;
signal sl_readBit : std_logic;
signal sl_cntEna :STD_LOGIC;
signal sl_readBit_next : std_logic;
signal sl_cntEna_next :STD_LOGIC;
signal slv12_data		: STD_LOGIC_VECTOR (11 DOWNTO 0);
signal sl_sclr		: STD_LOGIC ;
signal sl_sload		: STD_LOGIC := '0';
signal sl_sset		:STD_LOGIC := '0';
signal slv12_q		: STD_LOGIC_VECTOR (11 DOWNTO 0);
signal slv12_null : STD_LOGIC_VECTOR (11 DOWNTO 0) := x"000";
signal slv12_fullBitTime : STD_LOGIC_VECTOR (11 DOWNTO 0) := x"190";--x"1a6";
signal slv12_halfBitTime : STD_LOGIC_VECTOR (11 DOWNTO 0) := x"0c8";
signal sl_bitSync : STD_LOGIC := '0';
signal slv8_byteRead : std_logic_vector(7 downto 0);
signal slv8_byteReadEna : std_logic_vector(7 downto 0);
signal sl_ByteValid : std_logic;
	
begin

sl_sclr <= isl_rst;
sl_sload <= sl_bitSync;
osl_byteValid <= sl_ByteValid;
oslv_byteValue <= slv8_byteRead;

bitSyncSM : process (
	slv12_q
) is
variable vsl_bitSync : std_logic;
begin
	vsl_bitSync := '0';
	if(slv12_q = slv12_null) then
		vsl_bitSync := '1';
	end if;
	sl_bitSync <= vsl_bitSync;	
end process;	

ByteReaderSM : process (
	isl_bitInput,
	sl_bitSync
	--sm_ByteReaderSM
) is
variable vsl_readBit : std_logic;
variable vsl_cntEna : std_logic;
variable vslv12_data : std_logic_vector(11 downto 0);
variable vslv8_byteReadEna : std_logic_vector(7 downto 0);
variable vsl_ByteValid : std_logic;
begin
	vsl_cntEna := '1';
	vsl_readBit := '0';
	vslv12_data := slv12_fullBitTime;
	vslv8_byteReadEna := x"00";
	vsl_ByteValid := '0';
	case sm_ByteReaderSM is
		when st_Idle =>	
		vslv12_data := slv12_halfBitTime;
			vsl_cntEna := '0';
			if(isl_bitInput = '0')then
				vsl_cntEna := '1';
	            sm_ByteReaderSM_next <= st_Start;
			end if;
		when st_Start =>	
			if (sl_bitSync = '1') and (isl_bitInput = '0') then
				sm_ByteReaderSM_next <= st_BitStart;
				vsl_readBit := '1';
			end if;
		when st_BitStart =>	
			if (sl_bitSync = '1') then
				sm_ByteReaderSM_next <= st_Bit0;
				vslv8_byteReadEna := x"80";
				vsl_readBit := '1';
			end if;
		when st_Bit0 =>	
			if (sl_bitSync = '1') then
				vslv8_byteReadEna := x"40";
				sm_ByteReaderSM_next <= st_Bit1;
				vsl_readBit := '1';
			end if;
		when st_Bit1 =>	
			if (sl_bitSync = '1') then
				vslv8_byteReadEna := x"20";
				sm_ByteReaderSM_next <= st_Bit2;
				vsl_readBit := '1';
			end if;
		when st_Bit2 =>	
			if (sl_bitSync = '1') then
				vslv8_byteReadEna := x"10";
				sm_ByteReaderSM_next <= st_Bit3;
				vsl_readBit := '1';
			end if;
		when st_Bit3 =>	
			if (sl_bitSync = '1') then
				vslv8_byteReadEna := x"08";
				sm_ByteReaderSM_next <= st_Bit4;
				vsl_readBit := '1';
			end if;
		when st_Bit4 =>	
			if (sl_bitSync = '1') then
				vslv8_byteReadEna := x"04";
				sm_ByteReaderSM_next <= st_Bit5;
				vsl_readBit := '1';
			end if;
		when st_Bit5 =>	
			if (sl_bitSync = '1') then
				vslv8_byteReadEna := x"02";
				sm_ByteReaderSM_next <= st_Bit6;
				vsl_readBit := '1';
			end if;
		when st_Bit6 =>	
			if (sl_bitSync = '1') then
				vslv8_byteReadEna := x"01";
				sm_ByteReaderSM_next <= st_Bit7;
				vsl_readBit := '1';
			end if;
		when st_Bit7 =>	
			if (sl_bitSync = '1') then
				sm_ByteReaderSM_next <= st_BitStop0;
				vsl_ByteValid := '1';
				vslv12_data := slv12_halfBitTime;
				
			end if;
		when st_BitStop0 =>
			vslv12_data := slv12_halfBitTime;
			if(isl_bitInput = '0')then
				sm_ByteReaderSM_next <= st_Start;
			end if;	
			if (sl_bitSync = '1') then
				if(isl_bitInput = '0')then
					sm_ByteReaderSM_next <= st_Start;
				else	
					sm_ByteReaderSM_next <= st_Idle;
				end if;
			end if;
        WHEN others =>
            sm_ByteReaderSM_next <= st_Idle;
    END CASE;
    sl_cntEna_next <= vsl_cntEna;   
    sl_readBit_next <= vsl_readBit;
    slv12_data <= vslv12_data;
    slv8_byteReadEna <= vslv8_byteReadEna;
    sl_ByteValid <= vsl_ByteValid;
end process;

ByteReaderStateSM : process (
	isl_clk50Mhz
	) is
begin
    if (isl_rst = '1') then
        sm_ByteReaderSM <= st_Idle;
    elsif (rising_edge(isl_clk50Mhz)) then
    	sl_cntEna <= sl_cntEna_next;
    	sl_readBit <= sl_readBit_next;
        sm_ByteReaderSM <= sm_ByteReaderSM_next;
    END IF;
	
end process;	

readbits : process (
	slv8_byteReadEna
) is
begin
	if(slv8_byteReadEna(7) = '1') then
		slv8_byteRead(7) <= isl_bitInput;
	end if;	
	if(slv8_byteReadEna(6) = '1') then
		slv8_byteRead(6) <= isl_bitInput;
	end if;	
	if(slv8_byteReadEna(5) = '1') then
		slv8_byteRead(5) <= isl_bitInput;
	end if;	
	if(slv8_byteReadEna(4) = '1') then
		slv8_byteRead(4) <= isl_bitInput;
	end if;	
	if(slv8_byteReadEna(3) = '1') then
		slv8_byteRead(3) <= isl_bitInput;
	end if;	
	if(slv8_byteReadEna(2) = '1') then
		slv8_byteRead(2) <= isl_bitInput;
	end if;	
	if(slv8_byteReadEna(1) = '1') then
		slv8_byteRead(1) <= isl_bitInput;
	end if;	
	if(slv8_byteReadEna(0) = '1') then
		slv8_byteRead(0) <= isl_bitInput;
	end if;	
end process;	
	
	U_BaudRateCounter : baudrate_counter
		port map(

		clock		=> isl_clk50Mhz,--,: IN STD_LOGIC ;
		cnt_en		=> sl_cntEna,--: IN STD_LOGIC ;
		data		=> slv12_data,--,: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		sclr		=> sl_sclr,--,: IN STD_LOGIC ;
		sload		=> sl_sload,--,: IN STD_LOGIC ;
		sset		=> sl_sset,--,: IN STD_LOGIC ;
		q			=> slv12_q--: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);

	sl_bitValid <= slv8_byteReadEna(7) 
			or slv8_byteReadEna(6) 
			or slv8_byteReadEna(5) 
			or slv8_byteReadEna(4) 
			or slv8_byteReadEna(3) 
			or slv8_byteReadEna(2) 
			or slv8_byteReadEna(1) 
			or slv8_byteReadEna(0); 
	osl_bitValid <= sl_bitValid;
	osl_bitValue <= isl_bitInput;

end architecture RTL;
