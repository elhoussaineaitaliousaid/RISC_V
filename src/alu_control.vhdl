library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_control is
    Port (
        ALUOp     : in  std_logic_vector(1 downto 0);
        Funct3    : in  std_logic_vector(2 downto 0);
        Funct7_5  : in  std_logic;  -- Bit 30 pour ADD/SUB
        ALUControl: out std_logic_vector(3 downto 0)
    );
end alu_control;

architecture Behavioral of alu_control is
begin
    process(ALUOp, Funct3, Funct7_5)
    begin
        case ALUOp is
            when "00" =>  -- lw / sw
                ALUControl <= "0000"; -- ADD

            when "01" =>  -- beq
                ALUControl <= "0001"; -- SUB

            when "10" =>  -- R-type instructions
                case Funct3 is
                    when "000" =>  -- ADD / SUB
                        if Funct7_5 = '0' then
                            ALUControl <= "0000"; -- ADD
                        else
                            ALUControl <= "0001"; -- SUB
                        end if;
                    when "111" =>
                        ALUControl <= "0010"; -- AND
                    when "110" =>
                        ALUControl <= "0011"; -- OR
                    when "100" =>
                        ALUControl <= "0100"; -- XOR
                    when "010" =>
                        ALUControl <= "0101"; -- SLT
                    when others =>
                        ALUControl <= "0000"; -- Default
                end case;

            when others =>
                ALUControl <= "0000"; -- Default
        end case;
    end process;
end Behavioral;
