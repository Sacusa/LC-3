library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm_control is
    port (
        RESET, CLK                  : in  std_logic;
        INSTR                       : in  std_logic_vector(15 downto 0);
        N, Z, P                     : in  std_logic;
        MARMUX_SEL, GATE_MARMUX_SEL : out std_logic;
        PCMUX_SEL                   : out std_logic_vector(1 downto 0);
        LDPC, GATE_PC_SEL           : out std_logic;
        SR1, SR2, DR                : out std_logic_vector(2 downto 0);
        LDREG, SR2MUX_SEL           : out std_logic;
        ADDR2MUX_SEL                : out std_logic_vector(1 downto 0);
        ADDR1MUX_SEL                : out std_logic;
        ALUK                        : out std_logic_vector(1 downto 0);
        GATE_ALU_SEL                : out std_logic;
        LDIR                        : out std_logic;
        LDCC                        : out std_logic;
        LDMDR                       : out std_logic_vector(1 downto 0);
        LDMAR, MEM_RW, GATE_MDR_SEL : out std_logic
    );
end fsm_control;

architecture RTL of fsm_control is

    type ROM is array (0 to 15) of std_logic_vector(18 downto 0);
    type fsm_state is (F1, F2, D, EA, OP, EX, S);

    constant EA_ROM : ROM := (
        2  => "0100000010100010100",  -- LD
        3  => "0100000010100000100",  -- ST
        6  => "0100000001000010100",  -- LDR
        7  => "0100000001000000100",  -- STR
        10 => "0100000010100010100",  -- LDI
        11 => "0100000010100010100",  -- STI
        14 => "0100001010100110000",  -- LEA
        others => "0000000000000000000"
    );
    constant OP_ROM : ROM := (
        2  => "0000001000000100001",  -- LD
        3  => "0100000000000011000",  -- ST
        6  => "0000001000000100001",  -- LDR
        7  => "0100000000000011000",  -- STR
        10 => "0000000000000000101",  -- LDI
        11 => "0000000000000000101",  -- STI
        14 => "0100001010100110000",  -- LEA
        others => "0000000000000000000"
    );
    constant EX_ROM : ROM := (
        0  => "0001000010100000000",  -- BR
        1  => "0000000000010100000",  -- ADD
        4  => "0000011000000000000",  -- JSR
        5  => "0000000000010100000",  -- AND
        9  => "0000000000010100000",  -- NOT
        12 => "0001100000000000000",  -- JMP
        15 => "0001111000000000000",  -- TRAP
        others => "0000000000000000000"
    );
    constant S_ROM : ROM := (
        0  => "0001000010100000000",  -- BR
        1  => "0000001000010100000",  -- ADD
        2  => "0000001000000000001",  -- LD
        3  => "0000000000000000010",  -- ST
        4  => "0001100000000000000",  -- JSR
        5  => "0000001000010100000",  -- AND
        6  => "0000001000000000001",  -- LDR
        7  => "0000000000000000010",  -- STR
        9  => "0000001000010100000",  -- NOT
        10 => "0000001000000110001",  -- LDI
        11 => "0100000000000011010",  -- STI
        12 => "0001000000000000000",  -- JMP
        14 => "0100001010100000000",  -- LEA
        15 => "0001111000000000000",  -- TRAP
        others => "0000000000000000000"
    );

    signal CURRENT_STATE, NEXT_STATE : fsm_state;
    signal CURRENT_SIGNALS : std_logic_vector(18 downto 0);
    signal OPCODE : std_logic_vector(3 downto 0);

