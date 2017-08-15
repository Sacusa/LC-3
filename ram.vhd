-- Sourced from:
-- https://www.doulos.com/knowhow/vhdl_designers_guide/models/simple_ram_model/

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
    port (
        WE               : in  std_logic;
        ADDRESS, DATA_IN : in  std_logic_vector(15 downto 0);
        DATA_OUT         : out std_logic_vector(15 downto 0)
    );
end ram;

architecture RTL of ram is

   type ram_type is array (0 to (2**ADDRESS'length)-1) of std_logic_vector(DATA_IN'range);
   signal RAM : ram_type;
   signal READ_ADDRESS : std_logic_vector(ADDRESS'range) := (others => '0');

begin
    with (READ_ADDRESS) select
        DATA_OUT <= "0101001001100000" when "0000000000000000",
                    "0101010010100000" when "0000000000000001",
                    "0001001001100101" when "0000000000000010",
                    "0001010010101010" when "0000000000000011",
                    "0001011001000010" when "0000000000000100",
                    "1010100000010100" when "0000000000000101",
                    RAM(to_integer(unsigned(READ_ADDRESS))) when others;

    ram_proc: process(WE, ADDRESS, DATA_IN) is
    begin
        if (WE = '1') then
            RAM(to_integer(unsigned(ADDRESS))) <= DATA_IN;
        end if;
        READ_ADDRESS <= ADDRESS;
    end process ram_proc;

end architecture RTL;
