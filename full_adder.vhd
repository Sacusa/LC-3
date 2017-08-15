library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
    port (
        A, B, CYI : in  std_logic;
        SUM, CYO  : out std_logic
    );
end full_adder;

architecture RTL of full_adder is

    signal A_XOR_B : std_logic;
begin

    A_XOR_B <= A xor B;
    SUM <= (A_XOR_B) xor CYI;
    CYO <= ((A_XOR_B) and CYI) or (A and B);

end architecture;
