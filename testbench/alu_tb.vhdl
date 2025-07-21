library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end alu_tb;

architecture behavior of alu_tb is

    -- Composant à tester
    component alu
        Port (
            A           : in  std_logic_vector(31 downto 0);
            B           : in  std_logic_vector(31 downto 0);
            ALUControl  : in  std_logic_vector(3 downto 0);
            Result      : out std_logic_vector(31 downto 0);
            Zero        : out std_logic
        );
    end component;

    -- Signaux internes
    signal A, B        : std_logic_vector(31 downto 0);
    signal ALUControl  : std_logic_vector(3 downto 0);
    signal Result      : std_logic_vector(31 downto 0);
    signal Zero        : std_logic;

begin

    -- Instanciation de l'ALU
    uut: alu
        port map (
            A           => A,
            B           => B,
            ALUControl  => ALUControl,
            Result      => Result,
            Zero        => Zero
        );

    -- Processus de test
    stim_proc: process
    begin
        report "=== Début du test ALU ===";

        -- ADD : 10 + 20 = 30
        A <= std_logic_vector(to_signed(10, 32));
        B <= std_logic_vector(to_signed(20, 32));
        ALUControl <= "0000";
        wait for 10 ns;
        report "ADD (10+20) = " & integer'image(to_integer(signed(Result)));

        -- SUB : 50 - 20 = 30
        A <= std_logic_vector(to_signed(50, 32));
        B <= std_logic_vector(to_signed(20, 32));
        ALUControl <= "0001";
        wait for 10 ns;
        report "SUB (50-20) = " & integer'image(to_integer(signed(Result)));

        -- AND : 0x0F0F & 0x00FF = 0x000F
        A <= x"00000F0F";
        B <= x"000000FF";
        ALUControl <= "0010";
        wait for 10 ns;
        report "AND = " & integer'image(to_integer(unsigned(Result)));

        -- OR : 0x0F00 | 0x000F = 0x0F0F
        A <= x"00000F00";
        B <= x"0000000F";
        ALUControl <= "0011";
        wait for 10 ns;
        report "OR = " & integer'image(to_integer(unsigned(Result)));

        -- XOR : 5 ^ 3 = 6
        A <= std_logic_vector(to_signed(5, 32));
        B <= std_logic_vector(to_signed(3, 32));
        ALUControl <= "0100";
        wait for 10 ns;
        report "XOR (5 xor 3) = " & integer'image(to_integer(signed(Result)));

        -- SLT : 5 < 7 = 1
        A <= std_logic_vector(to_signed(5, 32));
        B <= std_logic_vector(to_signed(7, 32));
        ALUControl <= "0101";
        wait for 10 ns;
        report "SLT (5 < 7) = " & integer'image(to_integer(signed(Result)));

        -- SLT : 8 < 3 = 0
        A <= std_logic_vector(to_signed(8, 32));
        B <= std_logic_vector(to_signed(3, 32));
        ALUControl <= "0101";
        wait for 10 ns;
        report "SLT (8 < 3) = " & integer'image(to_integer(signed(Result)));

        -- Test Zero
        A <= std_logic_vector(to_signed(10, 32));
        B <= std_logic_vector(to_signed(10, 32));
        ALUControl <= "0001";  -- SUB
        wait for 10 ns;
        report "SUB (10 - 10) = " & integer'image(to_integer(signed(Result))) &
               " / Zero = " & std_logic'image(Zero);

        report "=== Fin du test ALU ===";
        wait;
    end process;

end behavior;
