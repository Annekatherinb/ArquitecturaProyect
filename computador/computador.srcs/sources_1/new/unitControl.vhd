----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2024 11:27:26
-- Design Name: 
-- Module Name: UnitControl - Behavioral
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


entity UnitControl is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           inWrite : out STD_LOGIC;
           mem2reg : out STD_LOGIC;
           memWrite : out STD_LOGIC;
           memRead : out STD_LOGIC;
           IorD : out STD_LOGIC;
           pcWrite : out STD_LOGIC;
           branch : out STD_LOGIC;
           pcSrc : out STD_LOGIC_VECTOR (1 downto 0);
           aluOp : out STD_LOGIC_VECTOR (1 downto 0);
           aluSrcb : out STD_LOGIC_VECTOR (1 downto 0);
           aluSrcA : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           regDst : out STD_LOGIC);
end UnitControl;

architecture Behavioral of UnitControl is
    signal currentState, nextState: std_logic_vector (3 downto 0)
    
begin
    nextStateFunction process (opcode, currentState)
    begin
        if (cirremtState = "0000";
            nextState = "0001";
        end if;
    end process;
    
    stateRegister : Process (clock)
    
    begin
        if (clock' event and clock = '1') then
            if (reset = '1') then
                currentState <= "0000";
            else 
                currentState <= nextState;
            end if;
        end if;
end process;

end Behavioral;
