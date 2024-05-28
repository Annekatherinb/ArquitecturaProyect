library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity testControlU is
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
           aluOP : out STD_LOGIC_VECTOR (1 downto 0);
           aluSrcB : out STD_LOGIC_VECTOR (1 downto 0);
           aluSrcA : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           regDst : out STD_LOGIC);
end testControlU;

architecture Behavioral of testControlU is
component unitControl

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
           aluOP : out STD_LOGIC_VECTOR (1 downto 0);
           aluSrcB : out STD_LOGIC_VECTOR (1 downto 0);
           aluSrcA : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           regDst : out STD_LOGIC);
           
end component;
 
    signal iclock : STD_LOGIC;
    signal registerIn, registerOut : STD_LOGIC_VECTOR(31 downto 0);
    
begin
U1: unitControl
port map(
    reset => reset,
    clock => iclock,
    opcode => opcode,
    irWrite => irWrite,
    memToReg => memToReg,
    memWrite => memWrite,
    memRead => memRead,
    IorD => IorD,
    pcWrite => pcWrite,
    branch => branch,
    pcSrc => pcSrc,
    aluOp => aluOp,
    aluSrcB => aluSrcB,
    aluSrcA => aluSrcA,
    regWrite => regWrite,
    regDst => regDst
);

registro32b: process (clock, reset)
    begin
        if (reset = '1') then
            registerOut <= x"00000000";
        elsif (clock'event and clock='1') then
            registerOut <= registerIn;
        end if;
    end process;
    
    registerIn <= registerOut + 1;
    iclock <= registerOut(22);

end Behavioral;
