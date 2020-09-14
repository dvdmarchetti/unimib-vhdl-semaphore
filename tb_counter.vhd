
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_counter is
end entity tb_counter;

architecture tb_counter_behaviour of tb_counter is

  component counter is generic (N : integer);
    port (
      enable    : in    std_logic;
      reset     : in    std_logic;
      clk       : in    std_logic;
      out_count : out   std_logic_vector(N - 1 downto 0)
    );
  end component counter;

  signal enable_int : std_logic;
  signal reset_int  : std_logic;
  signal clk_int    : std_logic;
  signal out_int    : std_logic_vector(1 downto 0);

begin

  clk_gen : process
  begin

    clk_int <= '0'; wait for 5 ns;
    clk_int <= '1'; wait for 5 ns;

  end process clk_gen;

  enable_gen : process
  begin

    enable_int <= '1'; wait for 63 ns;
    enable_int <= '0'; wait for 33 ns;

  end process enable_gen;

  reset_gen : process
  begin

    reset_int <= '1'; wait for 100 ns;
    reset_int <= '0'; wait for 32 ns;

  end process reset_gen;

  counter_cmp : counter
    generic map (
      N => 2
    )
    port map (
      enable    => enable_int,
      reset     => reset_int,
      clk       => clk_int,
      out_count => out_int
    );

end architecture tb_counter_behaviour;
