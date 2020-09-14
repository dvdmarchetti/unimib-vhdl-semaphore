
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity operational_mode_controller is
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
end entity operational_mode_controller;

architecture operational_mode_controller_behaviour of operational_mode_controller is

  type fsm_state is (S_NOMINAL, S_NOMINAL_AUTO, S_STANDBY, S_MAINTENANCE, S_DISABLED);

  signal current_state : fsm_state := S_MAINTENANCE;
  signal next_state    : fsm_state := S_MAINTENANCE;

begin

  fsm_operational_mode_controller : process (operational_mode, current_state) is

    variable operational_mode_out : std_logic_vector(2 downto 0);

  begin
    -- state_changed <= '1';

    case current_state is

      when S_NOMINAL =>
        operational_mode_out := "100";

        case operational_mode is

          when "00" =>
            next_state <= S_MAINTENANCE;
          when "01" =>
            next_state <= S_NOMINAL;
          when "10" =>
            next_state <= S_STANDBY;
          when others =>
            null;

        end case;

      when S_NOMINAL_AUTO =>
        operational_mode_out := "100";

        case operational_mode is

          when "00" =>
            next_state <= S_MAINTENANCE;
          when "01" =>
            next_state <= S_NOMINAL;
          when others =>
            next_state <= S_NOMINAL_AUTO;

        end case;

      when S_STANDBY =>
        operational_mode_out := "010";

        case operational_mode is

          when "00" =>
            next_state <= S_MAINTENANCE;
          when "01" =>
            next_state <= S_NOMINAL;
          when "10" =>
            next_state <= S_STANDBY;
          when others =>
            null;

        end case;

      when S_MAINTENANCE =>
        operational_mode_out := "001";

        case operational_mode is

          when "00" =>
            next_state <= S_MAINTENANCE;
          when "01" =>
            next_state <= S_NOMINAL;
          when "10" =>
            next_state <= S_STANDBY;
          when others =>
            null;

        end case;

      when S_DISABLED =>
        operational_mode_out := "000";

        case operational_mode is

          when "00" =>
            next_state <= S_MAINTENANCE;
          when others =>
            next_state <= S_DISABLED;

        end case;

    end case;

    nominal     <= operational_mode_out(2);
    standby     <= operational_mode_out(1);
    maintenance <= operational_mode_out(0);

  end process fsm_operational_mode_controller;

  fsm_reset : process (clk, enable, mod_auto_expired) is

    variable previous_state : fsm_state;

  begin

    if (mod_auto_expired = '1' and current_state = S_STANDBY) then
      current_state <= S_NOMINAL_AUTO;
    elsif (clk'event and clk = '1') then
      if (current_state /= next_state or (current_state = S_NOMINAL_AUTO and previous_state /= S_NOMINAL_AUTO )) then
        state_changed <= '0';
      else
        state_changed <= '1';
      end if;

      if (enable = '1') then
        previous_state := current_state;
        current_state <= next_state;
      else
        current_state <= S_DISABLED;
      end if;
    end if;

  end process fsm_reset;

end architecture operational_mode_controller_behaviour;
