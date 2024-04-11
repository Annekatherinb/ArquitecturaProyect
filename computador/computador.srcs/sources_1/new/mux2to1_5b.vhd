----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2024 12:27:49
-- Design Name: 
-- Module Name: mux2to1_5b - Behavioral
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

entity mux2to1_5b is
    Port ( inputA : in STD_LOGIC_VECTOR (4 downto 0);
           inputB : in STD_LOGIC_VECTOR (4 downto 0);
           selec : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (4 downto 0));
end mux2to1_5b;

architecture Behavioral of mux2to1_5b is

begin
muxOut <= inputA when selec = '0' else 
          inputB;

end Behavioral;
