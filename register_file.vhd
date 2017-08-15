------------------------------------------------
-- Register File -------------------------------
------------------------------------------------
-- Register file with 8 GPRs
-- Supports two simultaneous reads and one write
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity register_file is
    port (
        LD               : in  std_logic;
        DR, SR1, SR2     : in  std_logic_vector(2 downto 0);
        DR_IN            : in  std_logic_vector(15 downto 0);
        SR1_OUT, SR2_OUT : out std_logic_vector(15 downto 0)
    );
end register_file;

architecture register_file_arch of register_file is

    -- import 16-bit register
    component register_16 is
    port (
        LD       : in  std_logic;
        DATA_IN  : in  std_logic_vector(15 downto 0);
        DATA_OUT : out std_logic_vector(15 downto 0)
    );
    end component;

    -- import 3:8 decoder
    component decoder_3to8 is
    port (
        D_IN  : in  std_logic_vector(2 downto 0);
        D_OUT : out std_logic_vector(7 downto 0)
    );
    end component;

    -- individual register load signal
    signal R0_LD, R1_LD, R2_LD, R3_LD, R4_LD, R5_LD, R6_LD, R7_LD, SR1_LD, SR2_LD : std_logic;

    -- individual register output data
    signal R0_OUT, R1_OUT, R2_OUT, R3_OUT, R4_OUT, R5_OUT, R6_OUT, R7_OUT : std_logic_vector(15 downto 0);

    -- SR1 and SR2 inputs
    signal SR1_IN, SR2_IN : std_logic_vector(15 downto 0);

    -- decoder LD output
    signal DEC_LD : std_logic_vector(7 downto 0);

begin

    -- GPRs
    R0 : register_16 port map (LD => R0_LD, DATA_IN => DR_IN, DATA_OUT => R0_OUT);
    R1 : register_16 port map (LD => R1_LD, DATA_IN => DR_IN, DATA_OUT => R1_OUT);
    R2 : register_16 port map (LD => R2_LD, DATA_IN => DR_IN, DATA_OUT => R2_OUT);
    R3 : register_16 port map (LD => R3_LD, DATA_IN => DR_IN, DATA_OUT => R3_OUT);
    R4 : register_16 port map (LD => R4_LD, DATA_IN => DR_IN, DATA_OUT => R4_OUT);
    R5 : register_16 port map (LD => R5_LD, DATA_IN => DR_IN, DATA_OUT => R5_OUT);
    R6 : register_16 port map (LD => R6_LD, DATA_IN => DR_IN, DATA_OUT => R6_OUT);
    R7 : register_16 port map (LD => R7_LD, DATA_IN => DR_IN, DATA_OUT => R7_OUT);

    -- SR output registers
    SR1_REG : register_16 port map (LD => SR1_LD, DATA_IN => SR1_IN, DATA_OUT => SR1_OUT);
    SR2_REG : register_16 port map (LD => SR2_LD, DATA_IN => SR2_IN, DATA_OUT => SR2_OUT);

    -----------------
    -- Set LD signals
    -----------------
    comp_ld: decoder_3to8 port map (D_IN => DR, D_OUT => DEC_LD);
    R0_LD <= DEC_LD(0) and LD;
    R1_LD <= DEC_LD(1) and LD;
    R2_LD <= DEC_LD(2) and LD;
    R3_LD <= DEC_LD(3) and LD;
    R4_LD <= DEC_LD(4) and LD;
    R5_LD <= DEC_LD(5) and LD;
    R6_LD <= DEC_LD(6) and LD;
    R7_LD <= DEC_LD(7) and LD;
    SR1_LD <= not LD;
    SR2_LD <= not LD;

    ------------------------
    -- Set SR1 and SR2 input
    ------------------------
    with (SR1) select
        SR1_IN <= R0_OUT when "000",
            R1_OUT when "001",
            R2_OUT when "010",
            R3_OUT when "011",
            R4_OUT when "100",
            R5_OUT when "101",
            R6_OUT when "110",
            R7_OUT when "111",
            (others => '0') when others;
    with (SR2) select
        SR2_IN <= R0_OUT when "000",
            R1_OUT when "001",
            R2_OUT when "010",
            R3_OUT when "011",
            R4_OUT when "100",
            R5_OUT when "101",
            R6_OUT when "110",
            R7_OUT when "111",
            (others => '0') when others;

end architecture;
