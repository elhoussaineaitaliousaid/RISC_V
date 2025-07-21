library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_pc_tb is
end adder_pc_tb;

architecture behavior of adder_pc_tb is

    component adder_pc
        Port (
            PCin  : in  std_logic_vector(31 downto 0);
            PCout : out std_logic_vector(31 downto 0)
        );
    end component;

    signal PCin, PCout : std_logic_vector(31 downto 0);

begin

    uut: adder_pc
        port map (
            PCin  => PCin,
            PCout => PCout
        );

    stim_proc: process
    begin
        report "==== Debut Test Adder PC + 4 ====";

        PCin <= x"00000000";
        wait for 10 ns;
        report "PCin = 0x00000000, PCout = " & integer'image(to_integer(unsigned(PCout)));

        PCin <= x"00000004";
        wait for 10 ns;
        report "PCin = 0x00000004, PCout = " & integer'image(to_integer(unsigned(PCout)));

        PCin <= x"FFFFFFFC";
        wait for 10 ns;
        report "PCin = 0xFFFFFFFC, PCout = " & integer'image(to_integer(unsigned(PCout)));

        report "==== Fin Test Adder PC + 4 ====";
        wait;
    end process;

end behavior;
