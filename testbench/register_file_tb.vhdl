library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
end register_file;

architecture behavior of register_file is

    -- Composant à tester
    component regfile
        Port (
            clk     : in  std_logic;
            A1      : in  std_logic_vector(4 downto 0);
            A2      : in  std_logic_vector(4 downto 0);
            A3      : in  std_logic_vector(4 downto 0);
            WD3     : in  std_logic_vector(31 downto 0);
            WE3     : in  std_logic;
            RD1     : out std_logic_vector(31 downto 0);
            RD2     : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signaux internes
    signal clk    : std_logic := '0';
    signal A1, A2, A3 : std_logic_vector(4 downto 0);
    signal WD3    : std_logic_vector(31 downto 0);
    signal WE3    : std_logic;
    signal RD1, RD2 : std_logic_vector(31 downto 0);

    -- Horloge de simulation
    constant clk_period : time := 10 ns;

begin

    -- Instanciation du Register File
    uut: regfile
        port map (
            clk  => clk,
            A1   => A1,
            A2   => A2,
            A3   => A3,
            WD3  => WD3,
            WE3  => WE3,
            RD1  => RD1,
            RD2  => RD2
        );

    -- Génération de l'horloge
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimuli
    stim_proc: process
    begin
        report "Début du test du Register File";

        -- Écrire 42 dans x3
        A3  <= "00011";  -- x3
        WD3 <= x"0000002A";
        WE3 <= '1';
        wait for clk_period;

        -- Lire depuis x3
        A1 <= "00011";  -- rs1 = x3
        A2 <= "00011";  -- rs2 = x3
        WE3 <= '0';
        wait for clk_period;
        report "Lecture de x3 : RD1=" & integer'image(to_integer(signed(RD1)));

        -- Écrire 100 dans x0 (devrait être ignoré)
        A3  <= "00000";  -- x0
        WD3 <= x"00000064";
        WE3 <= '1';
        wait for clk_period;

        -- Lire depuis x0
        A1 <= "00000";  -- x0
        WE3 <= '0';
        wait for clk_period;
        report "Lecture de x0 (doit être 0) : RD1=" & integer'image(to_integer(signed(RD1)));

        -- Écrire 77 dans x10
        A3 <= "01010";  -- x10
        WD3 <= x"0000004D";
        WE3 <= '1';
        wait for clk_period;

        -- Lire x10 et x3 ensemble
        A1 <= "01010";  -- x10
        A2 <= "00011";  -- x3
        WE3 <= '0';
        wait for clk_period;
        report "Lecture de x10 : RD1=" & integer'image(to_integer(signed(RD1)));
        report "Lecture de x3 : RD2=" & integer'image(to_integer(signed(RD2)));

        wait for 50 ns;
        report "Fin du test du Register File";
        wait;
    end process;

end behavior;
