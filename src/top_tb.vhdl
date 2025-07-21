library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
end top_tb;

architecture behavior of top_tb is

    component top
        Port (
            clk, reset : in std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    constant clk_period : time := 10 ns;

begin
    uut: top
        port map (
            clk   => clk,
            reset => reset
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Reset + Stimulus process
    stim_proc: process
    begin
        report "==== Début Simulation CPU ====";
        
        -- Mettre reset actif au début
        reset <= '1';
        wait for 20 ns;    -- Laisse 2 cycles d'horloge minimum sous reset

        -- Désactive reset
        reset <= '0';
        wait for 500 ns;

        report "==== Fin Simulation CPU ====";
        wait;
    end process;

end behavior;
