----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2024 12:59:37
-- Design Name: 
-- Module Name: mux4to1_32bits - Behavioral
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


entity mux4to1_32bits is
    Port ( inputA : in STD_LOGIC_VECTOR (31 downto 0);
           inputB : in STD_LOGIC_VECTOR (31 downto 0);
           inputC : in STD_LOGIC_VECTOR (31 downto 0);
           inputD : in STD_LOGIC_VECTOR (31 downto 0);
           selec : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end mux4to1_32bits;

architecture Behavioral of mux4to1_32bits is

begin
with selec select
    muxOut <= inputA when "00",
              inputB when "01",
              inputC when "10",
              inputD when others;   


end Behavioral;
