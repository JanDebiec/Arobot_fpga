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
package cmdVel_parser_pkg is
component cmdVel_parser 
--generic (
--    eslv8_MagicWord : std_logic_vector(7 downto 0) := x"a5";
--    eslv8_CmdVelWord : std_logic_vector(7 downto 0) := x"00"
--);
port (
    isl_clk50Mhz : in std_logic;
    isl_rst : in std_logic;
    isl_inByteValid : in std_logic;
    islv8_byteValue : in std_logic_vector(7 downto 0);
    oslv_VelocityA : out signed(31 downto 0);
    oslv_VelocityB : out signed(31 downto 0);
    osl_outputValid : out std_logic
);        
end component cmdVel_parser;
            
end package cmdVel_parser_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
    use work.arobot_constant_pkg.all;
    use work.arobot_typedef_pkg.all;
    use work.monoshot_pkg.all;

entity cmdVel_parser is
--generic (
--    eslv8_MagicWord0 : std_logic_vector(7 downto 0) := x"aa";
--    eslv8_MagicWord1 : std_logic_vector(7 downto 0) := x"55";
--    eslv8_CmdVelWord : std_logic_vector(7 downto 0) := x"00"
--);
port (
    isl_clk50Mhz : in std_logic;
    isl_rst : in std_logic;
    isl_inByteValid : in std_logic;
    islv8_byteValue : in std_logic_vector(7 downto 0);
    oslv_VelocityA : out signed(31 downto 0);
    oslv_VelocityB : out signed(31 downto 0);
    osl_outputValid : out std_logic
);
end entity cmdVel_parser;

architecture RTL of cmdVel_parser is
    signal tShiftReg : TwelveBytesShiftRegs;
    signal sl_MagicFound : std_logic;
    signal sl_MagicFoundM : std_logic;
    signal sl_cmdVelFound : std_logic;
    signal sls_VelocityA : signed(31 downto 0);
    signal sls_VelocityB : signed(31 downto 0);
    signal slv32_commandA : std_logic_vector(31 downto 0);
    signal slv32_commandB : std_logic_vector(31 downto 0);
    
begin

osl_outputValid <= sl_cmdVelFound;
oslv_VelocityA <= sls_VelocityA;
oslv_VelocityB <= sls_VelocityB;
slv32_commandA <= tShiftReg(7) & tShiftReg(6) & tShiftReg(5) & tShiftReg(4);
slv32_commandB <= tShiftReg(3) & tShiftReg(2) & tShiftReg(1) & tShiftReg(0);

pVelOut : process(
    all
)
is
begin
    if isl_rst = '1' then
        sls_VelocityA <= x"00000000";
        sls_VelocityB <= x"00000000";
    else
        if rising_edge(isl_clk50Mhz) then
            if(sl_cmdVelFound = '1') then
                sls_VelocityA <= signed(slv32_commandA);
                sls_VelocityB <= signed(slv32_commandB);
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
        tShiftReg(6) <= x"00";
        tShiftReg(7) <= x"00";
        tShiftReg(8) <= x"00";
        tShiftReg(9) <= x"00";
        tShiftReg(10) <= x"00";
        tShiftReg(11) <= x"00";
    else
        if rising_edge(isl_clk50Mhz) then
            if(isl_inByteValid = '1') then
                tShiftReg(11) <= tShiftReg(10);
                tShiftReg(10) <= tShiftReg(9);
                tShiftReg(9) <= tShiftReg(8);
                tShiftReg(8) <= tShiftReg(7);
                tShiftReg(7) <= tShiftReg(6);
                tShiftReg(6) <= tShiftReg(5);
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

sl_MagicFound <= '1' when ((tShiftReg(11)  = eslv8_MagicByte0 ) 
                            and (tShiftReg(10)  = eslv8_MagicByte1))
                    else '0';
sl_cmdVelFound <= '1' when (((tShiftReg(9) &  tShiftReg(8)) = eslv16_CmdVelocity ) 
                            and (sl_MagicFoundM = '1')) 
                            else '0';
uMono : monoshot
port map
(
    isl_clk     => isl_clk50Mhz,--: in std_logic;
    isl_rst         => isl_rst,--: in std_logic;
    isl_input       => sl_MagicFound,
    osl_outputMono  => sl_MagicFoundM
);

end architecture RTL;
