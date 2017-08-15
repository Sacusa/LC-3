library IEEE;
use IEEE.std_logic_1164.all;

entity tristate_b16 is
    port (
        SEL   : in  std_logic;
        D_IN  : in  std_logic_vector(15 downto 0);
        D_OUT : out std_logic_vector(15 downto 0)
    );
end tristate_b16;

architecture RTL of tristate_b16 is
begin

    tb : process(SEL, D_IN)
    begin
        if (SEL = '1') then
            D_OUT <= D_IN;
        else
            D_OUT <= (others => 'Z');
        end if;
    end process;

end RTL;
