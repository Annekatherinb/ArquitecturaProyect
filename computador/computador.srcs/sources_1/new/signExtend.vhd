library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signExtend is
    Port ( data16 : in STD_LOGIC_VECTOR (15 downto 0);
           data32 : out STD_LOGIC_VECTOR (31 downto 0));
end signExtend;

architecture Behavioral of signExtend is

begin

    data32 <= X"0000"&data16 when data16(15) = '0' else
              X"FFFF"&data16;

end Behavioral;
