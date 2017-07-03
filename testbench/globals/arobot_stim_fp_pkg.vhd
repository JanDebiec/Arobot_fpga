----------------------------------------------------------------------
--! @file  arobot_stim_fp_pkg.vhd
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
    use ieee.math_real.all;
library std;
    use std.textio.all;
library work;
    use work.arobot_stim_tcc_pkg.all;
    
package arobot_stim_fp_pkg is

	procedure H2FRead(
		signal clock      : in  std_logic;
		signal rec_H2fIn  : in  rec_H2fIn_type;
		signal rec_H2fOut : out rec_H2fOut_type
	);
 
	procedure H2FWrite(
		signal clock      : in  std_logic;
		signal rec_H2fIn  : in  rec_H2fIn_type;
		signal rec_H2fOut : out rec_H2fOut_type
	);
 
    procedure AdcSimulData(
        signal clock : in std_logic;
        signal slv16_OldData : in std_logic_vector(15 downto 0);
        signal slv16_NewData : out std_logic_vector(15 downto 0)
    );
    
    procedure ascii2nShort(
        signal ascii_string : in string(16 downto 1);
        signal nShort : out signed(15 downto 0)
    );
    
    procedure SpiMosi_TxByte(
        signal clk        : in std_logic;
        signal rec_SpiDataByte : in rec_SpiDataByte_type;
        signal rec_SpiMosi  : out rec_SpiMosi_type
    );

    procedure SpiMiso_TxByte(
        signal clk        : in std_logic;
        signal rec_SpiMiso  : out rec_SpiMiso_type
    );

    procedure Spi_TxRxByte(
        signal clk        : in std_logic;
        signal rec_SpiDataByte : in rec_SpiDataByte_type;
        signal rec_SpiMosi  : out rec_SpiMosi_type;
        signal rec_SpiMiso  : out rec_SpiMiso_type
    );

    procedure DpRAM_RdReq (
        signal clk        : in std_logic;
        signal rec_RAMIn  : in rec_RAMIn_type;
        signal rec_RAMOut : out rec_RAMOut_type
    );

    function init_mem(
        mif_file_name : in string
    ) return mem_type;
    
function checkNumber(constant actValue : integer;
    constant compValue : integer
) return boolean;

function checkSL(constant actValue : std_logic;
    constant compValue : std_logic
) return boolean;

function checkSlv32(constant actValue : std_logic_vector(31 downto 0);
    constant compValue : std_logic_vector(31 downto 0)
) return boolean;

function checkSlv2(constant actValue : std_logic_vector(1 downto 0);
    constant compValue : std_logic_vector(1 downto 0)
) return boolean;

function checkSlv1(constant actValue : std_logic_vector(0 downto 0);
    constant compValue : std_logic_vector(0 downto 0)
) return boolean;
 
--function checkSlv(constant actValue : std_logic_vector;
--    constant compValue : std_logic_vector
--) return boolean;
-- 
procedure Wire_TxWord(
	signal clk : in std_logic;
	signal data : in std_logic_vector(15 downto 0);
	signal dataValid : out std_logic;
	signal outData : out std_logic_vector(15 downto 0)
);

function isEqualSl(
		val1 : std_logic;
		val2 : std_logic
	) return boolean;
 
procedure handleOneSpiTxByteSignals(
    signal clk : in std_logic;
    signal txReq : out std_logic;
    signal txReady : out std_logic
);

end package arobot_stim_fp_pkg;

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library std;
    use std.textio.all;
library work;
    use work.arobot_stim_tcc_pkg.all;



package body arobot_stim_fp_pkg is

function checkNumber(constant actValue : integer;
    constant compValue : integer
) return boolean is
begin
    if actValue = compValue then
        return true;
    else
        return false;
    end if;        
end function;

function checkSL(constant actValue : std_logic;
    constant compValue : std_logic
) return boolean is
begin
    if actValue = compValue then
        return true;
    else
        return false;
    end if;        
end function;

function checkSlv32(constant actValue : std_logic_vector(31 downto 0);
    constant compValue : std_logic_vector(31 downto 0)
) return boolean is
begin
    if actValue = compValue then
        return true;
    else
        return false;
    end if;        
