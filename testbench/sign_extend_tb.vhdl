library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sign_extend_tb is
end sign_extend_tb;

architecture behavior of sign_extend_tb is

    component sign_extend
        Port (
            Instr   : in  std_logic_vector(31 downto 7);
            ImmSrc  : in  std_logic_vector(1 downto 0);
            ImmOp   : out std_logic_vector(31 downto 0)
        );
    end component;

    signal Instr   : std_logic_vector(31 downto 7);
    signal ImmSrc  : std_logic_vector(1 downto 0);
    signal ImmOp   : std_logic_vector(31 downto 0);

    -- Fonction pour l'affichage
    function to_hexstring(slv : std_logic_vector) return string is
        variable hex_string : string(1 to slv'length/4);
        variable temp_slv   : std_logic_vector(slv'length-1 downto 0) := slv;
        variable nibble     : std_logic_vector(3 downto 0);
    begin
        for i in 0 to (slv'length/4 - 1) loop
            nibble := temp_slv(temp_slv'left - i*4 downto temp_slv'left - i*4 - 3);
            case nibble is
                when "0000" => hex_string(i+1) := '0';
                when "0001" => hex_string(i+1) := '1';
                when "0010" => hex_string(i+1) := '2';
                when "0011" => hex_string(i+1) := '3';
                when "0100" => hex_string(i+1) := '4';
                when "0101" => hex_string(i+1) := '5';
                when "0110" => hex_string(i+1) := '6';
                when "0111" => hex_string(i+1) := '7';
                when "1000" => hex_string(i+1) := '8';
                when "1001" => hex_string(i+1) := '9';
                when "1010" => hex_string(i+1) := 'A';
                when "1011" => hex_string(i+1) := 'B';
                when "1100" => hex_string(i+1) := 'C';
                when "1101" => hex_string(i+1) := 'D';
                when "1110" => hex_string(i+1) := 'E';
                when "1111" => hex_string(i+1) := 'F';
                when others => hex_string(i+1) := 'X';
            end case;
        end loop;
        return hex_string;
    end function;

begin

    uut: sign_extend
        port map (
            Instr   => Instr,
            ImmSrc  => ImmSrc,
            ImmOp   => ImmOp
        );

    stim_proc: process
    begin
        report "==== Debut Test Sign Extend ====";

        -- I-type : Imm = 0x000
        Instr <= (others => '0');
        Instr(31 downto 20) <= x"000";
        ImmSrc <= "00";
        wait for 10 ns;
        report "I-type : " & to_hexstring(ImmOp);

        -- I-type : Imm = 0xFFF (-1 étendu)
        Instr(31 downto 20) <= x"FFF";
        ImmSrc <= "00";
        wait for 10 ns;
        report "I-type signe -1 : " & to_hexstring(ImmOp);

        -- S-type : Imm = 0x7F << 5 | 0x1F = 0x07FF
        Instr(31 downto 25) <= "0000000";
        Instr(11 downto 7)  <= "11111";
        ImmSrc <= "01";
        wait for 10 ns;
        report "S-type : " & to_hexstring(ImmOp);

        -- B-type : Imm = exemple (bits mélangés)
        Instr(31) <= '0';
        Instr(7)  <= '1';
        Instr(30 downto 25) <= "000001";
        Instr(11 downto 8)  <= "1111";
        ImmSrc <= "10";
        wait for 10 ns;
        report "B-type : " & to_hexstring(ImmOp);

        -- U-type : Imm = 0xFFFFF000
        Instr(31 downto 12) <= x"FFFFF";
        ImmSrc <= "11";
        wait for 10 ns;
        report "U-type : " & to_hexstring(ImmOp);

        report "==== Fin Test Sign Extend ====";
        wait;
    end process;

end behavior;
