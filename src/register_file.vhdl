library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port (
        clk     : in  std_logic;
        A1      : in  std_logic_vector(4 downto 0);  -- rs1
        A2      : in  std_logic_vector(4 downto 0);  -- rs2
        A3      : in  std_logic_vector(4 downto 0);  -- rd
        WD3     : in  std_logic_vector(31 downto 0); -- Write Data
        WE3     : in  std_logic;                     -- Write Enable (RegWrite)
        RD1     : out std_logic_vector(31 downto 0); -- Read Data 1
        RD2     : out std_logic_vector(31 downto 0)  -- Read Data 2
    );
end register_file;

architecture Behavioral of register_file is
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin

    -- Lecture combinatoire
    RD1 <= regs(to_integer(unsigned(A1)));
    RD2 <= regs(to_integer(unsigned(A2)));

    -- Écriture synchrone
    process(clk)
    begin
        if rising_edge(clk) then
            if WE3 = '1' and A3 /= "00000" then
                regs(to_integer(unsigned(A3))) <= WD3;
            end if;
        end if;
    end process;

end Behavioral;
