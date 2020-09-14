
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_light_controller is
end entity tb_light_controller;

architecture tb_light_controller_behaviour of tb_light_controller is

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

  signal clk_int         : std_logic;
  signal enable_int      : std_logic;
  signal nominal_int     : std_logic;
  signal standby_int     : std_logic;
  signal maintenance_int : std_logic;
  signal mod0_int        : std_logic;
  signal mod1_int        : std_logic;
  signal mod_auto_int    : std_logic;
  signal red_int         : std_logic;
  signal yellow_int      : std_logic;
  signal green_int       : std_logic;

begin

  clk_gen : process
  begin

    clk_int <= '0'; wait for 5 ns;
    clk_int <= '1'; wait for 5 ns;

  end process clk_gen;

  mod0_gen : process
  begin

    mod0_int <= '1'; wait for 10 ns;
    mod0_int <= '0'; wait for 20 ns;

  end process mod0_gen;

  mod1_gen : process
  begin

    mod1_int <= '0'; wait for 10 ns;
    mod1_int <= '1'; wait for 10 ns;
    mod1_int <= '0'; wait for 10 ns;

  end process mod1_gen;

  mod_auto_gen : process
  begin

    mod_auto_int <= '0'; wait for 20 ns;
    mod_auto_int <= '1'; wait for 10 ns;

  end process mod_auto_gen;

  nominal_gen : process
  begin

    nominal_int <= '1'; wait for 30 ns;
    nominal_int <= '0'; wait for 60 ns;

  end process nominal_gen;

  standby_gen : process
  begin

    standby_int <= '0'; wait for 30 ns;
    standby_int <= '1'; wait for 30 ns;
    standby_int <= '0'; wait for 30 ns;

  end process standby_gen;

  maintenance_gen : process
  begin

    maintenance_int <= '0'; wait for 60 ns;
    maintenance_int <= '1'; wait for 30 ns;

  end process maintenance_gen;

  enable_gen : process
  begin

    enable_int <= '1'; wait for 90 ns;
    enable_int <= '0'; wait for 90 ns;

  end process enable_gen;

  light_controller_component : light_controller
    port map (
      clk         => clk_int,
      enable      => enable_int,
      nominal     => nominal_int,
      standby     => standby_int,
      maintenance => maintenance_int,
      mod0        => mod0_int,
      mod1        => mod1_int,
      mod_auto    => mod_auto_int,
      red         => red_int,
      yellow      => yellow_int,
      green       => green_int
    );

end architecture tb_light_controller_behaviour;
