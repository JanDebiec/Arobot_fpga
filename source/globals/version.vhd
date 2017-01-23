----------------------------------------------------------------------
--! @file  version.vhd
--! @brief 
--!
--! @author 
--! @date 09.11.2016
--! 
--! @note 
--!@page fpga_version fpga-versions
--! | version | date/item |
--! |:------:|:----------:|
--! |  0.2.0 | 21.01.2017 |
--! | | new version system |
----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

--!
package version_pkg is
component version 
port (
    oslv32_version : out std_logic_vector(31 downto 0)
);        
end component version;
            
end package version_pkg;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity version is
    port (
    oslv32_version : out std_logic_vector(31 downto 0)
    );
end entity version;

architecture RTL of version is
    constant cnMajor : integer := 0;
    constant cnMinor : integer := 2;
    constant cnBuild : integer := 0;
    signal slv8_Major : std_logic_vector(7 downto 0);    
    signal slv8_Minor : std_logic_vector(7 downto 0);    
    signal slv8_Build : std_logic_vector(7 downto 0);    
begin
    slv8_Major <= std_logic_vector(to_unsigned(cnMajor, 8));
    slv8_Minor <= std_logic_vector(to_unsigned(cnMinor, 8));
    slv8_Build <= std_logic_vector(to_unsigned(cnBuild, 8));
      
    oslv32_version <= x"00" & slv8_Major & slv8_Minor & slv8_Build;
end architecture RTL;
