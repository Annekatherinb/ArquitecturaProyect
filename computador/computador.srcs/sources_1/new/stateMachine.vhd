
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stateMachine is
    Port ( sm_Inputs : in STD_LOGIC_VECTOR (3 downto 0);
           reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           sm_outputs : in STD_LOGIC_VECTOR (1 downto 0));
end stateMachine;

architecture Behavioral of stateMachine is
    signal currentState, nextState : std_logic_vector(3 downto 0);
begin

    stateRegister : process (clock, reset)
    begin
       if (reset = '1') then
            currentState <= (others => '0');
        else
            if (clock'event and clock ='1') then
                currentState <= nextState;
            end if;
        end if;    end process;

    nextStateFunction : process (currentState,sm_Inputs)
    begin
        if (currentState = "000") then
            if (sm_Inputs = "0000") then
                nextState <= "001";
            else
                nextState <= currentState;
            end if;
        elsif (currentState = "001") then
            if (sm_Inputs = "0010") then
                nextState <= "010";
            elsif (sm_Inputs = "0011") then
                nextState <= "100";
            else
                nextState <= currentState;
            end if;
        elsif (currentState = "010") then
            if (sm_Inputs = "0011") then
                nextState <= "100";
            else
                nextState <= currentState;
            end if;
        elsif (currentState = "011") then
            if (sm_Inputs = "0000") then
                nextState <= "000";
            else
                nextState <= currentState;
            end if;
        elsif (currentState = "100") then
            if (sm_Inputs = "0101") then
                nextState <= "011";
            else
                nextState <= currentState;
            end if;
        else
            nextState <= currentState;
        end if;
    end process;
    
    outputsFunction : process (currentState)
    begin
    
    end process;

end Behavioral;
