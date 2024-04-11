----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2024 12:25:23
-- Design Name: 
-- Module Name: registro4b - Behavioral
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

entity registro4b is
    Port ( dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end registro4b;

architecture Behavioral of registro4b is

begin
    process(clock, reset, enable)
    begin
        if (clock'event and clock = '1') then
            if (reset = '1') then
                dataOut <= x"00000000";
            elsif (enable = '1') then
                dataOut <= dataIn;
            end if;
        end if;
    end process;

end Behavioral;
