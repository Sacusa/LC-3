library IEEE;
use IEEE.std_logic_1164.all;

entity tristate_b is
    port (
        D_IN, SEL : in  std_logic;
        D_OUT     : out std_logic
    );
end tristate_b;

architecture RTL of tristate_b is
begin

    tb : process(SEL, D_IN)
    begin
        if (SEL = '1') then
            D_OUT <= D_IN;
        else
            D_OUT <= 'Z';
        end if;
    end process;

end RTL;
