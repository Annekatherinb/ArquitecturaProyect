
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_signed.ALL;


entity ResgisterFile is
    Port ( Read_register1 : in STD_LOGIC_VECTOR (4 downto 0);
           Read_register2 : in STD_LOGIC_VECTOR (4 downto 0);
           Read_register3 : in STD_LOGIC_VECTOR (4 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut1 : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut2 : out STD_LOGIC_VECTOR (31 downto 0);
           enableWrite : in STD_LOGIC;
           clock : in STD_LOGIC);
end ResgisterFile;

architecture Behavioral of ResgisterFile is
    type memoryType is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal registers : memoryType;
begin

    process (clock)
    begin
        if (clock' event and clock='1') then
            if (enableWrite = '1') then
                registers(conv_integer(Read_register3)) <= dataIn;
            end if;
        end if;
    end process;

    dataOut1 <= registers(conv_integer(Read_register1));
    dataOut2 <= registers(conv_integer(Read_register2));
    
end Behavioral;
