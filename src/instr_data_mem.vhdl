library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_data_mem is
    Port (
        clk  : in  std_logic;
        addr : in  
        std_logic_vector(31 downto 0);
        we   : in  std_logic;
        WD   : in  std_logic_vector(31 downto 0);
        RD   : out std_logic_vector(31 downto 0)
    );
end instr_data_mem;

architecture Behavioral of instr_data_mem is

    type mem_type is array (0 to 255) of std_logic_vector(31 downto 0);
    signal mem : mem_type := (
        0 => x"00400093",  -- addi x1, x0, 4
        1 => x"00800113",  -- addi x2, x0, 8
        2 => x"0020A023",  -- sw x2, 0(x1)
        3 => x"0000A183",  -- lw x3, 0(x1)
        4 => x"00218263",  -- beq x3, x2, -8  (revient à 0x08)
        5 => x"00100213",  -- addi x4, x0, 1
        others => (others => '0')
    );

    signal addrindex : integer range 0 to 255;

begin

    addrindex <= to_integer(unsigned(addr(9 downto 2))); -- Addr alignée sur 4 bytes

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                mem(addrindex) <= WD;
            end if;
        end if;
    end process;

    RD <= mem(addrindex);

end Behavioral;
