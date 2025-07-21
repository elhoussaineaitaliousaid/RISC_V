library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_data_mem_tb is
end instr_data_mem_tb;

architecture behavior of instr_data_mem_tb is

    -- Composant à tester
    component instr_data_mem
        Port (
            clk   : in  std_logic;
            addr  : in  std_logic_vector(31 downto 0);
            we    : in  std_logic;
            WD    : in  std_logic_vector(31 downto 0);
            RD    : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signaux internes
    signal clk   : std_logic := '0';
    signal addr  : std_logic_vector(31 downto 0);
    signal we    : std_logic;
    signal WD    : std_logic_vector(31 downto 0);
    signal RD    : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instanciation du composant
    uut: instr_data_mem
        port map (
            clk  => clk,
            addr => addr,
            we   => we,
            WD   => WD,
            RD   => RD
        );

    -- Génération horloge
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimuli
    stim_proc: process
    begin
        report "Debut du test memoire";

        -- Ecrire 11111111 (hex) = 286331153 (dec) à l'adresse 0
        addr <= x"00000000";
        WD   <= x"11111111";
        we   <= '1';
        wait for clk_period;

        -- Ecrire 22222222 (hex) = 572662306 (dec) à l'adresse 4
        addr <= x"00000004";
        WD   <= x"22222222";
        wait for clk_period;

        we <= '0';

        -- Lire adresse 0
        addr <= x"00000000";
        wait for clk_period;
        report "Lecture @0x00 = " & integer'image(to_integer(unsigned(RD)));

        -- Lire adresse 4
        addr <= x"00000004";
        wait for clk_period;
        report "Lecture @0x04 = " & integer'image(to_integer(unsigned(RD)));

        wait for 20 ns;
        report "Fin du test memoire";
        wait;
    end process;

end behavior;
