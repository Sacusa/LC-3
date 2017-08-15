library IEEE;
use IEEE.std_logic_1164.all;

entity NZP is
    port (
        D_IN    : in  std_logic_vector(15 downto 0);
        LD      : in  std_logic;
        N, Z, P : out std_logic
    );
end NZP;

architecture RTL of NZP is

    signal N_IN, Z_IN, P_IN : std_logic;

begin

    set_nzp_in : process(LD)
    begin
        N_IN <= '0';
        Z_IN <= '0';
        P_IN <= '0';
        if (D_IN = "0000000000000000") then
            Z_IN <= '1';
        elsif (D_IN(15) = '1') then
            N_IN <= '1';
        else
            P_IN <= '1';
        end if;
    end process set_nzp_in;

    store_nzp : process(N_IN, Z_IN, P_IN, LD)
    begin
        if (LD = '1') then
            N <= N_IN;
            Z <= Z_IN;
            P <= P_IN;
        end if;
    end process store_nzp;

end architecture;
