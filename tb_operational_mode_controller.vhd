
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_operational_mode_controller is
end entity tb_operational_mode_controller;

architecture tb_operational_mode_controller_behaviour of tb_operational_mode_controller is

  component operational_mode_controller is
    port (
      clk              : in    std_logic;
      enable           : in    std_logic;
      operational_mode : in    std_logic_vector(1 downto 0);
      mod_auto_expired : in    std_logic;
      nominal          : out   std_logic;
      standby          : out   std_logic;
      maintenance      : out   std_logic
    );
  end component operational_mode_controller;

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
  signal operational_mode_int : std_logic_vector(1 downto 0);
  signal mod_auto_expired_int : std_logic;
  signal nominal_int          : std_logic;
  signal standby_int          : std_logic;
  signal maintenance_int      : std_logic;

begin

  clk_gen : process
  begin

    clk_int <= '0'; wait for 5 ns;
    clk_int <= '1'; wait for 5 ns;

  end process clk_gen;

  enable_gen : process
  begin

    enable_int <= '1'; wait for 60 ns;
    enable_int <= '0'; wait for 20 ns;

  end process enable_gen;

  mod_auto_expired_gen : process
  begin

    -- Activate on S_MAINTENANCE
    mod_auto_expired_int <= '0'; wait for 15 ns;
    mod_auto_expired_int <= '1'; wait for 10 ns;
    mod_auto_expired_int <= '0'; wait for 70 ns;

    -- Activate on S_STANDBY
    mod_auto_expired_int <= '0'; wait for 40 ns;
    mod_auto_expired_int <= '1'; wait for 10 ns;
    mod_auto_expired_int <= '0'; wait for 40 ns;

    -- Activate on S_NOMINAL
    mod_auto_expired_int <= '0'; wait for 70 ns;
    mod_auto_expired_int <= '1'; wait for 10 ns;
    mod_auto_expired_int <= '0'; wait for 10 ns;

  end process mod_auto_expired_gen;

  operational_mode_gen : process is
  begin

    operational_mode_int <= "00"; wait for 30 ns;
    operational_mode_int <= "10"; wait for 30 ns;
    operational_mode_int <= "01"; wait for 30 ns;

    operational_mode_int <= "00"; wait for 30 ns;
    operational_mode_int <= "10"; wait for 30 ns;
    operational_mode_int <= "01"; wait for 30 ns;

    operational_mode_int <= "00"; wait for 30 ns;
    operational_mode_int <= "10"; wait for 30 ns;
    operational_mode_int <= "01"; wait for 30 ns;

  end process operational_mode_gen;

  operational_mode_controller_component : operational_mode_controller
    port map (
      clk              => clk_int,
      enable           => enable_int,
      operational_mode => operational_mode_int,
      mod_auto_expired => mod_auto_expired_int,
      nominal          => nominal_int,
      standby          => standby_int,
      maintenance      => maintenance_int
    );

end architecture tb_operational_mode_controller_behaviour;
