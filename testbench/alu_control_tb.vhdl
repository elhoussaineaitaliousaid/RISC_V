library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_control_tb is
end alu_control_tb;

architecture behavior of alu_control_tb is

    component alu_control
        Port (
            ALUOp      : in  std_logic_vector(1 downto 0);
            Funct3     : in  std_logic_vector(2 downto 0);
            Funct7_5   : in  std_logic;
            ALUControl : out std_logic_vector(3 downto 0)
        );
    end component;

    signal ALUOp      : std_logic_vector(1 downto 0);
    signal Funct3     : std_logic_vector(2 downto 0);
    signal Funct7_5   : std_logic;
    signal ALUControl : std_logic_vector(3 downto 0);

    -- Fonction pour afficher un std_logic_vector comme une string
    function slv_to_string(slv : std_logic_vector) return string is
        variable result : string(1 to slv'length);
    begin
        for i in 0 to slv'length - 1 loop
            result(i+1) := character'VALUE(std_ulogic'IMAGE(slv(slv'left - i)));
        end loop;
        return result;
    end function;

begin

    uut: alu_control
        port map (
            ALUOp      => ALUOp,
            Funct3     => Funct3,
            Funct7_5   => Funct7_5,
            ALUControl => ALUControl
        );

    stim_proc: process
    begin
        report  " Debut Test ALU Control ";

        -- lw/sw => ADD
        ALUOp <= "00";
        Funct3 <= "000";
        Funct7_5 <= '0';
        wait for 10 ns;
        report "ALUOp=00 (lw/sw) : ALUControl = " & slv_to_string(ALUControl);

        -- beq => SUB
        ALUOp <= "01";
        Funct3 <= "000";
        Funct7_5 <= '0';
        wait for 10 ns;
        report "ALUOp=01 (beq) : ALUControl = " & slv_to_string(ALUControl);

        -- R-type : ADD
        ALUOp <= "10";
        Funct3 <= "000";
        Funct7_5 <= '0';
        wait for 10 ns;
        report "R-type ADD : ALUControl = " & slv_to_string(ALUControl);

        -- R-type : SUB
        ALUOp <= "10";
        Funct3 <= "000";
        Funct7_5 <= '1';
        wait for 10 ns;
        report "R-type SUB : ALUControl = " & slv_to_string(ALUControl);

        -- AND
        ALUOp <= "10";
        Funct3 <= "111";
        Funct7_5 <= '0';
        wait for 10 ns;
        report "R-type AND : ALUControl = " & slv_to_string(ALUControl);

        -- OR
        ALUOp <= "10";
        Funct3 <= "110";
        Funct7_5 <= '0';
        wait for 10 ns;
        report "R-type OR : ALUControl = " & slv_to_string(ALUControl);

        -- XOR
        ALUOp <= "10";
        Funct3 <= "100";
        Funct7_5 <= '0';
        wait for 10 ns;
        report "R-type XOR : ALUControl = " & slv_to_string(ALUControl);

        -- SLT
        ALUOp <= "10";
        Funct3 <= "010";
        Funct7_5 <= '0';
        wait for 10 ns;
        report "R-type SLT : ALUControl = " & slv_to_string(ALUControl);

        report " Fin Test ALU Control ";
        wait;
    end process;

end behavior;
