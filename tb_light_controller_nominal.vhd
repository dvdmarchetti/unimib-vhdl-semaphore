
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_light_controller_nominal is
end entity tb_light_controller_nominal;

architecture tb_light_controller_nominal_behaviour of tb_light_controller_nominal is

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

  signal clk_int    : std_logic;
  signal red_int    : std_logic;
  signal yellow_int : std_logic;
  signal green_int  : std_logic;

begin

  clk_gen : process
  begin

    clk_int <= '0'; wait for 5 ns;
    clk_int <= '1'; wait for 5 ns;

  end process clk_gen;

  light_controller_component : light_controller
    port map (
      clk         => clk_int,
      enable      => '1',
      nominal     => '1',
      standby     => '0',
      maintenance => '0',
      mod0        => '1',
      mod1        => '0',
      mod_auto    => '0',
      red         => red_int,
      yellow      => yellow_int,
      green       => green_int
    );

end architecture tb_light_controller_nominal_behaviour;
