library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    Port (
        clk, reset : in std_logic;

        -- Control Signals
        PCWrite, IRWrite, MemWrite, RegWrite : in std_logic;
        ALUSrcA, PCSrc, AdrSrc : in std_logic;
        ALUSrcB, ResultSrc : in std_logic_vector(1 downto 0);
        ImmSrc, ALUOp : in std_logic_vector(1 downto 0);

        -- Outputs to Control
        Zero : out std_logic;
        InstrOut : out std_logic_vector(31 downto 0)
    );
end datapath;

architecture Behavioral of datapath is

    -- Internal signals
    signal PC, PCNext, OldPC, ALUResult, ALUOut, Result, Instr, Data, ReadData : std_logic_vector(31 downto 0);
    signal AdrMux : std_logic_vector(31 downto 0);
    signal ImmExt, SrcA, SrcB : std_logic_vector(31 downto 0);
    signal RD1, RD2, WD3 : std_logic_vector(31 downto 0);
    signal ALUControl : std_logic_vector(3 downto 0);

begin
    -- Multiplexeurs datapath
    AdrMux <= PC when AdrSrc = '0' else ALUOut;
    SrcA <= OldPC when ALUSrcA = '0' else RD1;
    SrcB <= x"00000004" when ALUSrcB = "01" else
            ImmExt when ALUSrcB = "10" else
            RD2;
    PCNext <= ALUResult when PCSrc = '1' else ALUOut;
    Result <= ALUOut when ResultSrc = "00" else
              ALUResult when ResultSrc = "01" else
              Data;
    WD3 <= Result;

    -- PC
    PC_reg: entity work.pc
        port map (
            clk     => clk,
            reset   => reset,
            PCWrite => PCWrite,
            PCin    => PCNext,
            PCout   => PC
        );

    -- Old PC Register
    process(clk)
    begin
        if rising_edge(clk) then
            OldPC <= PC;
        end if;
    end process;

    -- Instruction / Data Memory
    instr_mem: entity work.instr_data_mem
        port map (
            clk  => clk,
            addr => AdrMux,
            we   => MemWrite,
            WD   => RD2,
            RD   => ReadData
        );

    -- Instruction Register (IR)
    process(clk)
    begin
        if rising_edge(clk) then
            if IRWrite = '1' then
                Instr <= ReadData;
            end if;
        end if;
    end process;

    -- MDR Register (Data)
    process(clk)
    begin
        if rising_edge(clk) then
            Data <= ReadData;
        end if;
    end process;

    -- Register File
    reg_file: entity work.register_file
        port map (
            clk   => clk,
            we3   => RegWrite,
            a1    => Instr(19 downto 15),
            a2    => Instr(24 downto 20),
            a3    => Instr(11 downto 7),
            wd3   => WD3,
            rd1   => RD1,
            rd2   => RD2
        );

    -- Sign Extend
    sign_extend_inst: entity work.sign_extend
        port map (
            Instr  => Instr(31 downto 7),
            ImmSrc => ImmSrc,
            ImmOp  => ImmExt
        );

    -- ALU Control
    alu_control_inst: entity work.alu_control
        port map (
            ALUOp     => ALUOp,
            Funct3    => Instr(14 downto 12),
            Funct7_5  => Instr(30),
            ALUControl => ALUControl
        );

    -- ALU
    alu_inst: entity work.alu
        port map (
            A          => SrcA,
            B          => SrcB,
            ALUControl => ALUControl,
            Result     => ALUResult,
            Zero       => Zero
        );

    -- ALUOut Register
    process(clk)
    begin
        if rising_edge(clk) then
            ALUOut <= ALUResult;
        end if;
    end process;

    -- Expose instruction for Control
    InstrOut <= Instr;

end Behavioral;