begin
    
    OPCODE          <= INSTR(15 downto 12);
    MARMUX_SEL      <= CURRENT_SIGNALS(18);
    GATE_MARMUX_SEL <= CURRENT_SIGNALS(17);
    PCMUX_SEL       <= CURRENT_SIGNALS(16 downto 15);
    LDPC            <= CURRENT_SIGNALS(14);
    GATE_PC_SEL     <= CURRENT_SIGNALS(13);
    LDREG           <= CURRENT_SIGNALS(12);
    SR2MUX_SEL      <= CURRENT_SIGNALS(11);
    ADDR2MUX_SEL    <= CURRENT_SIGNALS(10 downto 9);
    ADDR1MUX_SEL    <= CURRENT_SIGNALS(8);
    GATE_ALU_SEL    <= CURRENT_SIGNALS(7);
    LDIR            <= CURRENT_SIGNALS(6);
    LDCC            <= CURRENT_SIGNALS(5);
    LDMDR           <= CURRENT_SIGNALS(4 downto 3);
    LDMAR           <= CURRENT_SIGNALS(2);
    MEM_RW          <= CURRENT_SIGNALS(1);
    GATE_MDR_SEL    <= CURRENT_SIGNALS(0);

    sync_proc : process(CLK, RESET)
    begin
        if (RESET = '1') then
            CURRENT_STATE <= F1;
        elsif (rising_edge(CLK)) then
            CURRENT_STATE <= NEXT_STATE;
        end if;
    end process sync_proc;

    comb_proc : process (CURRENT_STATE, RESET)
    begin
        -- proceed only if RESET is not set
        if (RESET = '1') then
            CURRENT_SIGNALS <= "0011110000000000000";
            NEXT_STATE <= F1;
        else
            CURRENT_SIGNALS <= "0000000000000000000";

            case CURRENT_STATE is
                when F1 =>
                    -- load PC value into MAR
                    -- load instruction into MDR
                    CURRENT_SIGNALS <= "0000010000000010100";
                    NEXT_STATE <= F2;

                when F2 =>
                    -- read instruction into IR
                    -- also, increment the PC
                    CURRENT_SIGNALS <= "0000100000001000001";
                    NEXT_STATE <= D;

                when D =>
                    -- decode the instruction
                    CURRENT_SIGNALS <= "0000000000000000000";

                    -- LOAD and STORE instruction go to EA stage
                    if ((OPCODE(1 downto 0) = "10" or OPCODE(1 downto 0) = "11") and OPCODE /= "1111") then
                        NEXT_STATE <= EA;
                    -- others go to EX stage
                    else
                        NEXT_STATE <= EX;
                    end if;

                    -- set ALUK
                    ALUK <= INSTR(15 downto 14);

                    -- set SR1 and SR2
                    SR1 <= INSTR(8  downto 6);
                    SR2 <= INSTR(2  downto 0);

                    -- set DR to R7 for JSR
                    if (OPCODE = "0100") then
                        DR <= "111";
                    -- regular handling for others
                    else
                        DR <= INSTR(11 downto 9);
                    end if;

                when EA =>
                    CURRENT_SIGNALS <= EA_ROM(to_integer(unsigned(OPCODE)));
                    NEXT_STATE <= OP;

                when OP =>
                    CURRENT_SIGNALS <= OP_ROM(to_integer(unsigned(OPCODE)));
                    NEXT_STATE <= S;

                when EX =>
                    CURRENT_SIGNALS <= EX_ROM(to_integer(unsigned(OPCODE)));
                    NEXT_STATE <= S;

                    -- bit steering by bit 5 for ADD and AND
                    if ((OPCODE = "0001" or OPCODE = "0101") and INSTR(5) = '1') then
                        CURRENT_SIGNALS(11) <= '1';
                    end if;

                    -- calculate LD.PC for BR
                    if (INSTR(11 downto 9) = N&Z&P) then
                        CURRENT_SIGNALS(14) <= '1';
                    end if;

                when S =>
                    CURRENT_SIGNALS <= S_ROM(to_integer(unsigned(OPCODE)));
                    NEXT_STATE <= F1;

                    -- bit steering by bit 5 for ADD and AND
                    if ((OPCODE = "0001" or OPCODE = "0101") and INSTR(5) = '1') then
                        CURRENT_SIGNALS(11) <= '1';
                    end if;

                    -- bit steering by bit 11 for JSR
                    if (OPCODE = "0100" and INSTR(11) = '1') then
                        CURRENT_SIGNALS(8) <= '1';
                        CURRENT_SIGNALS(10 downto 9) <= "11";
                    end if;

                when others =>
                    CURRENT_SIGNALS <= (others => '0');
                    NEXT_STATE <= F1;

            end case;
        end if;
    end process comb_proc;

end architecture;
