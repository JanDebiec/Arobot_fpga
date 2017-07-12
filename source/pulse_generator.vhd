----------------------------------------------------------------------
--! @file pulse_generator.vhd  
--! @brief generator pulses count proportional to velocity
--!
-- pulse generator:
-- we have two options, to set the proper time axis:
-- A option: we set timer with constant settings, 
-- to generate constant internal timer tick. 
-- Input values, in16_Value, will define how much pulse pro one timer tick
-- should be considered onTimeTick
--!

--TODO: we need external generator, which defines timerSettings,
-- and coordinates with timerTick
--! it is slice-tick.vhd, 50 ms
--!
--!
-- B option: isl_inputValid is master to validate input
-- both timer, input shift latch and pulse generator are running independet,
-- asynchronous.
-- in16_Value will be valid for the next internal timerTick 
--!
--! @author 
--! @date 
--! @version  
--! 
--! note 
--! @todo check why pulse length was 50 ticks, 
--! In the next blocks, we need one tick per pulse
--!
--! @test 
--! @bug  
--!
----------------------------------------------------------------------
Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
--
--!
package pulse_generator_pkg is
    component pulse_generator 
    generic(
        bModelSim           : boolean := FALSE
    );
    port (
		isl_clk50Mhz 		: in std_logic;
		isl_rst 			: in std_logic;
		in16_Value 			: in signed (15 downto 0);
--		isl_inputValid 		: in std_logic;
--		iun32_timerSettings : in unsigned(31 downto 0);-- 2625a0 internal 
		osl_pulseOutput 	: out std_logic
    );        
    end component pulse_generator;
            
end package pulse_generator_pkg;


library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
library work;
	use work.arobot_constant_pkg.all;	
	use work.arobot_component_pkg.all;	

--!
entity pulse_generator is
    generic(
        bModelSim           : boolean := FALSE
    );
	port (
		isl_clk50Mhz 		: in std_logic;--!
		isl_rst 			: in std_logic;--!
		in16_Value 			: in signed (15 downto 0);--! velocity value
--		isl_inputValid 		: in std_logic;
--		iun32_timerSettings : in unsigned(31 downto 0);-- 2625a0 internal 
		osl_pulseOutput 	: out std_logic --!
	);
end entity pulse_generator;

architecture RTL of pulse_generator is

	type sm_PulseGeneratorEna_Type is (
		st_Idle,
		st_Running,
		st_Stopping
	);
	signal sm_PulseEnaSM, sm_PulseEnaSM_Next : sm_PulseGeneratorEna_Type;

	type sm_PulsGenRun_Type is (
		st_Idle,
		st_On,
		st_Off
	);
	signal sm_PulsRunSM, sm_PulsRunSM_Next : sm_PulsGenRun_Type;
	
	signal n16_absValue 			: signed(15 downto 0);
--	signal n16_negValue 			: signed(15 downto 0);
	constant un16_Zero 				: signed(15 downto 0) := x"0000";
	constant un32_Zero 				: signed(31 downto 0) := x"0000_0000";
    constant un32_One              : signed(31 downto 0) := x"0000_0001";
	constant un16_One 				: signed(15 downto 0) := x"0001";
	signal n16_ValueShadow 			: signed(15 downto 0);

-- real values for 50 ms
	constant un32_TickTimerSetting 			: signed(31 downto 0) := x"0026_25a0";-- ca 2.5 mln
	constant un32_PulsePauseOneSetting		: signed(31 downto 0) := x"0026_2400";
	signal un32_TickTimerCounter 			: signed(31 downto 0);
-- orig
	constant un32_PulseTimeSetting			: signed(31 downto 0) := x"0000_0032";-- 50 dec
	signal un32_PulsePauseActSetting		: signed(31 downto 0);
	signal slv32_PulsePauseDivided			: std_logic_vector(31 downto 0);
	signal slv32_PulsePauseDividedShadow	: std_logic_vector(31 downto 0);
	signal un32_PulseTimeCounter			: signed(31 downto 0);
	signal un32_PulsePauseCounter			: signed(31 downto 0);
	signal sl_PulseTimeEnable 		: std_logic;
