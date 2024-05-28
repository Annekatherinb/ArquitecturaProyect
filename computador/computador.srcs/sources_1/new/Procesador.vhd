----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2024 11:32:58
-- Design Name: 
-- Module Name: Procesador - Behavioral
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

entity Procesador is
Port (reset : in STD_LOGIC;
      clock : in STD_LOGIC;
      address: out std_logic_vector(31 downto 0);
      datain: in std_logic_vector(31 downto 0);
      dataOut: out std_logic_vector(31 downto 0);
      read: out std_logic;
      write : out STD_LOGIC);
end Procesador;

architecture Behavioral of Procesador is

component registro4b
    port(
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);

end component;  
    
component mux2to1_32b
    port(
           inputA : in STD_LOGIC_VECTOR (31 downto 0);
           inputB : in STD_LOGIC_VECTOR (31 downto 0);
           selec : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (31 downto 0)
           
           );
end component;

component mux4to1_32bits
    port(  inputA : in STD_LOGIC_VECTOR (31 downto 0);
           inputB : in STD_LOGIC_VECTOR (31 downto 0);
           inputC : in STD_LOGIC_VECTOR (31 downto 0);
           inputD : in STD_LOGIC_VECTOR (31 downto 0);
           selec : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
           
end component;

component unitControl
    port(
           reset : in STD_LOGIC;
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
           regDst : out STD_LOGIC
    );
    
end component;
component Alu
Port(
     A : in STD_LOGIC_VECTOR (31 downto 0);
     B : in STD_LOGIC_VECTOR (31 downto 0);
     oper : in STD_LOGIC_VECTOR (3 downto 0); --operacion que realiza la alu
     result : out STD_LOGIC_VECTOR (31 downto 0);
     zflag : out STD_LOGIC --indicador de cuando el result es 0

);
end component;

component mux2to1_5b
    port(inputA : in STD_LOGIC_VECTOR (4 downto 0);
           inputB : in STD_LOGIC_VECTOR (4 downto 0);
           selec : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (4 downto 0));   
end component;

component ResgisterFile
    port(Read_register1 : in STD_LOGIC_VECTOR (4 downto 0);
           Read_register2 : in STD_LOGIC_VECTOR (4 downto 0);
           Read_register3 : in STD_LOGIC_VECTOR (4 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut1 : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut2 : out STD_LOGIC_VECTOR (31 downto 0);
           enableWrite : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;
--no hya signo extendido
component signExtend
    Port ( data16 : in STD_LOGIC_VECTOR (15 downto 0);
           data32 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Alu_control
    Port ( funct : in STD_LOGIC_VECTOR (5 downto 0);
           Aluop : in STD_LOGIC_VECTOR (2 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end component;



signal pc2mux, alu2PC, irData, rfOut1, rfOut2, toAlu1, toAlu2, se2mux,mux2alu2, mux2alu1, aluResult, aluRegOut, tempMux, mux2PC,mdrOut, mux2Rf : std_logic_vector(31 downto 0);
signal iorD_i, pcWrite_i, zFlag, irWrite_i, regDst_i, regwrite_i, aluSrcA_i, mem2reg_i, pcenable, branch_i : std_logic;
signal aluSrcB_i,pcSrc_i : std_logic_vector(1 downto 0);
signal aluOP_i: std_logic_vector(2 downto 0);
signal writeRFaddress: std_logic_vector (4 downto 0);
signal operation : std_logic_vector(3 downto 0);

begin
    
    PC: registro4b
    port map(
        reset => reset,
        clock => clock,
        enable => pcWrite_i,
        dataIn => mux2PC,
        dataOut => pc2mux
    );
    pcEnable <= pcWrite_i or (branch_i and zFlag);
    
    MUX01:mux2to1_32b
    port map(
        inputA => pc2mux,
        inputB => aluRegOut,
        selec => iorD_i,
        muxOut => address
    );
    IR: registro4b
    port map(
        reset => reset,
        clock => clock,
        enable => irWrite_i,
        dataIn => dataIn,
        dataOut => irData
    );
    
    controlU: unitControl
    port map(
    reset => reset,
    clock => clock,
    opcode => irData(31 downto 26),
    irWrite => irWrite_i,
    memToreg => mem2reg_i,
    memWrite => write,
    memRead => read,
    IorD => iorD_i,
    pcwrite => pcwrite_i,
    branch => branch_i,
    pcsrc => pcSrc_i,
    aluOP => aluOP_i,
    aluSrcB => aluSrcB_i,
    aluSrcA => aluSrcA_i,
    regWrite => regWrite_i,
    regDst => regDst_i);
    
    mALU: Alu
    port map(
        A => pc2mux,
        B => x"00000001",
        oper => "0010",
        zFlag => zFlag,
        result => aluresult    
    );
    
    MUX02: mux2to1_5b
    port map(
        inputA => irData(20 downto 16),
        inputB => irData(15 downto 11),
        selec  => regDst_i,
        muxOut => writeRFaddress);
    
    RF: ResgisterFile
    port map(
           Read_register1 => irData(25 downto 21),
           Read_register2 => irData(20 downto 16),
           Read_register3 => writeRFaddress,
           dataIn  => x"00000000",
           enableWrite => regWrite_i,
           clock => clock,
           dataOut1 => rfOut1,
           dataOut2 => rfOut2
    );
    
    regA: Registro4b
    port map(
           reset => reset,
           clock => clock,
           enable => '1',
           dataIn => rfOut1,
           dataOut => toalu1
    );
    
    regB: Registro4b
    port map(
        reset => reset,
        clock => clock,
        enable => '1',
        dataIn => rfOut2,
        dataOut => toaLU2
    );
    
    dataOut <= toalu2;
    
    singEx: signExtend
    port map(
        data16 => irData(15 downto 0),
        data32 => se2mux
    );
    
    MUX03: mux4to1_32bits
    port map(
        inputA => toAlu2,
        inputB => X"00000001",
        inputC => se2mux,
        inputD => se2mux,
        selec => aluSrcB_i,
        muxOut => mux2alu2
    );
    
    MUX04: mux2to1_32b
    port map(
        inputA => pc2mux,
        inputB => toalu1,
        selec => aluSrcA_i,
        muxOut => mux2alu1
    ); 
    
    aCTRL: Alu_control
    port map(
        funct => irData(5 downto 0),
        Aluop => aluOP_i,
        operation => operation 
    );
    
    aluReg: Registro4b
    port map(
        reset => reset,
        clock => clock,
        enable => '1',
        dataIn => aluresult,
        dataOut => toalu2
    );
    tempMux <= pc2mux(31 downto 26) & irData(25 downto 0);
    
    MUX05: mux4to1_32bits
    port map(
        inputA => aluResult,
        inputB => aluRegOut,
        inputC => tempMux,
        inputD => tempMux,
        selec => pcSrc_i,
        muxOut => mux2PC
    );
    
    MUX06: mux2to1_32b
    port map(
        inputA => aluRegOut,
        inputB => mdrOut,
        selec => mem2reg_i,
        muxOut => mux2rf
    );
    
    MDR: Registro4b
    port map(
        reset => reset,
        clock => clock,
        enable => '1',
        dataIn => dataIn,
        dataOut => mdrOut
    );
    
end Behavioral;
