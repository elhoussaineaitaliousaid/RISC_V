library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc_tb is
end pc_tb;

architecture behavior of pc_tb is

    component pc
        Port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            PCWrite : in  std_logic;
            PCin    : in  std_logic_vector(31 downto 0);
            PCout   : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk, reset, PCWrite : std_logic := '0';
    signal PCin, PCout : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: pc
        port map (
            clk     => clk,
            reset   => reset,
            PCWrite => PCWrite,
            PCin    => PCin,
            PCout   => PCout
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    stim_proc: process
    begin
        report "==== Debut Test PC ====";

        -- Reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- PC = 0x00000004
        PCin <= x"00000004";
        PCWrite <= '1';
        wait for clk_period;

        -- PC = 0x00000008
        PCin <= x"00000008";
        wait for clk_period;

        -- Pas d'écriture PCWrite = 0
        PCWrite <= '0';
        PCin <= x"DEADBEEF";
        wait for clk_period;

        report "PCout = " & integer'image(to_integer(unsigned(PCout)));

        report "==== Fin Test PC ====";
        wait;
    end process;

end behavior;
