library IEEE;
use IEEE.std_logic_1164.all;

entity inc1 is
    port (
        D_IN  : in  std_logic_vector(15 downto 0);
        D_OUT : out std_logic_vector(15 downto 0)
    );
end inc1;

architecture RTL of inc1 is

    -- import half adder
    component half_adder is
        port (
            A, B      : in  std_logic;
            SUM, CYO  : out std_logic
        );
    end component;

    signal CARRY : std_logic_vector(14 downto 0);

begin

    C0  : half_adder port map (A => D_IN(0),  B => '1',       SUM => D_OUT(0),  CYO => CARRY(0));
    C1  : half_adder port map (A => D_IN(1),  B => CARRY(0),  SUM => D_OUT(1),  CYO => CARRY(1));
    C2  : half_adder port map (A => D_IN(2),  B => CARRY(1),  SUM => D_OUT(2),  CYO => CARRY(2));
    C3  : half_adder port map (A => D_IN(3),  B => CARRY(2),  SUM => D_OUT(3),  CYO => CARRY(3));
    C4  : half_adder port map (A => D_IN(4),  B => CARRY(3),  SUM => D_OUT(4),  CYO => CARRY(4));
    C5  : half_adder port map (A => D_IN(5),  B => CARRY(4),  SUM => D_OUT(5),  CYO => CARRY(5));
    C6  : half_adder port map (A => D_IN(6),  B => CARRY(5),  SUM => D_OUT(6),  CYO => CARRY(6));
    C7  : half_adder port map (A => D_IN(7),  B => CARRY(6),  SUM => D_OUT(7),  CYO => CARRY(7));
    C8  : half_adder port map (A => D_IN(8),  B => CARRY(7),  SUM => D_OUT(8),  CYO => CARRY(8));
    C9  : half_adder port map (A => D_IN(9),  B => CARRY(8),  SUM => D_OUT(9),  CYO => CARRY(9));
    C10 : half_adder port map (A => D_IN(10), B => CARRY(9),  SUM => D_OUT(10), CYO => CARRY(10));
    C11 : half_adder port map (A => D_IN(11), B => CARRY(10), SUM => D_OUT(11), CYO => CARRY(11));
    C12 : half_adder port map (A => D_IN(12), B => CARRY(11), SUM => D_OUT(12), CYO => CARRY(12));
    C13 : half_adder port map (A => D_IN(13), B => CARRY(12), SUM => D_OUT(13), CYO => CARRY(13));
    C14 : half_adder port map (A => D_IN(14), B => CARRY(13), SUM => D_OUT(14), CYO => CARRY(14));
    C15 : half_adder port map (A => D_IN(15), B => CARRY(14), SUM => D_OUT(15));

end architecture;
