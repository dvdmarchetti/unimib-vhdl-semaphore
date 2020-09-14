
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity semaphore is
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
end entity semaphore;

architecture semaphore_behaviour of semaphore is

  component operational_mode_controller is
    port (
      clk              : in    std_logic;
      enable           : in    std_logic;
      operational_mode : in    std_logic_vector(1 downto 0);
      mod_auto_expired : in    std_logic;
      nominal          : out   std_logic;
      standby          : out   std_logic;
      maintenance      : out   std_logic;
      state_changed    : out   std_logic
    );
  end component operational_mode_controller;

  component standby_mode_controller is
    port (
      clk              : in    std_logic;
      enable           : in    std_logic;
      reset            : in    std_logic;
      standby_mode     : in    std_logic_vector(1 downto 0);
      mod0             : out   std_logic;
      mod1             : out   std_logic;
      mod_auto         : out   std_logic;
      mode_changed     : out   std_logic;
      mod_auto_expired : out   std_logic
    );
  end component standby_mode_controller;

  component light_controller is
    port (
      clk           : in    std_logic;
      enable        : in    std_logic;
      nominal       : in    std_logic;
      standby       : in    std_logic;
      maintenance   : in    std_logic;
      state_changed : in    std_logic;
      mod0          : in    std_logic;
      mod1          : in    std_logic;
      mod_auto      : in    std_logic;
      mode_changed  : in    std_logic;
      red           : out   std_logic;
      yellow        : out   std_logic;
      green         : out   std_logic
    );
  end component light_controller;

  signal nominal_int                   : std_logic;
  signal standby_int                   : std_logic;
  signal maintenance_int               : std_logic;
  signal state_changed_int             : std_logic;
  signal mod0_int                      : std_logic;
  signal mod1_int                      : std_logic;
  signal mod_auto_int                  : std_logic;
  signal mode_changed_int              : std_logic;
  signal mod_auto_expired_int          : std_logic;
  signal standby_controller_enable_int : std_logic;

begin

  standby_controller_enable_int <= enable and maintenance_int;

  operational_mode_controller_component : operational_mode_controller
    port map (
      clk              => clk,
      enable           => enable,
      operational_mode => operational_mode,
      mod_auto_expired => mod_auto_expired_int,
      nominal          => nominal_int,
      standby          => standby_int,
      maintenance      => maintenance_int,
      state_changed    => state_changed_int
    );

  standby_mode_controller_component : standby_mode_controller
    port map (
      clk              => clk,
      enable           => standby_controller_enable_int,
      reset            => reset,
      standby_mode     => standby_mode,
      mod0             => mod0_int,
      mod1             => mod1_int,
      mod_auto         => mod_auto_int,
      mode_changed     => mode_changed_int,
      mod_auto_expired => mod_auto_expired_int
    );

  light_controller_component : light_controller
    port map (
      clk           => clk,
      enable        => enable,
      nominal       => nominal_int,
      standby       => standby_int,
      maintenance   => maintenance_int,
      state_changed => state_changed_int,
      mod0          => mod0_int,
      mod1          => mod1_int,
      mod_auto      => mod_auto_int,
      mode_changed  => mode_changed_int,
      red           => red,
      yellow        => yellow,
      green         => green
    );

end architecture semaphore_behaviour;
