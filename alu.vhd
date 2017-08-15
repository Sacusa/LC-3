library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
    port (
        ALUK       : in  std_logic_vector(1 downto 0);
        OP_A, OP_B : in  std_logic_vector(15 downto 0);
        RESULT     : out std_logic_vector(15 downto 0)
    );
end alu;

architecture RTL of alu is

    -- import 16-bit full adder
    component add16 is
        port (
            CYI        : in  std_logic;
            OP_A, OP_B : in  std_logic_vector(15 downto 0);
            CYO        : out std_logic;
            SUM        : out std_logic_vector(15 downto 0)
        );
    end component;

    -- import 16-bit 4:1 mux
    component mux16_4to1 is
        port (
            SEL                        : in  std_logic_vector(1 downto 0);
            D_IN0, D_IN1, D_IN2, D_IN3 : in  std_logic_vector(15 downto 0);
            D_OUT                      : out std_logic_vector(15 downto 0)
        );
    end component;

    signal ADD_DATA, AND_DATA, NOT_DATA : std_logic_vector(15 downto 0);

begin

    comp_add : add16 port map (CYI => '0', OP_A => OP_A, OP_B => OP_B, SUM => ADD_DATA);
    AND_DATA <= OP_A and OP_B;
    NOT_DATA <= not OP_A;

    comp_result : mux16_4to1 port map (SEL => ALUK, D_IN0 => ADD_DATA, D_IN1 => AND_DATA,
                                                    D_IN2 => NOT_DATA, D_IN3 => (others => '0'),
                                       D_OUT => RESULT);

end architecture;
