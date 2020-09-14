
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity light_controller is
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
end entity light_controller;

architecture light_controller_behaviour of light_controller is

  component counter is generic (N : integer);
    port (
      enable    : in    std_logic;
      reset     : in    std_logic;
      clk       : in    std_logic;
      out_count : out   std_logic_vector(N - 1 downto 0)
    );
  end component counter;

  constant c_nominal     : std_logic_vector(2 downto 0) := "100";
  constant c_standby     : std_logic_vector(2 downto 0) := "010";
  constant c_maintenance : std_logic_vector(2 downto 0) := "001";

  constant c_mod0     : std_logic_vector(2 downto 0) := "100";
  constant c_mod1     : std_logic_vector(2 downto 0) := "010";
  constant c_mod_auto : std_logic_vector(2 downto 0) := "001";

  signal op_mode_int      : std_logic_vector(2 downto 0) := (others => '0');
  signal standby_mode_int : std_logic_vector(2 downto 0) := (others => '0');
  signal out_count_int    : std_logic_vector(3 downto 0) := (others => '0');

  signal reset     : std_logic := '1';
  signal reset_int : std_logic := '1';

begin

  op_mode_int      <= nominal & standby & maintenance;
  standby_mode_int <= mod0 & mod1 & mod_auto;

  lights : process (state_changed, mode_changed, out_count_int) is

    variable ticks : integer;
    variable ryg   : std_logic_vector(2 downto 0) := (others => '0');

  begin

    if (reset_int = '0') then
      reset_int <= '1';
    elsif (state_changed = '0' or mode_changed = '0') then
      reset_int <= '0';
    end if;

    ticks := to_integer(unsigned(out_count_int));
    ryg   := (others => '0');

    if (enable = '1') then

      case (op_mode_int) is

        when c_maintenance =>
          ryg := "111";

        when c_nominal =>
          if (ticks >= 0 and ticks < 5) then
            -- Red for 5 secs
            ryg := "100";
          elsif (ticks >= 5 and ticks < 8) then
            -- Green 5 secs
            ryg := "001";
          elsif (ticks >= 8 and ticks < 10) then
            -- Green + Yellow 2 secs at the end
            ryg := "011";
          end if;

          if (ticks = 10) then
            reset_int <= '0';
          end if;

        when c_standby =>

          case (standby_mode_int) is

            when c_mod0 =>
              if (ticks >= 0 and ticks < 1) then
                -- Yellow on 1 sec
                ryg := "010";
              elsif (ticks >= 1 and ticks < 3) then
                -- Yellow off 2 sec
                ryg := "000";
              end if;

              if (ticks = 3) then
                reset_int <= '0';
              end if;

            when c_mod1 | c_mod_auto =>
              if (ticks = 0) then
                -- Red on for 1 sec
                ryg := "100";
              else
                -- Green on for 1 sec
                ryg := "001";
              end if;

              if (ticks = 2) then
                reset_int <= '0';
              end if;

            when others =>
              null;

          end case;

        when others => null;

      end case;

    end if;

    red    <= ryg(2);
    yellow <= ryg(1);
    green  <= ryg(0);

  end process lights;

  counter_cmp : counter
    generic map (
      n => 4
    )
    port map (
      enable    => enable,
      reset     => reset_int,
      clk       => clk,
      out_count => out_count_int
    );

end architecture light_controller_behaviour;
