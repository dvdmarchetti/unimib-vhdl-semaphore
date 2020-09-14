
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_semaphore_enable_reset is
end entity tb_semaphore_enable_reset;

architecture tb_semaphore_enable_reset_behaviour of tb_semaphore_enable_reset is

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
signal enable_int           : std_logic;
signal reset_int            : std_logic;
signal red_int              : std_logic;
signal yellow_int           : std_logic;
signal green_int            : std_logic;

begin

clk_gen : process
begin

  clk_int <= '1'; wait for clk_period / 2;
  clk_int <= '0'; wait for clk_period / 2;

end process clk_gen;

enable_gen : process
begin

  enable_int <= '1'; wait for 9*clk_period + 3 ns;
  enable_int <= '0'; wait for 6*clk_period - 3 ns;

end process enable_gen;

reset_gen : process
begin

  reset_int <= '1'; wait for 14*clk_period - 3 ns;
  reset_int <= '0'; wait for 3 ns;
  reset_int <= '1'; wait for 2*clk_period;

end process reset_gen;

operational_mode_gen : process
begin

  -- MAINTENANCE
  operational_mode_int <= "00"; wait for 6*clk_period;

end process operational_mode_gen;

standby_mode_gen : process
begin

  -- MOD0
  standby_mode_int <= "00"; wait for 2*clk_period;
  -- MOD1
  standby_mode_int <= "01"; wait for 2*clk_period;
  -- MOD_AUTO
  standby_mode_int <= "10"; wait for 2*clk_period;

end process standby_mode_gen;

semaphore_component : semaphore
  port map (
    clk              => clk_int,
    operational_mode => operational_mode_int,
    standby_mode     => standby_mode_int,
    enable           => enable_int,
    reset            => reset_int,
    red              => red_int,
    yellow           => yellow_int,
    green            => green_int
  );

end architecture tb_semaphore_enable_reset_behaviour;
