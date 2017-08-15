library IEEE;
use IEEE.std_logic_1164.all;

entity pc is
    port (
        CLK, LD        : in  std_logic;
        PCSEL          : in  std_logic_vector(1 downto 0);
        OFFSET, DIRECT : in  std_logic_vector(15 downto 0);
        PC_OUT         : out std_logic_vector(15 downto 0)
    );
end pc;

architecture RTL of pc is

    -- import 16-bit register
    component register_16 is
    port (
        LD, CLK  : in  std_logic;
        DATA_IN  : in  std_logic_vector(15 downto 0);
        DATA_OUT : out std_logic_vector(15 downto 0)
    );
    end component;

    -- import 1-adder
    component inc1 is
    port (
        D_IN  : in  std_logic_vector(15 downto 0);
        D_OUT : out std_logic_vector(15 downto 0)
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

    signal PC_REG_IN, PC_REG_OUT, PLUS_ONE : std_logic_vector(15 downto 0);

begin

    pc_mux : mux16_4to1 port map (SEL => PCSEL, D_IN0 => PLUS_ONE, D_IN1 => OFFSET, D_IN2 => DIRECT,
                                                D_IN3 => (others => '0'), D_OUT => PC_REG_IN);

    pc_reg : process(CLK)
    begin
        if (rising_edge(CLK) and LD = '1') then
            PC_REG_OUT <= PC_REG_IN;
        end if;
    end process pc_reg;

    pc_inc : inc1 port map (D_IN => PC_REG_OUT, D_OUT => PLUS_ONE);

    PC_OUT <= PC_REG_OUT;

end architecture;
