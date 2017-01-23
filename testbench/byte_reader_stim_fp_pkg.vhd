Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions
Library work;           --use work.fpga_main_tcc.all;
                        --use work.fpga_main_stim_tcc.all;

PACKAGE byte_reader_stim_fp IS

procedure trtm_delay(
    signal clk      : in STD_LOGIC;
    signal delayCnt : in unsigned (11 downto 0)
    );
    
procedure trtm_setSignal(
    signal clk      : in STD_LOGIC;
    signal signName : out STD_LOGIC
    );

procedure bit_write(
	signal sl_clk50MHz : in std_logic
	--signal sl_bitValid : out std_logic
);
procedure byte_write(
	signal sl_clk50MHz : in std_logic;
	signal slv8_byteValue : in std_logic_vector(7 downto 0);
	signal sl_bitValue : out std_logic
);

end byte_reader_stim_fp;

package body byte_reader_stim_fp is

procedure byte_write(
	signal sl_clk50MHz : in std_logic;
	signal slv8_byteValue : in std_logic_vector(7 downto 0);
	signal sl_bitValue : out std_logic
	
		
) is
begin
	sl_bitValue <= '0';
	bit_write(sl_clk50MHz => sl_clk50MHz);
	sl_bitValue <= slv8_byteValue(7);
	bit_write(sl_clk50MHz => sl_clk50MHz);
	sl_bitValue <= slv8_byteValue(6);
	bit_write(sl_clk50MHz => sl_clk50MHz);
	sl_bitValue <= slv8_byteValue(5);
	bit_write(sl_clk50MHz => sl_clk50MHz);
	sl_bitValue <= slv8_byteValue(4);
	bit_write(sl_clk50MHz => sl_clk50MHz);
	sl_bitValue <= slv8_byteValue(3);
	bit_write(sl_clk50MHz => sl_clk50MHz);
	sl_bitValue <= slv8_byteValue(2);
	bit_write(sl_clk50MHz => sl_clk50MHz);
		sl_bitValue <= slv8_byteValue(1);
	bit_write(sl_clk50MHz => sl_clk50MHz);
		sl_bitValue <= slv8_byteValue(0);
	bit_write(sl_clk50MHz => sl_clk50MHz);
	
	--stop bit
		sl_bitValue <= '1';
	bit_write(sl_clk50MHz => sl_clk50MHz);
	
end;	

procedure bit_write(
	signal sl_clk50MHz : in std_logic
	--signal sl_bitValid : out std_logic
) is
begin
 	wait for 4000 ns;
 	wait until ((sl_clk50MHz = '1'));
 	--wait for 20 ns;
 	wait for 4000 ns;
end;	

procedure trtm_delay(
    signal clk      : in STD_LOGIC;
    signal delayCnt : in unsigned (11 downto 0)
    ) is
    variable us12_Count : unsigned (11 downto 0) := x"000";
    begin
        while (us12_Count < delayCnt) loop
            us12_Count := us12_Count + 1;
            wait until ((clk = '1') and (clk'event));
        end loop;-- 
    end;

procedure trtm_setSignal(
    signal clk      : in STD_LOGIC;
    signal signName : out STD_LOGIC
    ) is
    begin
        signName <= '1';-- 
        wait until ((clk = '1') and (clk'event));
        signName <= '0';-- 

        wait until ((clk = '1') and (clk'event));
    end;

end package body byte_reader_stim_fp;

