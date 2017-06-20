----------------------------------------------------------------------
--! @file  delay2.vhd
--! @brief 
--!
--!
--! @author 
--! @date 
--! @version  
--! 
-- note 
--! @todo 
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

--!
package delay2_pkg is
component delay2 
port (
        clk : in std_logic;
        rst : in std_logic;
        input : in std_logic;
        output : out std_logic
);        
end component delay2;
            
end package delay2_pkg;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay2 is
    port (
        clk : in std_logic;
        rst : in std_logic;
        input : in std_logic;
        output : out std_logic
    );
end entity delay2;

--!
--!
--! @brief
--!
--! @detail 
--! 
--!
architecture RTL of delay2 is
    signal sl_inputD : std_logic;    
    signal sl_input2D : std_logic;    
--    signal sl_inputD : std_logic;    
begin

    output <= sl_input2D;
P : process(
  clk, input , rst 
)
begin
    if(rst = '1') then
        sl_input2D <= '0';
        sl_inputD <= '0';
    else    
        if(rising_edge(clk)) then
            sl_input2D <= sl_inputD;
            sl_inputD <= input;
        end if;
    end if;        
end process;    

end architecture RTL;
