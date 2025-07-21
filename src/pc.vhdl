library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        PCWrite : in  std_logic;
        PCin   : in  std_logic_vector(31 downto 0);
        PCout  : out std_logic_vector(31 downto 0)
    );
end pc;

architecture Behavioral of pc is
    signal PC_reg : std_logic_vector(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            PC_reg <= (others => '0');
        elsif rising_edge(clk) then
            if PCWrite = '1' then
                PC_reg <= PCin;
            end if;
        end if;
    end process;

    PCout <= PC_reg;
end Behavioral;
