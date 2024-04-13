----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2024 11:38:00
-- Design Name: 
-- Module Name: AluControl - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Alu_control is
    Port ( funct : in STD_LOGIC_VECTOR (5 downto 0);
           Aluop : in STD_LOGIC_VECTOR (2 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end Alu_control;

architecture Behavioral of Alu_control is
    signal temp: std_logic_vector (3 downto 0);
begin
    operation <= temp;
    controlador : process (funct, ALUOP)
        begin
            if (ALUOP = "000") then
                temp <= "0010"; --suma
                
            elsif (ALUOP = "001") then
                temp <= "0110"; --resta
                
            elsif (ALUOP = "011") then
                temp <= "0001"; --or
                
            elsif (ALUOP = "100") then
                temp <= "0000"; --and
                
            elsif (ALUOP = "101") then
                temp <= "0111"; -- slt
                
            elsif (ALUOP = "010") then -- tipo R
                if (funct = "100000") then
                    temp <= "0010";
                    
                elsif (funct = "100010") then
                    temp <= "0110";
                    
                elsif (funct = "100100") then
                    temp <= "0000";
                    
                elsif (funct = "100101") then
                    temp <= "0001";
                    
                elsif (funct = "100111") then
                    temp <= "0011";
                    
                elsif (funct = "101010") then
                    temp <= "0111";
                    
                elsif (funct = "000000") then
                    temp <= "0100";
                    
                elsif (funct = "000010") then
                    temp <= "0101";
                    
                elsif (funct = "010010") then
                    temp <= "1111";
                    
                elsif (funct = "001100") then
                    temp <= "1110";
                else
                    temp <= "0010";    
                end  if;
            else
                temp <= (others => '0');
            end if;
        end process;
end Behavioral;