end function;

function checkSlv2(constant actValue : std_logic_vector(1 downto 0);
    constant compValue : std_logic_vector(1 downto 0)
) return boolean is
begin
    if actValue = compValue then
        return true;
    else
        return false;
    end if;        
end function;

function checkSlv1(constant actValue : std_logic_vector(0 downto 0);
    constant compValue : std_logic_vector(0 downto 0)
) return boolean is
begin
    if actValue = compValue then
        return true;
    else
        return false;
    end if;        
end function;

--function checkSlv(constant actValue : std_logic_vector;
--    constant compValue : std_logic_vector
--) return boolean is
--    variable vactValue : 
--begin
--    if actValue = compValue then
--        return true;
--    else
--        return false;
--    end if;        
--end function;

--procedure Spi_TxRxByte(
--    signal clk        : in std_logic;
--    signal rec_SpiDataByte : in rec_SpiDataByte_type;
--    signal rec_SpiMosi  : out rec_SpiMosi_type;
--    signal rec_SpiMiso  : out rec_SpiMiso_type
--) is
--alias mosi : std_logic is rec_SpiMosi.sl_SpiMosi;
--alias spi_clock : std_logic is rec_SpiMosi.sl_SpiClk;
--alias byte : std_logic_vector(7 downto 0) is rec_SpiDataByte.slv_Byte2Tx;
--variable SpiBit : std_logic;
--begin
--    wait until rising_edge(clk);
--    for i in 7 downto 0 loop
--        -- bit i
--        rec_SpiMosi.n_Index <= i;
--        SpiBit := rec_SpiDataByte.slv_Byte2Tx(i);
--        
--        wait until rising_edge(clk);
--        spi_clock <= '0';
--        mosi <= SpiBit;-- ;
--        wait until falling_edge(clk);
--        spi_clock <= '1';
--    end loop;
--    wait until rising_edge(clk);
--    spi_clock <= '0';
--end;    
procedure AdcSimulData(
    signal clock : in std_logic;
    signal slv16_OldData : in std_logic_vector(15 downto 0);
    signal slv16_NewData : out std_logic_vector(15 downto 0)
)is
    variable seed1, seed2: positive;               -- seed values for random generator
    variable rand: real;   -- random real-number value in range 0 to 1.0  
    variable range_of_rand : real := 1000.0;    -- the range of random values created will be 0 to +1000.
    variable rand_num : integer := 0;
    variable rand_num_old : integer;
begin
    rand_num_old := to_integer(unsigned(slv16_OldData));
    uniform(seed1, seed2, rand);   -- generate random number
    rand_num := rand_num_old + integer(rand*range_of_rand);  -- rescale to 0..1000, convert integer part 

    wait until rising_edge(clock);
    wait for 6 ns;
    slv16_NewData <= std_logic_vector(to_unsigned(rand_num, 16));
end;    
    


procedure SpiMosi_TxByte(
    signal clk        : in std_logic;
    signal rec_SpiDataByte : in rec_SpiDataByte_type;
    signal rec_SpiMosi  : out rec_SpiMosi_type
) is
alias mosi : std_logic is rec_SpiMosi.sl_SpiMosi;
alias spi_clock : std_logic is rec_SpiMosi.sl_SpiClk;
alias byte : std_logic_vector(7 downto 0) is rec_SpiDataByte.slv_Byte2Tx;
variable SpiBit : std_logic;
begin
    wait until rising_edge(clk);
    for i in 7 downto 0 loop
        -- bit i
        rec_SpiMosi.n_Index <= i;
        SpiBit := rec_SpiDataByte.slv_Byte2Tx(i);
        
        wait until rising_edge(clk);
        spi_clock <= '0';
        mosi <= SpiBit;-- ;
        wait until falling_edge(clk);
        spi_clock <= '1';
    end loop;
    wait until rising_edge(clk);
    spi_clock <= '0';
end;    

