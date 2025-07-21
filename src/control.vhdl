library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is
    Port (
        clk, reset : in std_logic;
        Op : in std_logic_vector(6 downto 0);
        Zero : in std_logic;
        
        PCWrite, IRWrite, MemWrite, RegWrite : out std_logic;
        ALUSrcA, PCSrc, AdrSrc : out std_logic;
        ALUSrcB, ResultSrc : out std_logic_vector(1 downto 0);
        ImmSrc, ALUOp : out std_logic_vector(1 downto 0)
    );
end control;

architecture Behavioral of control is
    type state_type is (Fetch, Decode, MemAdr, MemRead, MemWB, MemWriteS, ALUExec, ALUWB, Branch);
    signal state, nextstate : state_type;

    -- Internal control signals
    signal PCWrite_int, IRWrite_int, MemWrite_int, RegWrite_int : std_logic;
    signal ALUSrcA_int, PCSrc_int, AdrSrc_int : std_logic;
    signal ALUSrcB_int, ResultSrc_int : std_logic_vector(1 downto 0);
    signal ImmSrc_int, ALUOp_int : std_logic_vector(1 downto 0);

begin
    -- Assign outputs
    PCWrite   <= PCWrite_int;
    IRWrite   <= IRWrite_int;
    MemWrite  <= MemWrite_int;
    RegWrite  <= RegWrite_int;
    ALUSrcA   <= ALUSrcA_int;
    PCSrc     <= PCSrc_int;
    AdrSrc    <= AdrSrc_int;
    ALUSrcB   <= ALUSrcB_int;
    ResultSrc <= ResultSrc_int;
    ImmSrc    <= ImmSrc_int;
    ALUOp     <= ALUOp_int;

    -- State register
    process(clk, reset)
    begin
        if reset = '1' then
            state <= Fetch;
        elsif rising_edge(clk) then
            state <= nextstate;
        end if;
    end process;

    -- Next state logic
    process(state, Op, Zero)
    begin
        nextstate <= Fetch;
        case state is
            when Fetch =>
                nextstate <= Decode;
            when Decode =>
                case Op is
                    when "0000011" => nextstate <= MemAdr;  -- lw
                    when "0100011" => nextstate <= MemAdr;  -- sw
                    when "1100011" => nextstate <= Branch;  -- beq
                    when others    => nextstate <= ALUExec; -- R-type, I-type (addi)
                end case;
            when MemAdr =>
                if Op = "0000011" then
                    nextstate <= MemRead;
                else
                    nextstate <= MemWriteS;
                end if;
            when MemRead =>
                nextstate <= MemWB;
            when MemWB =>
                nextstate <= Fetch;
            when MemWriteS =>
                nextstate <= Fetch;
            when ALUExec =>
                nextstate <= ALUWB;
            when ALUWB =>
                nextstate <= Fetch;
            when Branch =>
                nextstate <= Fetch;
        end case;
    end process;

    -- Output control logic for each state
    process(state)
    begin
        PCWrite_int  <= '0';
        IRWrite_int  <= '0';
        MemWrite_int <= '0';
        RegWrite_int <= '0';
        ALUSrcA_int  <= '0';
        PCSrc_int    <= '0';
        AdrSrc_int   <= '0';
        ALUSrcB_int  <= "00";
        ResultSrc_int<= "00";
        ImmSrc_int   <= "00";
        ALUOp_int    <= "00";

        case state is
            when Fetch =>
                IRWrite_int <= '1';
                AdrSrc_int  <= '0';
                ALUSrcA_int <= '0';
                ALUSrcB_int <= "01"; -- +4
                ALUOp_int   <= "00"; -- ADD
                ResultSrc_int <= "10"; -- from memory
                PCWrite_int <= '1';

            when Decode =>
                ALUSrcA_int <= '0';
                ALUSrcB_int <= "11"; -- reg B
                ALUOp_int   <= "00";
                ImmSrc_int  <= "00";

            when MemAdr =>
                AdrSrc_int  <= '1';
                ALUSrcA_int <= '1';
                ALUSrcB_int <= "10"; -- Imm
                ALUOp_int   <= "00";

            when MemRead =>
                AdrSrc_int   <= '1';
                ResultSrc_int<= "10";

            when MemWB =>
                RegWrite_int <= '1';
                ResultSrc_int<= "10";

            when MemWriteS =>
                AdrSrc_int   <= '1';
                MemWrite_int <= '1';

            when ALUExec =>
                ALUSrcA_int <= '1';
                ALUSrcB_int <= "10";
                ALUOp_int   <= "10"; -- from funct3/funct7

            when ALUWB =>
                RegWrite_int <= '1';
                ResultSrc_int <= "01";

            when Branch =>
                PCSrc_int    <= Zero;
                ALUSrcA_int  <= '1';
                ALUSrcB_int  <= "10";
                ALUOp_int    <= "01"; -- SUB
                PCWrite_int  <= '1';
        end case;
    end process;

end Behavioral;
