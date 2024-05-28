----------------------------------------------------------------------------------
-----------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dataMemory is
    Port ( clock : in std_logic;
    write : in STD_LOGIC;
    address : in STD_LOGIC_VECTOR (6 downto 0);
    dataIn : in STD_LOGIC_VECTOR (7 downto 0); 
    dataOut : out STD_LOGIC_VECTOR (7 downto 0));
     
end dataMemory;

architecture Behavioral of dataMemory is
    type memoryType is array (0 to 127) of std_logic_vector(7 downto 0);
    signal ramData : memoryType := (x"48",x"45",x"6C",x"6c",x"6f",x"20",
                                    x"57",x"6f",x"72",x"6c",x"64", others => (Others => '0'));
begin

process (clock)
begin
    if (clock'event and clock='1') then
        if (write = '1') then
            ramData(conv_integer(address)) <= dataIn;
        end if;
    end if;
end process;
    dataOut <= ramData(conv_integer(address));
end Behavioral;
