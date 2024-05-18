library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity MIPScomputer is
Port (     reset : in STD_LOGIC;
           clock : in STD_LOGIC;
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
end MIPScomputer;

architecture Behavioral of MIPScomputer is

component procesador
port (
      reset : in STD_LOGIC;
      clock : in STD_LOGIC;
      address: out std_logic_vector(31 downto 0);
      datain: in std_logic_vector(31 downto 0);
      read: out std_logic;
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
      regDst : out STD_LOGIC
);
end component;

component memory
port (
      address : in STD_LOGIC_VECTOR (9 downto 0);
      dataIn : in STD_LOGIC_VECTOR (31 downto 0);
      dataOut : out STD_LOGIC_VECTOR (31 downto 0);
      clock : in STD_LOGIC;
      write : in STD_LOGIC;
      read: in std_logic
);
end component;

signal iclock, read_i, write_i : STD_LOGIC;
signal registerIn, registerOut, data_i, address_i : STD_LOGIC_VECTOR(31 downto 0);
    
begin
U1: procesador

port map(
    reset => reset,
    clock => iclock,
    address => address_i,
    dataIn => data_i,
    read => read_i,
    irWrite => irWrite,
    memToreg => memToreg,
    memWrite => memWrite,
    memRead => memRead,
    IorD => IorD,
    pcwrite => pcWrite,
    branch => branch,
    pcSrc => pcSrc,
    aluOP => aluOP,
    aluSrcB => aluSrcB,
    aluSrcA => alusrcA,
    regWrite => regWrite,
    regDst => regDst
);

U2: memory
port map(
    clock => clock,
    address => address_i(9 downto 0),
    dataIn => X"00000000",
    dataOut => data_i,
    write =>write_i,
    read => read_i

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
