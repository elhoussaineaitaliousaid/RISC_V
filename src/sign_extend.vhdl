library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sign_extend is
    Port (
        Instr   : in  std_logic_vector(31 downto 7);
        ImmSrc  : in  std_logic_vector(1 downto 0);
        ImmOp   : out std_logic_vector(31 downto 0)
    );
end sign_extend;

architecture Behavioral of sign_extend is
    signal imm : signed(31 downto 0);
begin
    process(Instr, ImmSrc)
    begin
        case ImmSrc is
            -- I-type : instr[31:20]
            when "00" =>
                imm <= resize(signed(Instr(31 downto 20)), 32);
            -- S-type : instr[31:25] & instr[11:7]
            when "01" =>
                imm <= resize(signed(Instr(31 downto 25) & Instr(11 downto 7)), 32);
            -- B-type : branch offset (concat bits)
            when "10" =>
                imm <= resize(signed(Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & '0'), 32);
            -- U-type : instr[31:12] << 12
            when others =>
                imm <= signed(Instr(31 downto 12) & x"000");
        end case;
    end process;

    ImmOp <= std_logic_vector(imm);
end Behavioral;
