library IEEE;
use IEEE.std_logic_1164.all;

entity lc_3 is
    port (
        RESET, CLK : in  std_logic
    );
end lc_3;

architecture RTL of lc_3 is

    -- import 16-bit adder
    component add16 is
        port (
            CYI        : in  std_logic;
            OP_A, OP_B : in  std_logic_vector(15 downto 0);
            CYO        : out std_logic;
            SUM        : out std_logic_vector(15 downto 0)
        );
    end component;

    -- import ALU
    component alu is
        port (
            ALUK       : in  std_logic_vector(1 downto 0);
            OP_A, OP_B : in  std_logic_vector(15 downto 0);
            RESULT     : out std_logic_vector(15 downto 0)
        );
    end component;

    -- import FSM Control
    component fsm_control is
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
    end component;

    -- import 16-bit 2:1 mux
    component mux16_2to1 is
        port (
            SEL          : in  std_logic;
            D_IN0, D_IN1 : in  std_logic_vector(15 downto 0);
            D_OUT        : out std_logic_vector(15 downto 0)
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

    -- import NZP logic
    component NZP is
        port (
            D_IN    : in  std_logic_vector(15 downto 0);
            LD      : in  std_logic;
            N, Z, P : out std_logic
        );
    end component;

    -- import PC
    component pc is
        port (
            CLK, LD        : in  std_logic;
            PCSEL          : in  std_logic_vector(1 downto 0);
            OFFSET, DIRECT : in  std_logic_vector(15 downto 0);
            PC_OUT         : out std_logic_vector(15 downto 0)
        );
    end component;

    -- import RAM
    component ram is
        port (
            WE               : in  std_logic;
            ADDRESS, DATA_IN : in  std_logic_vector(15 downto 0);
            DATA_OUT         : out std_logic_vector(15 downto 0)
        );
    end component;

    -- import 16-bit register
    component register_16 is
        port (
            LD       : in  std_logic;
            DATA_IN  : in  std_logic_vector(15 downto 0);
            DATA_OUT : out std_logic_vector(15 downto 0)
        );
    end component;

    -- import register file
    component register_file is
        port (
            LD               : in  std_logic;
            DR, SR1, SR2     : in  std_logic_vector(2 downto 0);
            DR_IN            : in  std_logic_vector(15 downto 0);
            SR1_OUT, SR2_OUT : out std_logic_vector(15 downto 0)
        );
    end component;

    -- import 16-bit tristate buffer
    component tristate_b16 is
        port (
            SEL   : in  std_logic;
            D_IN  : in  std_logic_vector(15 downto 0);
            D_OUT : out std_logic_vector(15 downto 0)
        );
    end component;

    -- common bus
    signal COMMON_BUS : std_logic_vector(15 downto 0);

    -- SEXT and ZEXT
    signal SEXT4, SEXT5, SEXT8, SEXT10, ZEXT7 : std_logic_vector(15 downto 0);

    -- register file
    signal LDREG : std_logic;
    signal SR1, SR2, DR : std_logic_vector(2 downto 0);
    signal SR1_OUT, SR2_OUT : std_logic_vector(15 downto 0);

    -- SR2MUX
    signal SR2MUX_SEL : std_logic;
    signal SR2MUX_OUT : std_logic_vector(15 downto 0);

    -- instruction register
    signal LDIR : std_logic;
    signal IR_OUT : std_logic_vector(15 downto 0);

    -- ALU and GateALU
    signal GATE_ALU_SEL : std_logic;
    signal ALUK : std_logic_vector(1 downto 0);
    signal ALU_OP_A, ALU_OP_B, ALU_OUT : std_logic_vector(15 downto 0);

    -- ADDR1MUX and ADDR2MUX
    signal ADDR1MUX_SEL : std_logic;
    signal ADDR2MUX_SEL : std_logic_vector(1 downto 0);
    signal ADDR1MUX_OUT, ADDR2MUX_OUT : std_logic_vector(15 downto 0);

    -- ADDR
    signal ADDR_OUT : std_logic_vector(15 downto 0);

    -- PC
    signal LDPC, GATE_PC_SEL : std_logic;
    signal PC_SEL : std_logic_vector(1 downto 0);
    signal PC_OFFSET, PC_DIRECT, PC_OUT : std_logic_vector(15 downto 0);

    -- MARMUX and GateMARMUX
    signal MARMUX_SEL, GATE_MARMUX_SEL : std_logic;
    signal MARMUX_OUT : std_logic_vector(15 downto 0);

    -- NZP
    signal LDCC, N, Z, P : std_logic;

    -- Memory
    signal LDMAR, MEM_RW, GATE_MDR_SEL : std_logic;
    signal LDMDR : std_logic_vector(1 downto 0);
    signal MAR_OUT, MDR_OUT, MEM_OUT, MDR_IN : std_logic_vector(15 downto 0);

begin

    -- sign extensions
    SEXT4(15 downto 5)   <= (15 downto 5  => IR_OUT(4));  SEXT4(4 downto 0)   <= IR_OUT(4 downto 0);
    SEXT5(15 downto 6)   <= (15 downto 6  => IR_OUT(5));  SEXT5(5 downto 0)   <= IR_OUT(5 downto 0);
    SEXT8(15 downto 9)   <= (15 downto 9  => IR_OUT(8));  SEXT8(8 downto 0)   <= IR_OUT(8 downto 0);
    SEXT10(15 downto 11) <= (15 downto 11 => IR_OUT(10)); SEXT10(10 downto 0) <= IR_OUT(10 downto 0);
    ZEXT7(15 downto 8)   <= (15 downto 8  => '0');        ZEXT7(7 downto 0)   <= IR_OUT(7 downto 0);

    -- Register File
    reg_file_l : register_file port map (LD => LDREG, DR => DR, SR1 => SR1, SR2 => SR2,
                                         DR_IN => COMMON_BUS, SR1_OUT => SR1_OUT, SR2_OUT => SR2_OUT);

    -- SR2MUX
    sr2mux_l : mux16_2to1 port map (SEL => SR2MUX_SEL, D_IN0 => SR2_OUT, D_IN1 => SEXT4,
                                                       D_OUT => SR2MUX_OUT);

    -- ALU and GateALU
    ALU_OP_A <= SR1_OUT;
    ALU_OP_B <= SR2MUX_OUT;
    alu_l : alu port map (ALUK => ALUK, OP_A => ALU_OP_A, OP_B => ALU_OP_B, RESULT => ALU_OUT);
    gate_alu_l : tristate_b16 port map (SEL => GATE_ALU_SEL, D_IN => ALU_OUT, D_OUT => COMMON_BUS);

    -- Instruction Register
    ir_l : register_16 port map (LD => LDIR, DATA_IN => COMMON_BUS, DATA_OUT => IR_OUT);

    -- ADDR1MUX and ADDR2MUX
    addr1mux_l : mux16_2to1 port map (SEL => ADDR1MUX_SEL, D_IN0 => SR1_OUT, D_IN1 => PC_OUT,
                                      D_OUT => ADDR1MUX_OUT);
    addr2mux_l : mux16_4to1 port map (SEL => ADDR2MUX_SEL, D_IN0 => (others => '0'), D_IN1 => SEXT5,
                                      D_IN2 => SEXT8, D_IN3 => SEXT10, D_OUT => ADDR2MUX_OUT);

    -- ADDR
    addr_l : add16 port map (CYI => '0', OP_A => ADDR1MUX_OUT, OP_B => ADDR2MUX_OUT,
                             SUM => ADDR_OUT);

    -- PC and GatePC
    pc_l : pc port map (CLK => CLK, LD => LDPC, PCSEL => PC_SEL, OFFSET => PC_OFFSET,
                        DIRECT => PC_DIRECT, PC_OUT => PC_OUT);
    gate_pc_l : tristate_b16 port map (SEL => GATE_PC_SEL, D_IN => PC_OUT, D_OUT => COMMON_BUS);

    -- MARMUX and GateMARMUX
    marmux_l : mux16_2to1 port map (SEL => MARMUX_SEL, D_IN0 => ADDR_OUT, D_IN1 => ZEXT7,
                                    D_OUT => MARMUX_OUT);
    gate_marmux_l : tristate_b16 port map (SEL => GATE_MARMUX_SEL, D_IN => MARMUX_OUT, D_OUT => COMMON_BUS);

    -- NZP logic
    nzp_l : nzp port map (D_IN => COMMON_BUS, LD => LDCC, N => N, Z => Z, P => P);

    -- Memory
    mdr_mux: mux16_2to1 port map (SEL => LDMDR(0), D_IN0 => MEM_OUT, D_IN1 => COMMON_BUS, D_OUT => MDR_IN);
    mar_l : register_16 port map (LD => LDMAR, DATA_IN => COMMON_BUS, DATA_OUT => MAR_OUT);
    mdr_l : register_16 port map (LD => LDMDR(1), DATA_IN => MDR_IN, DATA_OUT => MDR_OUT);
    ram_l : ram port map (WE => MEM_RW, ADDRESS => MAR_OUT, DATA_IN => MDR_OUT, DATA_OUT => MEM_OUT);
    gate_mdr_l : tristate_b16 port map (SEL => GATE_MDR_SEL, D_IN => MDR_OUT, D_OUT => COMMON_BUS);

    -- FSM Control
    fsm_l : fsm_control port map (RESET => RESET, CLK => CLK, INSTR => IR_OUT, N => N, Z => Z, P => P,
            MARMUX_SEL => MARMUX_SEL, GATE_MARMUX_SEL => GATE_MARMUX_SEL, PCMUX_SEL => PC_SEL,
            LDPC => LDPC, GATE_PC_SEL => GATE_PC_SEL, SR1 => SR1, SR2 => SR2, DR => DR, LDREG => LDREG,
            SR2MUX_SEL => SR2MUX_SEL, ADDR1MUX_SEL => ADDR1MUX_SEL, ADDR2MUX_SEL => ADDR2MUX_SEL,
            ALUK => ALUK, GATE_ALU_SEL => GATE_ALU_SEL, LDIR => LDIR, LDCC => LDCC, LDMDR => LDMDR,
            LDMAR => LDMAR, MEM_RW => MEM_RW, GATE_MDR_SEL => GATE_MDR_SEL);

end architecture;
