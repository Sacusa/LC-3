library IEEE;
use IEEE.std_logic_1164.all;

entity half_adder is
    port (
        A, B      : in  std_logic;
        SUM, CYO  : out std_logic
    );
end half_adder;

architecture RTL of half_adder is
begin

    SUM <= A xor B;
    CYO <= A and B;

end architecture;