procedure SpiMiso_TxByte(
    signal clk        : in std_logic;
    signal rec_SpiMiso  : out rec_SpiMiso_type
) is
alias spi_clock : std_logic is rec_SpiMiso.sl_SpiClk;
begin
    wait until falling_edge(clk);
    for i in 7 downto 0 loop
        -- bit i
        rec_SpiMiso.n_Index <= i;
        spi_clock <= '0';
        
        wait until rising_edge(clk);
        spi_clock <= '1';
        wait until falling_edge(clk);
    end loop;
    spi_clock <= '0';
--   wait until rising_edge(clk);
--    spi_clock <= '0';
end;    

procedure Spi_TxRxByte(
    signal clk        : in std_logic;
    signal rec_SpiDataByte : in rec_SpiDataByte_type;
    signal rec_SpiMosi  : out rec_SpiMosi_type;
    signal rec_SpiMiso  : out rec_SpiMiso_type
) is
alias mosi : std_logic is rec_SpiMosi.sl_SpiMosi;
alias spi_clock : std_logic is rec_SpiMosi.sl_SpiClk;
alias byte : std_logic_vector(7 downto 0) is rec_SpiDataByte.slv_Byte2Tx;
variable SpiBit : std_logic;
begin
    wait until rising_edge(clk);
    for i in 7 downto 0 loop
        -- bit i
        rec_SpiMosi.n_Index <= i;
        SpiBit := rec_SpiDataByte.slv_Byte2Tx(i);
        
        wait until rising_edge(clk);
        spi_clock <= '0';
        mosi <= SpiBit;-- ;
        wait until falling_edge(clk);
        spi_clock <= '1';
    end loop;
    wait until rising_edge(clk);
    spi_clock <= '0';
end;    


procedure DpRAM_RdReq (
    signal clk        : in std_logic;
    signal rec_RAMIn  : in rec_RAMIn_type;
    signal rec_RAMOut : out rec_RAMOut_type
) is
    alias Addr        : std_logic_vector(9 downto 0) is rec_RAMIn.slv10_Addr;
    alias RdReq       : std_logic is rec_RAMIn.sl_RdReq;
    alias outputValid : std_logic is rec_RAMOut.sl_outputValid;
    alias outputValue : std_logic_vector(15 downto 0) is rec_RAMOut.slv16_outputValue;
    alias state : std_logic_vector(3 downto 0) is rec_RAMOut.slv4_state;
begin
    state <= x"0";
    wait until rising_edge(RdReq);
    state <= x"1";
    -- wait some clocks    
    wait until rising_edge(clk);
    state <= x"2";
    wait until rising_edge(clk);
    state <= x"3";
    outputValue <= "010100" & Addr; -- dummy value to see something
    wait until rising_edge(clk);
    state <= x"4";
  
    outputValid <= '1';
    wait until rising_edge(clk);
    state <= x"5";
    outputValid <= '0';
    wait until rising_edge(clk);
    state <= x"6";
    outputValue <= (others => 'Z');
end;    


procedure H2FRead(
	signal clock      : in  std_logic;
	signal rec_H2fIn  : in  rec_H2fIn_type;
	signal rec_H2fOut : out rec_H2fOut_type
)is
    alias ExtAddr : std_logic_vector(7 downto 0) is rec_H2fOut.slv8_ext_lw_bus_address;
    alias CmdAddr : std_logic_vector(7 downto 0) is rec_H2fIn.slv8_address;
    alias ExtData : std_logic_vector(31 downto 0) is rec_H2fIn.slv32_ext_lw_bus_read_data;
    alias ReadData : std_logic_vector(31 downto 0) is rec_H2fOut.slv32_read_data;
    alias ChipSel : std_logic is rec_H2fOut.sl_ext_lw_bus_bus_enable;
    alias RWn     : std_logic is rec_H2fOut.sl_ext_lw_bus_rw;
    alias ack     : std_logic is rec_H2fIn.sl_ext_lw_bus_acknowledge;
    alias state   : std_logic_vector(3 downto 0) is rec_H2fOut.slv4_state;