--	signal sl_PulseTimeEnableNext	: std_logic;
	signal sl_PulsePauseEnable 		: std_logic;
--	signal sl_PulsePauseEnableNext	: std_logic;
	signal sl_checkInput 			: std_logic;
	signal sl_SyncNewDelay 			: std_logic;
	signal sl_PulseTimeReached 		: std_logic;
	signal sl_PulsePauseReached 	: std_logic;
	
begin
	


osl_pulseOutput <= sl_PulseTimeEnable;
n16_ValueShadow <= in16_Value when (sl_checkInput = '1');
slv32_PulsePauseDividedShadow <= slv32_PulsePauseDivided;-- when(sl_SyncNewDelay = '1');
--!
U_divider : u32_div_u16
		port map(

		clock		=> isl_clk50Mhz,--,: IN STD_LOGIC ;
		denom		=> std_logic_vector(n16_absValue),--: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		numer		=> std_logic_vector(un32_TickTimerSetting),--: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		quotient	=> slv32_PulsePauseDivided,--: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		remain		=> open--: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);

n16_absValue <= abs(in16_Value);

un32_PulsePauseActSetting <= 
	un32_TickTimerSetting when(in16_Value = un16_Zero) else
	un32_PulsePauseOneSetting when(n16_absValue = un16_One) else
	signed(slv32_PulsePauseDividedShadow);	

--!
P_PulseGenEna_comb : process (
    sm_PulseEnaSM,
    n16_absValue,
	isl_clk50Mhz,
	sl_checkInput
) is
begin
	case sm_PulseEnaSM is
	when st_Idle =>
		if(sl_checkInput = '1') then
			if(n16_absValue = un16_Zero) then
				sm_PulseEnaSM_next <= st_Idle;
			else
				sm_PulseEnaSM_next <= st_Running;
			end if;
		else
			sm_PulseEnaSM_next <= st_Idle;
		end if;	
	when st_Running =>
		if(sl_checkInput = '1') then
			if(n16_absValue = un16_Zero) then
				sm_PulseEnaSM_next <= st_Stopping;
			else
				sm_PulseEnaSM_next <= st_Running;
			end if;
		else	
			sm_PulseEnaSM_next <= st_Running;
		end if;	
	when st_Stopping =>
		sm_PulseEnaSM_next <= st_Idle;
	when others =>
		sm_PulseEnaSM_next <= st_Idle;
	end case;		
end process;	

P_PulseGenEna_seq : process (
	isl_clk50Mhz
	) is
begin
    if (isl_rst = '1') then
        sm_PulseEnaSM <= st_Idle;
    elsif (rising_edge(isl_clk50Mhz)) then
        sm_PulseEnaSM <= sm_PulseEnaSM_next;
    END IF;
	
end process;	

--!
P_PulsGenRun_comb : process (
	--all
	isl_clk50Mhz,
	sl_PulseTimeReached,
	sl_PulsePauseReached
) is
begin
if(rising_edge(isl_clk50Mhz) and (isl_clk50Mhz = '1')) then
	case sm_PulsRunSM is
	when st_Idle =>	
		if(sm_PulseEnaSM = st_Running) then
			sm_PulsRunSM_Next <= st_On;
		end if;	
	when st_On =>
			if(sl_PulseTimeReached = '1') then -- check end of pulse time
				sl_SyncNewDelay <= '1';
				sm_PulsRunSM_Next <= st_Off;
			end if;	
		when st_Off =>	
			-- check end of break time
			if(sl_PulsePauseReached = '1') then
				if(sm_PulseEnaSM = st_Running) then
					sm_PulsRunSM_Next <= st_On;
				end if;	
			end if;	
		when others =>	
			sm_PulsRunSM_Next <= st_Idle;
	end case;	
end if;
end process;


--!
P_PulseGenRun_seq : process (
	isl_clk50Mhz
	) is
