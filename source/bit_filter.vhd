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
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;
--
package bit_filter_pkg is
    component bit_filter 
    port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_inputRaw : in std_logic;
		osl_outputFiltered : out std_logic
    );        
    end component bit_filter;
            
end package bit_filter_pkg;

library ieee;
	use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;

entity bit_filter is
	generic (filter_depth : integer := 16);
	port (
		isl_clk50Mhz : in std_logic;
		isl_rst : in std_logic;
		isl_inputRaw : in std_logic;
		osl_outputFiltered : out std_logic
	);
end entity bit_filter;

architecture RTL of bit_filter is
	signal sl_outputFiltered_next : std_logic;
	signal un_filteredValue : integer := 0;
	signal un_filteredValue_next : integer := 0;
	signal sl_outputFiltered : std_logic;
	signal n_filter_depth : integer := filter_depth;
begin


FilterSM : process (
	isl_inputRaw,
--	isl_clk50Mhz,
	un_filteredValue,
	n_filter_depth,
	sl_outputFiltered
	
) is
variable vsl_FilteredOutput : std_logic;
variable vn_filteredTempValue : integer;
variable vn_ThresholdH : integer;
variable vn_ThresholdL : integer;

begin
	vn_ThresholdH := n_filter_depth * 3 / 4;
	vn_ThresholdL := n_filter_depth / 4;
	vn_filteredTempValue := un_filteredValue;
	vsl_FilteredOutput := sl_outputFiltered;
		if(isl_inputRaw = '1') then
			vn_filteredTempValue := vn_filteredTempValue + 1;
			if(vn_filteredTempValue > n_filter_depth) then
				vn_filteredTempValue := n_filter_depth;
			end if;	
		else
			vn_filteredTempValue := vn_filteredTempValue -1;
			if(vn_filteredTempValue < 0) then
				vn_filteredTempValue := 0;
			end if;	
		end if;
    
	    if(sl_outputFiltered = '0') then
	    	if(vn_filteredTempValue >= vn_ThresholdH) then
	    		vsl_FilteredOutput := '1';
	    	else
	    		vsl_FilteredOutput := '0';	
	    	end if;	
	    else
	    	if(vn_filteredTempValue <= vn_ThresholdL) then
	    		vsl_FilteredOutput := '0';
	    	else
	    		vsl_FilteredOutput := '1';
	    	end if;	
	    end if;	
    sl_outputFiltered_next <= vsl_FilteredOutput;
    un_filteredValue_next <= vn_filteredTempValue;
end process;

FilterStateSM : PROCESS (isl_clk50Mhz) IS
BEGIN
    if (isl_rst = '1') then
        sl_outputFiltered <= '0';
    elsif (rising_edge(isl_clk50Mhz)) then
    	sl_outputFiltered <= sl_outputFiltered_next;
    	un_filteredValue <= un_filteredValue_next;
    END IF;
END PROCESS;

osl_outputFiltered <= sl_outputFiltered;
end architecture RTL;
