library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unitControl is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           irWrite : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           memWrite : out STD_LOGIC;
           memRead : out STD_LOGIC;
           IorD : out STD_LOGIC;
           pcWrite : out STD_LOGIC;
           branch : out STD_LOGIC;
           pcSrc : out STD_LOGIC_VECTOR (1 downto 0);
           aluOP : out STD_LOGIC_VECTOR (2 downto 0);
           aluSrcB : out STD_LOGIC_VECTOR (1 downto 0);
           aluSrcA : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           regDst : out STD_LOGIC);
end unitControl;

architecture Behavioral of unitControl is
    type stateType is (fetch, decode, memAddr, memReadST, memWB,memWriteST,
                        execute, aluWB, branchST, jumpST);
signal currentState, nextState : std_logic_vector (3 downto 0);
signal estadoActual, estadoSiguiente : stateType;


begin
    stateRegister: process (clock, reset)
    begin 
        if (reset = '1') then
            estadoActual <= fetch;
        else
            if (clock'event and clock ='1') then
                estadoActual <= estadoSiguiente;
            end if;
        end if;
    end process;
    
    nextStateFunction: process(opcode, estadoActual)
    begin
         case (estadoActual) is
              when fetch =>
                 estadoSiguiente <= decode;
              when decode =>
                 case (opcode) is
                    when "100011" =>
                        estadoSiguiente <= memAddr;
                    when "101011" =>
                        estadoSiguiente <= memAddr;
                    when "000000" =>
                        estadoSiguiente <= execute;
                    when "000100" =>
                        estadoSiguiente <= branchST;
                    when "000010" =>
                        estadoSiguiente <= jumpST;
                        estadoSiguiente <= jumpST;
                    when others =>
                        estadoSiguiente <= fetch;
                    end case;
              when memAddr =>
                 if (opcode = "100011") then
                    estadoSiguiente <= memReadST;
                 else
                    estadoSiguiente <= memWriteST;
                 end if;
              when memReadST =>
                 estadoSiguiente <= memWB;
              when memWB =>
                 estadoSiguiente <= fetch;
              when memWriteST =>
                 estadoSiguiente <= fetch;
              when execute =>
                 estadoSiguiente <= aluWB;
              when aluWB =>
                 estadoSiguiente <= fetch;
              when branchST =>
                 estadoSiguiente <= fetch;
              when jumpST =>
                 estadoSiguiente <= fetch;
              when others =>
                 estadoSiguiente <= fetch;
           end case;    
    end process;

    
    outputsFunction: process(estadoActual)
    begin
         case (estadoActual) is
              when fetch =>
                   irWrite <= '1';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '1';
                   IorD <= '0';
                   pcWrite <= '1';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "01";
                   aluSrcA <= '0';
                   regWrite <= '0';
                   regDst  <= '0';                
              when decode =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "11";
                   aluSrcA <= '0';
                   regWrite <= '0';
                   regDst  <= '0';
              when memAddr =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "10";
                   aluSrcA <= '1';
                   regWrite <= '0';
                   regDst  <= '0';   
              when memReadST =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '1';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "00";
                   aluSrcA <= '0';
                   regWrite <= '0';
                   regDst  <= '0';   
              when memWB =>
                   irWrite <= '0';
                   memToReg <= '1';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "00";
                   aluSrcA <= '0';
                   regWrite <= '1';
                   regDst  <= '0';
              when memWriteST =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '1';
                   memRead <= '0';
                   IorD <= '1';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "00";
                   aluSrcA <= '0';
                   regWrite <= '0';
                   regDst  <= '0';
              when execute =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "010";
                   aluSrcB <= "00";
                   aluSrcA <= '1';
                   regWrite <= '0';
                   regDst  <= '0';
              when aluWB =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "00";
                   aluSrcA <= '0';
                   regWrite <= '1';
                   regDst  <= '1';
              when branchST =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '1';
                   pcSrc <= "01";
                   aluOP <= "001";
                   aluSrcB <= "00";
                   aluSrcA <= '1';
                   regWrite <= '0';
                   regDst  <= '0';
              when jumpST =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '1';
                   branch <= '0';
                   pcSrc <= "10";
                   aluOP <= "000";
                   aluSrcB <= "00";
                   aluSrcA <= '0';
                   regWrite <= '0';
                   regDst  <= '0';
              when others =>
                   irWrite <= '0';
                   memToReg <= '0';
                   memWrite <= '0';
                   memRead <= '0';
                   IorD <= '0';
                   pcWrite <= '0';
                   branch <= '0';
                   pcSrc <= "00";
                   aluOP <= "000";
                   aluSrcB <= "00";
                   aluSrcA <= '0';
                   regWrite <= '0';
                   regDst  <= '0';
           end case;    
    end process;
end Behavioral;
