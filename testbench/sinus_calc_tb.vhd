Library ieee;           
	use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
USE ieee.math_real.ALL;  

Library work;           
    use work.arobot_base_stim_fp.all;
    use work.sinus_calc_pkg.all;
entity sinus_calc_TB is
end sinus_calc_TB;

architecture behave of sinus_calc_TB is
	signal sl_clk50MHz  : STD_LOGIC := '0';     -- clock 50MHz
	signal sl_Reset 	: STD_LOGIC := '0';
	signal slv6_InputIndex :  std_logic_vector(5 downto 0) := "000000";
	signal slv8_InputIndex :  std_logic_vector(7 downto 0) := "00000000";
	signal u8_microResProStep : signed(7 downto 0) := x"10";
	signal slv16_sinus : std_logic_vector(15 downto 0);
	signal slv16_sinusLeft : std_logic_vector(15 downto 0);
	signal slv16_sinusRight : std_logic_vector(15 downto 0);
	signal slv16_cosinusLeft : std_logic_vector(15 downto 0);
	signal slv16_cosinusRight : std_logic_vector(15 downto 0);
	signal n4 : integer := 4;
	signal n6 : integer := 6;
	signal n10 : integer := 10;
	signal n20 : integer := 20;
	signal n40 : integer := 40;
		
	
begin	

slv6_InputIndex <= slv8_InputIndex(5 downto 0);
P_SIMUL : process
begin
	wait for 1 us;
		slv8_InputIndex <= x"00";

	incIndexToN(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		n_Index => n20,--: in integer;
		slv8_InputIndex => slv8_InputIndex-- : out std_logic_vector(15 downto 0)
	);	
		
	wait for 1 us;
		slv8_InputIndex <= x"00";
		u8_microResProStep <= x"08";

	incIndexToN(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		n_Index => n20,--: in integer;
		slv8_InputIndex => slv8_InputIndex-- : out std_logic_vector(15 downto 0)
	);	
		
	wait for 1 us;
		slv8_InputIndex <= x"00";
		u8_microResProStep <= x"04";

	incIndexToN(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		n_Index => n20,--: in integer;
		slv8_InputIndex => slv8_InputIndex-- : out std_logic_vector(15 downto 0)
	);	
		
			wait for 1 us;
		slv8_InputIndex <= x"00";
		u8_microResProStep <= x"01";

	incIndexToN(
		sl_clk50MHz => sl_clk50MHz,-- : in std_logic;
		n_Index => n20,--: in integer;
		slv8_InputIndex => slv8_InputIndex-- : out std_logic_vector(15 downto 0)
	);	
		
		

	wait;		
	end process;

U_DUT : sinus_calc
port map
(
		isl_clk50Mhz 		=> sl_clk50MHz,--: in std_logic;
		islv6_InputIndex 	=> slv6_InputIndex,--: in std_logic_vector(7 downto 0);
		iu8_microResProStep => u8_microResProStep,--: in unsigned(7 downto 0);
		oslv16_sinusLeft	=> slv16_sinusLeft,--: out std_logic_vector(15 downto 0);
		oslv16_sinusRight	=> slv16_sinusRight,--: out std_logic_vector(15 downto 0);
		oslv16_cosinusLeft	=> slv16_cosinusLeft,--: out std_logic_vector(15 downto 0);
		oslv16_cosinusRight	=> slv16_cosinusRight,--: out std_logic_vector(15 downto 0);
		oslv16_sinus 		=> slv16_sinus--: out std_logic_vector(15 downto 0)
);


-- clock
    sl_clk50MHz    <= not sl_clk50MHz after 12 ns;
        
    P_RESET: process
    begin
    	sl_Reset <= '0';

        wait for 100 ns;
    	sl_Reset <= '1';
    	
        wait for 100 ns;

    	sl_Reset <= '0';

        wait;
    end process;
end  behave;