begin
    if (isl_rst = '1') then
        sm_PulsRunSM <= st_Idle;
    elsif ((rising_edge(isl_clk50Mhz))and (isl_clk50Mhz = '1')) then
        sm_PulsRunSM <= sm_PulsRunSM_Next;
    END IF;
	
end process;
	
--!
P_PulseTimePauseEna : process(
	isl_clk50Mhz,
	sm_PulsRunSM,
	sl_PulseTimeReached,
	sl_PulsePauseReached
	
) is
begin
	case sm_PulsRunSM is
	when st_Idle =>	
--		if(sm_PulseEnaSM = st_Running) then
			sl_PulseTimeEnable <= '0';
			sl_PulsePauseEnable <= '0';
--		end if;	
	when st_On =>
			if(sl_PulseTimeReached = '1') then -- check end of pulse time
				sl_SyncNewDelay <= '1';

				sl_PulseTimeEnable <= '0';
				sl_PulsePauseEnable <= '1';
			else
				sl_PulseTimeEnable <= '1';
				sl_PulsePauseEnable <= '0';
			end if;	
		when st_Off =>	
			-- check end of break time
			--sl_PulseTimeEnable <= '0';
			if(sl_PulsePauseReached = '1') then
				if(sm_PulseEnaSM = st_Running) then
					sl_PulseTimeEnable <= '1';
					sl_PulsePauseEnable <= '0';
				else
					sl_PulseTimeEnable <= '0';
					sl_PulsePauseEnable <= '0';
				end if;	
			else
				sl_PulseTimeEnable <= '0';
				sl_PulsePauseEnable <= '1';
			end if;	
		when others =>	
			sl_PulseTimeEnable <= '0';
			sl_PulsePauseEnable <= '0';
	end case;	
end process;	


--!
P_PulsePauseGenerator : process (
	isl_clk50Mhz
) is
begin
if((isl_clk50Mhz = '1') and(isl_clk50Mhz'event)) then
    if (isl_rst = '1') then
        un32_PulsePauseCounter <= un32_One;
	elsif(sl_PulsePauseEnable = '1') then
		if(un32_PulsePauseCounter = un32_Zero) then
			un32_PulsePauseCounter <= un32_PulsePauseActSetting;
			sl_PulsePauseReached <= '1';
		else
			un32_PulsePauseCounter <= un32_PulsePauseCounter - 1;
			sl_PulsePauseReached <= '0';
		end if;	 	
	end if;	
end if;
end process;	

--!
P_PulseTimeGenerator : process (
	isl_clk50Mhz,
	sl_PulseTimeEnable
) is
begin
if((isl_clk50Mhz = '1') and(isl_clk50Mhz'event)) then
    if (isl_rst = '1') then
            un32_PulseTimeCounter <= un32_One;
            sl_PulseTimeReached <= '0';
	elsif(sl_PulseTimeEnable = '1') then
		if(un32_PulseTimeCounter = un32_Zero) then
			un32_PulseTimeCounter <= un32_PulseTimeSetting;
			sl_PulseTimeReached <= '1';
		else
			sl_PulseTimeReached <= '0';
			un32_PulseTimeCounter <= un32_PulseTimeCounter - 1;
			--sl_SyncNewDelay <= '0';
		end if;	 	
--	else
--		sl_PulseTimeReached <= '0';
--		un32_PulseTimeCounter <= un32_PulseTimeSetting;
	end if;	
end if;
end process;	

--!
P_TickGenerator : process (
	isl_clk50Mhz
) is
	
begin
    if (isl_rst = '1') then
            un32_TickTimerCounter <= un32_One;
	elsif((isl_clk50Mhz = '1') and(isl_clk50Mhz'event)) then
		if(un32_TickTimerCounter = un32_Zero) then
			un32_TickTimerCounter <= un32_TickTimerSetting;
			sl_checkInput <= '1'; 
		else
			un32_TickTimerCounter <= un32_TickTimerCounter - 1;
			sl_checkInput <= '0'; 
		end if;	 	
	end if;
end process;	


end architecture RTL;
