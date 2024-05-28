----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2024 12:37:40
-- Design Name: 
-- Module Name: aluCTRL - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aluCTRL is
    Port ( functionIn : in STD_LOGIC_VECTOR (5 downto 0);
           aluOP : in STD_LOGIC_VECTOR (1 downto 0);
           operation : out STD_LOGIC_VECTOR (2 downto 0));
end aluCTRL;

architecture Behavioral of aluCTRL is

    signal tempOP : std_logic_vector (2 downto 0);
begin

        tempOP <= "010" when functionIn= "100000" else
                  "110" when functionIn= "100010" else
                  "000" when functionIn= "100100" else
                  "111" when functionIn= "101010" else
                  "010";
                             
        operation <= tempOP when aluOP="10" else
                     "010" when aluOP="00" else
                     "110" when aluOP="01" else
                     "010";
                     
end Behavioral;
