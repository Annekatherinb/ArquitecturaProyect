library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory is
    Port ( address : in STD_LOGIC_VECTOR (9 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           clock : in STD_LOGIC;
           write : in STD_LOGIC;
           read: in std_logic
           );
end Memory;

architecture Behavioral of Memory is
    type   ram_type is array ( 0 to 1023 ) of std_logic_vector ( 31 downto 0 );
    signal ramMemory : ram_type := (X"00000000", X"8D280000", X"112A0200",
                                    X"00000000", X"8D280000", others => (others => '0'));
begin
    process (clock)
    begin
        if (clock'event and clock='1' and write='1') then
            ramMemory (conv_integer(address)) <= dataIn;
        end if;
    end process;
    
    dataOut <= ramMemory(conv_integer(address));
    
end Behavioral;
