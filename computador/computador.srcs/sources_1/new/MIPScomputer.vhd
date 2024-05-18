library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity MIPScomputer is
Port (     reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           exDataOut: out std_logic_vector(15 downto 0));
end MIPScomputer;

architecture Behavioral of MIPScomputer is

component procesador
port (reset : in STD_LOGIC;
      clock : in STD_LOGIC;
      address: out std_logic_vector(31 downto 0);
      datain: in std_logic_vector(31 downto 0);
      dataOut: out std_logic_vector(31 downto 0);
      read: out std_logic;
      write : out STD_LOGIC);
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

component registro4b
port(      dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);

end component;

signal iclock, read_i, write_i, eDevice, eMemory: STD_LOGIC;
signal registerIn, registerOut, data_i, address_i, dataOut_i, exDataOut_i : STD_LOGIC_VECTOR(31 downto 0);
    
begin

U1: procesador
port map(
    reset => reset,
    clock => iclock,
    address => address_i,
    dataIn => data_i,
    dataOut => dataOut_i,
    read => read_i,
    write => write_i
);

U2: memory
port map(
    clock => clock,
    address => address_i(9 downto 0),
    dataIn => dataOut_i,
    dataOut => data_i,
    write =>eMemory,
    read => read_i

);
regOut: registro4b
port map(
    reset => reset,
    clock => clock,
    dataIn => dataOut_i,
    dataOut => exDataOut_i, 
    enable => eDevice
);

exDataOut <= exDataOut_i(15 downto 0);
eDevice <= write_i and address_i(14);
eMemory <= write_i and not (address_i(14));

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
