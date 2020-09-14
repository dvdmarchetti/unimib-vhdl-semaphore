
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity standby_mode_controller is
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
end entity standby_mode_controller;

architecture standby_mode_controller_behaviour of standby_mode_controller is

  component counter is generic (N : integer);
    port (
      enable    : in    std_logic;
      reset     : in    std_logic;
      clk       : in    std_logic;
      out_count : out   std_logic_vector(N - 1 downto 0)
    );
  end component counter;

  type fsm_state is (S_MOD0, S_MOD1, S_MOD_AUTO);

  signal current_state : fsm_state := S_MOD0;
  signal next_state    : fsm_state;

  signal counter_reset_int  : std_logic := '0';
  signal counter_enable_int : std_logic := '0';
  signal out_count_int      : std_logic_vector(3 downto 0) := (others => '0');

begin

  fsm_standby_mode_controller : process (standby_mode, current_state) is

    variable standby_mode_out : std_logic_vector(2 downto 0);

  begin

    case current_state is

      when S_MOD0 =>
        standby_mode_out := "100";
      when S_MOD1 =>
        standby_mode_out := "010";
      when S_MOD_AUTO =>
        standby_mode_out := "001";

    end case;

    case standby_mode is

      when "00" =>
        next_state <= S_MOD0;
      when "01" =>
        next_state <= S_MOD1;
      when "10" =>
        next_state <= S_MOD_AUTO;
      when others =>
        next_state <= next_state;

    end case;

    mod0     <= standby_mode_out(2);
    mod1     <= standby_mode_out(1);
    mod_auto <= standby_mode_out(0);

  end process fsm_standby_mode_controller;

  fsm_reset : process (clk, reset) is
  begin

    if (reset = '0') then
      current_state <= S_MOD0;
    elsif (clk'event and clk = '1') then
      if (enable = '1') then
        if (current_state /= next_state) then
          mode_changed <= '0';
        else
          mode_changed <= '1';
        end if;

        current_state <= next_state;
      else
        mode_changed <= '1';
      end if;
    end if;

  end process fsm_reset;

  mod_auto_reset : process (current_state, out_count_int) is

    variable ticks           : integer;
    variable counter_reset   : std_logic;
    variable counter_enable  : std_logic;
    variable counter_expired : std_logic;

  begin

    ticks           := to_integer(unsigned(out_count_int));
    counter_reset   := '0';
    counter_enable  := '0';
    counter_expired := '0';

    if (current_state = S_MOD_AUTO) then
      counter_reset  := '1';
      counter_enable := '1';

      if (ticks >= 10) then
        counter_reset   := '0';
        counter_enable  := '0';
        counter_expired := '1';
      end if;
    end if;

    counter_reset_int  <= counter_reset;
    counter_enable_int <= counter_enable;
    mod_auto_expired   <= counter_expired;

  end process mod_auto_reset;

  counter_cmp : counter
    generic map (
      n => 4
    )
    port map (
      enable    => counter_enable_int,
      reset     => counter_reset_int,
      clk       => clk,
      out_count => out_count_int
    );

end architecture standby_mode_controller_behaviour;
