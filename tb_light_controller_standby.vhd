
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_light_controller_standby is
end entity tb_light_controller_standby;

architecture tb_light_controller_standby_behaviour of tb_light_controller_standby is

  component light_controller is
    port (
      clk         : in    std_logic;
      enable      : in    std_logic;
      nominal     : in    std_logic;
      standby     : in    std_logic;
      maintenance : in    std_logic;
      mod0        : in    std_logic;
      mod1        : in    std_logic;
      mod_auto    : in    std_logic;
      red         : out   std_logic;
      yellow      : out   std_logic;
      green       : out   std_logic
    );
  end component light_controller;

  signal clk_int      : std_logic;
  signal mod0_int     : std_logic;
  signal mod1_int     : std_logic;
  signal mod_auto_int : std_logic;
  signal red_int      : std_logic;
  signal yellow_int   : std_logic;
  signal green_int    : std_logic;

begin

  clk_gen : process
  begin

    clk_int <= '0'; wait for 5 ns;
    clk_int <= '1'; wait for 5 ns;

  end process clk_gen;

  mod0_gen : process
  begin

    mod0_int <= '0'; wait for 5 ns;
    mod0_int <= '1'; wait for 30 ns;
    mod0_int <= '0'; wait for 60 ns;

  end process mod0_gen;

  mod1_gen : process
  begin

    mod1_int <= '0'; wait for 5 ns;
    mod1_int <= '0'; wait for 30 ns;
    mod1_int <= '1'; wait for 30 ns;
    mod1_int <= '0'; wait for 30 ns;

  end process mod1_gen;

  mod_auto_gen : process
  begin

    mod_auto_int <= '0'; wait for 5 ns;
    mod_auto_int <= '0'; wait for 60 ns;
    mod_auto_int <= '1'; wait for 30 ns;

  end process mod_auto_gen;

  light_controller_component : light_controller
    port map (
      clk         => clk_int,
      enable      => '1',
      nominal     => '0',
      standby     => '1',
      maintenance => '0',
      mod0        => mod0_int,
      mod1        => mod1_int,
      mod_auto    => mod_auto_int,
      red         => red_int,
      yellow      => yellow_int,
      green       => green_int
    );

end architecture tb_light_controller_standby_behaviour;