begin
    state <= x"0";
    ChipSel <= '0'; 
    wait until rising_edge(clock);
    state <= x"1";
    ChipSel <= '1'; 
    RWn <= '1';
    ExtAddr <= CmdAddr;
    wait until rising_edge(ack);
    ReadData <= ExtData;
    wait until rising_edge(clock);
    state <= x"4";
    ChipSel <= '0'; 
--    RWn <= '1';
    
end;
 
procedure H2FWrite(
	signal clock      : in  std_logic;
	signal rec_H2fIn  : in  rec_H2fIn_type;
	signal rec_H2fOut : out rec_H2fOut_type
)is
    alias ExtAddr : std_logic_vector(7 downto 0) is rec_H2fOut.slv8_ext_lw_bus_address;
    alias CmdAddr : std_logic_vector(7 downto 0) is rec_H2fIn.slv8_address;
    alias ChipSel : std_logic is rec_H2fOut.sl_ext_lw_bus_bus_enable;
    alias RWn     : std_logic is rec_H2fOut.sl_ext_lw_bus_rw;
    alias ack     : std_logic is rec_H2fIn.sl_ext_lw_bus_acknowledge;
    alias state   : std_logic_vector(3 downto 0) is rec_H2fOut.slv4_state;
begin
    state <= x"0";
    ChipSel <= '0'; 
    wait until rising_edge(clock);
    state <= x"1";
    ChipSel <= '1'; 
    RWn <= '0';
    ExtAddr <= CmdAddr;
    wait until rising_edge(ack);
    state <= x"2";
    wait until rising_edge(clock);
    state <= x"3";
    ChipSel <= '1'; 
    wait until rising_edge(clock);
end;

procedure ascii2nShort(
    signal ascii_string : in string(16 downto 1);
    signal nShort : out signed(15 downto 0)
) is
    variable char : character := '0';
    variable j : integer;
begin
    for j in 16 downto 1 loop
        char := ascii_string(j);
        if(char = '0') then
            nShort(j - 1) <= '0';
        else
            nShort(j - 1) <= '1';
        end if;    
    end loop;
end;    
    
function init_mem(
    mif_file_name : in string
) return mem_type
is
    file file_pointer : text;-- open read_mode is mif_file_name;
    variable mif_line : line;
    variable vShort_ascii : string(16 downto 1);
    variable nShort : signed(15 downto 0);
--    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : mem_type;
    variable i : integer := 0;
    variable j : integer := 0;
    variable char : character := '0';
begin
       --Open the file mif_file_name from the specified location for reading(READ_MODE).
    file_open(file_pointer,mif_file_name,READ_MODE);  -- ignore some first lines
    for i in mem_type'range loop
        readline(file_pointer, mif_line);
        read(mif_line, vShort_ascii);
        for j in 16 downto 1 loop
            char := vShort_ascii(j);
            if(char = '0') then
                nShort(j - 1) := '0';
            else
                nShort(j - 1) := '1';
            end if;    
        end loop;
        temp_mem(i) := nShort;
    end loop;
    file_close(file_pointer);
    return temp_mem;
end function;    

procedure Wire_TxWord(
	signal clk : in std_logic;
	signal data : in std_logic_vector(15 downto 0);
	signal dataValid : out std_logic;
	signal outData : out std_logic_vector(15 downto 0)
) is
begin
	wait until rising_edge(clk);
	outData <= data;
	wait until rising_edge(clk);
	dataValid <= '1';
	wait until rising_edge(clk);
	dataValid <= '0';
	wait until rising_edge(clk);
	outData <= x"0000";--others => 'Z';
	
end procedure;	 

function isEqualSl(
		val1 : std_logic;
		val2 : std_logic
	) return boolean is
	variable retFlag : boolean := false;
begin
	retFlag := true when (val1 = val2) else
				false;
	return retFlag;			
end;

procedure handleOneSpiTxByteSignals(
    signal clk : in std_logic;
    signal txReq : out std_logic;
    signal txReady : out std_logic
) is
begin
--    wait 100 ns;
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    txReq <= '1';
    wait until rising_edge(clk);
    txReq <= '0';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    txReady <= '1';
    wait until rising_edge(clk);
    txReady <= '0';
end procedure;    

end package body arobot_stim_fp_pkg;
