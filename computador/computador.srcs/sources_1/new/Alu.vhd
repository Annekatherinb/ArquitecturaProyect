----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2024 11:36:14
-- Design Name: 
-- Module Name: Alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;



entity Alu is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           oper : in STD_LOGIC_VECTOR (3 downto 0); --operacion que realiza la alu
           result : out STD_LOGIC_VECTOR (31 downto 0);
           zflag : out STD_LOGIC); --indicador de cuando el result es 0
end Alu;

architecture Behavioral of Alu is
    signal tempRM : std_logic_vector (63 downto 0); --shift left que tambien entra a la alu
begin
  zFlag <= '1' when tempRM = x"0000000000000000" else
             '0';

    Result <= tempRM(31 downto 0);
    controlador : process (oper,A,B)
    begin
        tempRM <= (others => '0');
        if (oper = "0010") then
            tempRM(31 downto 0) <= A + B;
            
        elsif (oper = "0110") then
            tempRM(31 downto 0) <= A - B;
            
        elsif (oper = "0001") then
            tempRM(31 downto 0) <= A OR B;
            
        elsif (oper = "0000") then
            tempRM(31 downto 0) <= A AND B ;
           
        elsif (oper = "0111") then
            if (A < B) then 
                tempRM <= x"0000000000000001";
            else
                tempRM <= x"0000000000000000";
            end if;
            
        elsif (oper = "0011") then
            tempRM(31 downto 0) <= A NOR B;
            
        elsif (oper = "1111") then
            tempRM <= A * B;
        else
            tempRM <= (others => '0'); 
        end if;    
    end process;
end Behavioral;