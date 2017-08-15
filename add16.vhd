library IEEE;
use IEEE.std_logic_1164.all;

entity add16 is
    port (
        CYI        : in  std_logic;
        OP_A, OP_B : in  std_logic_vector(15 downto 0);
        CYO        : out std_logic;
        SUM        : out std_logic_vector(15 downto 0)
    );
end add16;

architecture RTL of add16 is

    -- import full adder
    component full_adder is
    port (
        A, B, CYI : in  std_logic;
        SUM, CYO  : out std_logic
    );
    end component;

    signal CARRY : std_logic_vector(15 downto 0);

begin

    C0  : full_adder port map (A => OP_A(0),  B => OP_B(0),  CYI => CYI,       SUM => SUM(0),  CYO => CARRY(0));
    C1  : full_adder port map (A => OP_A(1),  B => OP_B(1),  CYI => CARRY(0),  SUM => SUM(1),  CYO => CARRY(1));
    C2  : full_adder port map (A => OP_A(2),  B => OP_B(2),  CYI => CARRY(1),  SUM => SUM(2),  CYO => CARRY(2));
    C3  : full_adder port map (A => OP_A(3),  B => OP_B(3),  CYI => CARRY(2),  SUM => SUM(3),  CYO => CARRY(3));
    C4  : full_adder port map (A => OP_A(4),  B => OP_B(4),  CYI => CARRY(3),  SUM => SUM(4),  CYO => CARRY(4));
    C5  : full_adder port map (A => OP_A(5),  B => OP_B(5),  CYI => CARRY(4),  SUM => SUM(5),  CYO => CARRY(5));
    C6  : full_adder port map (A => OP_A(6),  B => OP_B(6),  CYI => CARRY(5),  SUM => SUM(6),  CYO => CARRY(6));
    C7  : full_adder port map (A => OP_A(7),  B => OP_B(7),  CYI => CARRY(6),  SUM => SUM(7),  CYO => CARRY(7));
    C8  : full_adder port map (A => OP_A(8),  B => OP_B(8),  CYI => CARRY(7),  SUM => SUM(8),  CYO => CARRY(8));
    C9  : full_adder port map (A => OP_A(9),  B => OP_B(9),  CYI => CARRY(8),  SUM => SUM(9),  CYO => CARRY(9));
    C10 : full_adder port map (A => OP_A(10), B => OP_B(10), CYI => CARRY(9),  SUM => SUM(10), CYO => CARRY(10));
    C11 : full_adder port map (A => OP_A(11), B => OP_B(11), CYI => CARRY(10), SUM => SUM(11), CYO => CARRY(11));
    C12 : full_adder port map (A => OP_A(12), B => OP_B(12), CYI => CARRY(11), SUM => SUM(12), CYO => CARRY(12));
    C13 : full_adder port map (A => OP_A(13), B => OP_B(13), CYI => CARRY(12), SUM => SUM(13), CYO => CARRY(13));
    C14 : full_adder port map (A => OP_A(14), B => OP_B(14), CYI => CARRY(13), SUM => SUM(14), CYO => CARRY(14));
    C15 : full_adder port map (A => OP_A(15), B => OP_B(15), CYI => CARRY(14), SUM => SUM(15), CYO => CARRY(15));

    CYO <= CARRY(15);

end architecture;
