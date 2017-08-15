library IEEE;
use IEEE.std_logic_1164.all;

entity mux16_2to1 is
    port (
        SEL          : in  std_logic;
        D_IN0, D_IN1 : in  std_logic_vector(15 downto 0);
        D_OUT        : out std_logic_vector(15 downto 0)
    );
end mux16_2to1;

architecture mux16_2to1_arch of mux16_2to1 is
begin

    with SEL select
    D_OUT <= D_IN0 when '0',
             D_IN1 when '1',
             (others => '0') when others;

end mux16_2to1_arch;
