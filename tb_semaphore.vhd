
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_semaphore is
end entity tb_semaphore;

architecture tb_semaphore_behaviour of tb_semaphore is

  component semaphore is
    port (
      clk              : in    std_logic;
      operational_mode : in    std_logic_vector(1 downto 0);
      standby_mode     : in    std_logic_vector(1 downto 0);
      enable           : in    std_logic;
      reset            : in    std_logic;
      red              : out   std_logic;
      yellow           : out   std_logic;
      green            : out   std_logic
    );
  end component semaphore;

  constant clk_period : time := 10 ns;

  signal clk_int              : std_logic;
  signal operational_mode_int : std_logic_vector(1 downto 0);
  signal standby_mode_int     : std_logic_vector(1 downto 0);
  signal red_int              : std_logic;
  signal yellow_int           : std_logic;
  signal green_int            : std_logic;

begin

  clk_gen : process
  begin

    clk_int <= '1'; wait for clk_period / 2;
    clk_int <= '0'; wait for clk_period / 2;

  end process clk_gen;

  operational_mode_gen : process
  begin

    -- MAINTENANCE
    operational_mode_int <= "00"; wait for 2*clk_period;
    -- NOMINAL: one cycle (Red5 + Green5 + YellowGreen2)
    operational_mode_int <= "01"; wait for 10*clk_period;
    -- STANDBY: MOD0 two cycles (Yellow1 + Off2)
    operational_mode_int <= "10"; wait for 6*clk_period;

    -- MAINTENANCE
    operational_mode_int <= "00"; wait for 2*clk_period;
    -- STANDBY: MOD1 three cycles (Red1 + Green1)
    operational_mode_int <= "10"; wait for 6*clk_period;

    -- MAINTENANCE
    operational_mode_int <= "00"; wait for 2*clk_period;
    -- STANDBY: MOD_AUTO one cycle (same as MOD1) then
    --    transitioning automaticallly to NOMINAL
    operational_mode_int <= "10"; wait for 40*clk_period;

  end process operational_mode_gen;

  standby_mode_gen : process
  begin

    -- MOD0
    standby_mode_int <= "00"; wait for 18*clk_period;

    -- MOD1
    standby_mode_int <= "01"; wait for 8*clk_period;

    -- MOD_AUTO
    standby_mode_int <= "10"; wait for 42*clk_period;

  end process standby_mode_gen;

  semaphore_component : semaphore
    port map (
      clk              => clk_int,
      operational_mode => operational_mode_int,
      standby_mode     => standby_mode_int,
      enable           => '1',
      reset            => '1',
      red              => red_int,
      yellow           => yellow_int,
      green            => green_int
    );

end architecture tb_semaphore_behaviour;
