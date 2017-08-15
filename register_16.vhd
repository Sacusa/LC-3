------------------
-- 16-bit Register
------------------
------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity register_16 is
    port (
        LD       : in  std_logic;
        DATA_IN  : in  std_logic_vector(15 downto 0);
        DATA_OUT : out std_logic_vector(15 downto 0)
    );
end register_16;

architecture register_16_arch of register_16 is

    -- signal to store value
    signal DATA_STORED : std_logic_vector(15 downto 0);

begin

    -- process to load new values
    load: process(LD, DATA_IN)
    begin
        if (LD = '1') then
            DATA_STORED <= DATA_IN;
        end if;
    end process;

    DATA_OUT <= DATA_STORED;

end architecture;
