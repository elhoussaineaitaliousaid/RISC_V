library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        clk, reset : in std_logic
    );
end top;

architecture Behavioral of top is

    -- Signaux internes entre Control et Datapath
    signal PCWrite, IRWrite, MemWrite, RegWrite : std_logic;
    signal ALUSrcA, PCSrc, AdrSrc : std_logic;
    signal ALUSrcB, ResultSrc : std_logic_vector(1 downto 0);
    signal ImmSrc, ALUOp : std_logic_vector(1 downto 0);
    signal Zero : std_logic;
    signal Op : std_logic_vector(6 downto 0); -- Opcode

    -- Pour récupérer l'opcode depuis l'instruction IR du datapath
    signal Instr : std_logic_vector(31 downto 0);

begin

    -- Datapath Instance
    datapath_inst: entity work.datapath
        port map (
            clk       => clk,
            reset     => reset,
            PCWrite   => PCWrite,
            IRWrite   => IRWrite,
            MemWrite  => MemWrite,
            RegWrite  => RegWrite,
            ALUSrcA   => ALUSrcA,
            PCSrc     => PCSrc,
            AdrSrc    => AdrSrc,
            ALUSrcB   => ALUSrcB,
            ResultSrc => ResultSrc,
            ImmSrc    => ImmSrc,
            ALUOp     => ALUOp,
            Zero      => Zero,
            InstrOut  => Instr
        );


    -- Control Unit Instance
    control_inst: entity work.control
        port map (
            clk       => clk,
            reset     => reset,
            Op        => Instr(6 downto 0),
            Zero      => Zero,
            PCWrite   => PCWrite,
            IRWrite   => IRWrite,
            MemWrite  => MemWrite,
            RegWrite  => RegWrite,
            ALUSrcA   => ALUSrcA,
            PCSrc     => PCSrc,
            AdrSrc    => AdrSrc,
            ALUSrcB   => ALUSrcB,
            ResultSrc => ResultSrc,
            ImmSrc    => ImmSrc,
            ALUOp     => ALUOp
    );


end Behavioral;
