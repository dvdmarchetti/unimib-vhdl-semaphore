
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity counter is
  generic (
    N : integer
  );
  port (
    enable    : in    std_logic;
    reset     : in    std_logic;
    clk       : in    std_logic;
    out_count : out   std_logic_vector(N - 1 downto 0)
  );
end entity counter;

architecture counter_behavior of counter is

  constant overflow : std_logic_vector(N - 1 downto 0) := (others => '1');

begin

  count : process (clk, reset) is

    variable count : std_logic_vector(N - 1 downto 0) := (others => '0');

  begin

    if (reset = '0') then
      count := (others => '0');
    elsif (clk'event and clk = '1') then
      if (enable = '1') then
        if (count = overflow) then
          count := (others => '0');
        else
          count := count + '1';
        end if;
      end if;
    end if;

    out_count <= count;

  end process count;

end architecture counter_behavior;
