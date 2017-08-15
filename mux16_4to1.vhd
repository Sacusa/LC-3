library IEEE;
use IEEE.std_logic_1164.all;

entity mux16_4to1 is
    port (
        SEL                        : in  std_logic_vector(1 downto 0);
        D_IN0, D_IN1, D_IN2, D_IN3 : in  std_logic_vector(15 downto 0);
        D_OUT                      : out std_logic_vector(15 downto 0)
    );
end mux16_4to1;

architecture mux16_4to1_arch of mux16_4to1 is
begin

    with SEL select
    D_OUT <= D_IN0 when "00",
             D_IN1 when "01",
             D_IN2 when "10",
             D_IN3 when "11",
             (others => '0') when others;

end mux16_4to1_arch;
