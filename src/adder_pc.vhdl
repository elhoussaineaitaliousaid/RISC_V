library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_pc is
    Port (
        PCin  : in  std_logic_vector(31 downto 0);
        PCout : out std_logic_vector(31 downto 0)
    );
end adder_pc;

architecture Behavioral of adder_pc is
    signal PC_tmp : unsigned(31 downto 0);
begin
    PC_tmp <= unsigned(PCin) + 4;
    PCout <= std_logic_vector(PC_tmp);
end Behavioral;
