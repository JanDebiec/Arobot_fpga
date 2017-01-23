----------------------------------------------------------------------
--! @file  
--! @brief converts pulses into position
--!
--!
--! @author 
--! @date 
--! @version  0.2
--! 
--! note 
--! @todo add monoflop for input pulses, pulse length should be one
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
Library ieee;           
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
--
--! integrator_pkg
package integrator_pkg is
    component integrator 
    port (
		isl_clk50Mhz : in std_logic;--!
		isl_rst : in std_logic;--!
		isl_direction : in std_logic;--!
		isl_Pulse : in std_logic;--!
		on32_Position : out signed(31 downto 0)--!
    );        
    end component integrator;
            
end package integrator_pkg;

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
Library work;           
	use work.arobot_constant_pkg.all;	
	use work.arobot_component_pkg.all;	
    use work.monoshot_pkg.all;

--! integrator
entity integrator is
	port (
		isl_clk50Mhz : in std_logic;--!
		isl_rst : in std_logic;--!
		isl_direction : in std_logic;--!
		isl_Pulse : in std_logic;--!
		on32_Position : out signed(31 downto 0)--!
		
	);
end entity integrator;

architecture RTL of integrator is
	signal	n32_Position : signed(31 downto 0);--!
	signal	n32_Position_next : signed(31 downto 0);--!
	signal sl_inputMono : std_logic;
	
begin
on32_Position <= n32_Position;

-- for testing with long pulse
-- sl_inputMono <= isl_Pulse;

U_mono : monoshot
port map
(
		isl_clk 	=> isl_clk50Mhz,--: in std_logic;
		isl_rst 		=> isl_rst,--: in std_logic;
		isl_input 		=> isl_Pulse,
		osl_outputMono 	=> sl_inputMono
);


-- IS NOT WORKING FOR DOSYGEN
-----------------------------------------------------------------------------
 --! @brief Process to manage reception of nrzi bits
 --!
 --! Gets bits from the data recovery component and performs nrzi decoding. 
 --!
 --! @param[in]   isl_clk50Mhz  Clock, used on rising edge
 --! @param[in]   isl_Pulse  input pulse to increment7DECREMENT POSITION
-----------------------------------------------------------------------------
P_PosProcess : process(
	--all
	isl_clk50Mhz,
	sl_inputMono
) is
	variable vn32_Position : signed(31 downto 0);--!
begin
	vn32_Position := n32_Position;
	if(isl_rst = '1') then
		vn32_Position := x"0000_0000";
	else	
--		if(rising_edge(sl_inputMono) and (sl_inputMono = '1')) then
		if(sl_inputMono = '1') then
			if(isl_direction = '1') then
				vn32_Position := vn32_Position + 1;
			else
				vn32_Position := vn32_Position - 1;
			end if;		
		end if;
	end if;
	n32_Position_next <= vn32_Position;
end process;

P_PosProcessNext : process(
	isl_clk50Mhz,
	n32_Position_next
) is
begin
	if (rising_edge(isl_clk50Mhz)) then	
		n32_Position <= n32_Position_next;
	end if;
end process;		
end architecture RTL;
