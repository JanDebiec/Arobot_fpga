----------------------------------------------------------------------
--! @file  
--! @brief single shot on positive edge
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
package monoshot_pkg is
    component monoshot 
    generic(
        bModelSim           : boolean := FALSE
    );
    port (
		isl_clk 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_input			: in std_logic;	--!
		osl_outputMono		: out std_logic --! pwm output
    );        
    end component monoshot;
            
end package monoshot_pkg;
	
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

-----------------------------------------------------------------------------
 --! @brief mono-shot, one clock pulse on positive edge
 --!
 --!
 --! @param[in] isl_clk  Clock, used on rising edge
 --! @param[in] isl_input  input signal, positive edge -> output single-shot
 --!			one clock delay		
-----------------------------------------------------------------------------
entity monoshot is
    generic(
        bModelSim           : boolean := FALSE
    );
	port (
		isl_clk 		: in std_logic;	--! master clock 50 MHz
		isl_rst 			: in std_logic;	--! master reset active high
		isl_input			: in std_logic;	--!
		osl_outputMono		: out std_logic --! pwm output
	);
end entity monoshot;

--!
--!
--! @brief
--!
--! @detail 
--! 
--!
architecture RTL of monoshot is
     signal sl_input_d		: STD_LOGIC;
     signal sl_input_dd		: STD_LOGIC;
     signal sl_input_ddd	: STD_LOGIC;
begin
	
P_D :   process(isl_clk)
    begin
         if isl_clk= '1' and isl_clk'event then
               sl_input_d <= isl_input;
         end if;
    end process;	

P_DD :   process(isl_clk)
    begin
         if isl_clk= '1' and isl_clk'event then
               sl_input_dd <= sl_input_d;
         end if;
    end process;	

P_DDD :   process(isl_clk)
    begin
         if isl_clk= '1' and isl_clk'event then
               sl_input_ddd <= sl_input_dd;
         end if;
    end process;
    
   osl_outputMono <= (not sl_input_ddd) and (sl_input_dd);
    	
end architecture RTL;
	
	