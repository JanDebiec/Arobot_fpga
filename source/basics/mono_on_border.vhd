----------------------------------------------------------------------
--! @file  
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
--+++ synch len = 3
Library ieee;           use ieee.std_logic_1164.all;
                        use ieee.std_logic_unsigned.all;
                        use ieee.numeric_std.all;


package mono_on_border_pkg is
    COMPONENT mono_on_border
    PORT
    (
    i_InputClock    : in  STD_LOGIC;--
    i_OutputClock   : in  STD_LOGIC;--
    i_Input         : in  STD_LOGIC;--
    i_Reset         : in  STD_LOGIC;--
    o_Output        : out STD_LOGIC     --
    );
    END COMPONENT;    
end mono_on_border_pkg;
    
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
Library work;           
    use work.srflipflop_pkg.all;
    use work.deflipflop_pkg.all;



 entity mono_on_border is
port
(
    i_InputClock    : in  STD_LOGIC;--
    i_OutputClock   : in  STD_LOGIC;--
    i_Input         : in  STD_LOGIC;--
    i_Reset         : in  STD_LOGIC;--
    o_Output        : out STD_LOGIC     --
);
end mono_on_border;

--!
--!
--! @brief
--!
--! @detail 
--! 
--!
architecture rtl of mono_on_border is

    signal r_InputInput : STD_LOGIC := '0';--: DFFE;
    signal r_InputFeedback: STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";--[2..0] : DFFE;
    signal r_InputSR : STD_LOGIC:= '0';--: SRFFE;
    signal r_InputSRSet: STD_LOGIC:= '0';--
    signal r_OutputLatch: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";--[3..0] : DFFE;
BEGIN
------------------------------------------------------------------
-- Input clock domain
    InputInput : deflipflop port map(i_InputClock, i_Input, '1', i_Reset, r_InputInput );
--  r_InputInput.clk = i_InputClock;
--  r_InputInput.d = i_Input;
    
--  r_InputSR.clk = i_InputClock;
    r_InputSRSet <= '1' when (i_Input = '1') and (r_InputInput = '0') else '0';
--  r_InputSR.s = i_Input and !r_InputInput.q;
--  r_InputSR.r = r_InputFeedback[2].q;
    InputSR : srflipflop port map(i_InputClock, r_InputSRSet, r_InputFeedback(2), i_Reset, r_InputSR );
    
    InputFeedback : process(i_InputClock)
    begin
        if (rising_edge(i_InputClock)) then
            r_InputFeedback(1) <= r_InputFeedback(0); 
            r_InputFeedback(2) <= r_InputFeedback(1); 
    
            -- barrier
            r_InputFeedback(0) <= r_OutputLatch(2);
        end if;
    end process;
--  r_InputFeedback[2..0].clk = i_InputClock;
--  r_InputFeedback[1].d = r_InputFeedback[0].q; 
--  r_InputFeedback[2].d = r_InputFeedback[1].q; 
    
------------------------------------------------------------------
-- barrier
--  r_InputFeedback[0].d = r_OutputLatch[2].q;
--  r_OutputLatch[0].d = r_InputSR.q;

------------------------------------------------------------------
-- Output clock domain
--  r_OutputLatch[3..0].clk = i_OutputClock;
--  r_OutputLatch[1].d = r_OutputLatch[0].q; 
--  r_OutputLatch[2].d = r_OutputLatch[1].q; 
--  r_OutputLatch[3].d = r_OutputLatch[2].q; 
    OutputLatch : process(i_OutputClock)
    begin
        if (rising_edge(i_OutputClock)) then
            r_OutputLatch(1) <= r_OutputLatch(0);
            r_OutputLatch(2) <= r_OutputLatch(1); 
            r_OutputLatch(3) <= r_OutputLatch(2); 
            r_OutputLatch(0) <= r_InputSR;
        end if;
    end process;    
    
--  o_Output = r_OutputLatch[2].q and !r_OutputLatch[3];
    o_Output <= '1' when ((r_OutputLatch(2) = '1') and (r_OutputLatch(3) = '0')) else '0';

END rtl;
