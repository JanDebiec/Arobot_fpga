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
package cmdVel_parser_serial_pkg is
component cmdVel_parser_serial
generic (
    eslv8_MagicWord : std_logic_vector(7 downto 0) := x"a5";
    eslv8_CmdVelWord : std_logic_vector(7 downto 0) := x"00"
);
port (
    isl_clk50Mhz : in std_logic;
    isl_rst : in std_logic;
    isl_inByteValid : in std_logic;
    islv8_byteValue : in std_logic_vector(7 downto 0);
    oslv_shortA : out signed(15 downto 0);
    oslv_shortB : out signed(15 downto 0);
    osl_outputValid : out std_logic
);        
end component cmdVel_parser_serial;
            
end package cmdVel_parser_serial_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
    use work.arobot_typedef_pkg.all;
    use work.monoshot_pkg.all;

entity cmdVel_parser_serial is
generic (
    eslv8_MagicWord : std_logic_vector(7 downto 0) := x"a5";
    eslv8_CmdVelWord : std_logic_vector(7 downto 0) := x"00"
);
port (
    isl_clk50Mhz : in std_logic;
    isl_rst : in std_logic;
    isl_inByteValid : in std_logic;
    islv8_byteValue : in std_logic_vector(7 downto 0);
    oslv_shortA : out signed(15 downto 0);
    oslv_shortB : out signed(15 downto 0);
    osl_outputValid : out std_logic
);
end entity cmdVel_parser_serial;

architecture RTL of cmdVel_parser_serial is
    signal tShiftReg : SixBytesShiftRegs;
    signal sl_MagicFound : std_logic;
    signal sl_MagicFoundM : std_logic;
    signal sl_cmdVelFound : std_logic;
    signal sls_shortA : signed(15 downto 0);
    signal sls_shortB : signed(15 downto 0);
    signal slv16_shortA : std_logic_vector(15 downto 0);
    signal slv16_shortB : std_logic_vector(15 downto 0);
    
begin

osl_outputValid <= sl_cmdVelFound;
oslv_shortA <= sls_shortA;
oslv_shortB <= sls_shortB;
slv16_shortA <= tShiftReg(3) & tShiftReg(2);
slv16_shortB <= tShiftReg(1) & tShiftReg(0);

pVelOut : process(
    all
)
is
begin
    if isl_rst = '1' then
        sls_shortA <= x"0000";
        sls_shortB <= x"0000";
    else
        if rising_edge(isl_clk50Mhz) then
            if(sl_cmdVelFound = '1') then
                sls_shortA <= signed(slv16_shortA);
                sls_shortB <= signed(slv16_shortB);
            end if;    
        end if;
    end if;        
end process;    
    
pLatchReg : process(
    all
)
is
begin
    if isl_rst = '1' then
        tShiftReg(0) <= x"00";
        tShiftReg(1) <= x"00";
        tShiftReg(2) <= x"00";
        tShiftReg(3) <= x"00";
        tShiftReg(4) <= x"00";
        tShiftReg(5) <= x"00";
    else
        if rising_edge(isl_clk50Mhz) then
            if(isl_inByteValid = '1') then
                tShiftReg(5) <= tShiftReg(4);
                tShiftReg(4) <= tShiftReg(3);
                tShiftReg(3) <= tShiftReg(2);
                tShiftReg(2) <= tShiftReg(1);
                tShiftReg(1) <= tShiftReg(0);
                tShiftReg(0) <= islv8_byteValue;
            end if;    
        end if;
    end if;        
end process;

sl_MagicFound <= '1' when (tShiftReg(5) = eslv8_MagicWord ) else '0';
sl_cmdVelFound <= '1' when ((tShiftReg(4) = eslv8_cmdVelWord ) and (sl_MagicFoundM = '1')) else '0';
uMono : monoshot
port map
(
    isl_clk     => isl_clk50Mhz,--: in std_logic;
    isl_rst         => isl_rst,--: in std_logic;
    isl_input       => sl_MagicFound,
    osl_outputMono  => sl_MagicFoundM
);

end architecture RTL;
