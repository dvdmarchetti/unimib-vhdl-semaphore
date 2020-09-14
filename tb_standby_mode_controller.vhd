
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_standby_mode_controller is
end entity tb_standby_mode_controller;

architecture tb_standby_mode_controller_behaviour of tb_standby_mode_controller is

  component standby_mode_controller is
    port (
      clk              : in    std_logic;
      enable           : in    std_logic;
      reset            : in    std_logic;
      standby_mode     : in    std_logic_vector(1 downto 0);
      mod0             : out   std_logic;
      mod1             : out   std_logic;
      mod_auto         : out   std_logic;
      mod_auto_expired : out   std_logic
    );
  end component standby_mode_controller;

  component counter is generic (N : integer);
    port (
      enable    : in    std_logic;
      reset     : in    std_logic;
      clk       : in    std_logic;
      out_count : out   std_logic_vector(N - 1 downto 0)
    );
  end component counter;

  signal clk_int              : std_logic;
  signal enable_int           : std_logic;
  signal reset_int            : std_logic;
  signal standby_mode_int     : std_logic_vector(1 downto 0);
  signal mod0_int             : std_logic;
  signal mod1_int             : std_logic;
  signal mod_auto_int         : std_logic;
  signal mod_auto_expired_int : std_logic;

begin

  clk_gen : process
  begin

    clk_int <= '0'; wait for 5 ns;
    clk_int <= '1'; wait for 5 ns;

  end process clk_gen;

  -- counter_component : counter
  --   generic map (
  --     N => 2
  --   )
  --   port map (
  --     enable    => '1',
  --     reset     => '1',
  --     clk       => clk_int,
  --     out_count => standby_mode_int
  --   );

  standby_mode_gen : process
  begin

    standby_mode_int <= "00"; wait for 10 ns;
    standby_mode_int <= "01"; wait for 10 ns;
    standby_mode_int <= "10"; wait for 150 ns;

  end process standby_mode_gen;

  standby_mode_controller_component : standby_mode_controller
    port map (
      clk              => clk_int,
      enable           => '1',
      reset            => '1',
      standby_mode     => standby_mode_int,
      mod0             => mod0_int,
      mod1             => mod1_int,
      mod_auto         => mod_auto_int,
      mod_auto_expired => mod_auto_expired_int
    );

end architecture tb_standby_mode_controller_behaviour;
