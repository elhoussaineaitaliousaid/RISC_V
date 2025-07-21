library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_tb is
end mux4_tb;

architecture behavior of mux4_tb is

    component mux4
        Port (
            A, B, C, D : in  std_logic_vector(31 downto 0);
            Sel        : in  std_logic_vector(1 downto 0);
            Y          : out std_logic_vector(31 downto 0)
        );
    end component;

    signal A, B, C, D, Y : std_logic_vector(31 downto 0);
    signal Sel : std_logic_vector(1 downto 0);

    -- Fonction to_hexstring pour afficher en HEXA
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
    uut: mux4
        port map (
            A   => A,
            B   => B,
            C   => C,
            D   => D,
            Sel => Sel,
            Y   => Y
        );

    stim_proc: process
    begin
        report "==== Test MUX 4:1 ====";

        A <= x"AAAAAAAA";
        B <= x"BBBBBBBB";
        C <= x"CCCCCCCC";
        D <= x"DDDDDDDD";

        Sel <= "00";
        wait for 10 ns;
        report "Sel = 00, Y = " & to_hexstring(Y);

        Sel <= "01";
        wait for 10 ns;
        report "Sel = 01, Y = " & to_hexstring(Y);

        Sel <= "10";
        wait for 10 ns;
        report "Sel = 10, Y = " & to_hexstring(Y);

        Sel <= "11";
        wait for 10 ns;
        report "Sel = 11, Y = " & to_hexstring(Y);

        report "==== Fin Test MUX 4:1 ====";
        wait;
    end process;

end behavior;
