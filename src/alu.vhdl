library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        A           : in  std_logic_vector(31 downto 0);
        B           : in  std_logic_vector(31 downto 0);
        ALUControl  : in  std_logic_vector(3 downto 0);  -- 4 bits pour les opérations
        Result      : out std_logic_vector(31 downto 0);
        Zero        : out std_logic
    );
end alu;

architecture Behavioral of alu is
    signal A_s, B_s : signed(31 downto 0);
    signal result_s : signed(31 downto 0);
begin

    A_s <= signed(A);
    B_s <= signed(B);

    process(A_s, B_s, ALUControl)
    begin
        case ALUControl is
            when "0000" => result_s <= A_s + B_s;             -- ADD
            when "0001" => result_s <= A_s - B_s;             -- SUB
            when "0010" => result_s <= A_s and B_s;           -- AND
            when "0011" => result_s <= A_s or B_s;            -- OR
            when "0100" => result_s <= A_s xor B_s;           -- XOR
            when "0101" =>  -- SLT
                if A_s < B_s then
                    result_s <= (others => '0'); result_s(0) <= '1';
                else
                    result_s <= (others => '0');
                end if;
            when others =>
                result_s <= (others => '0');
        end case;
    end process;

    Result <= std_logic_vector(result_s);
    Zero <= '1' when result_s = 0 else '0';

end Behavioral;
