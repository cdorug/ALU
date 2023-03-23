library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LogicalUnit is
    Port ( LOperand_1 : in STD_LOGIC_VECTOR (31 downto 0);
           LOperand_2 : in STD_LOGIC_VECTOR (31 downto 0);
           LogicalOpCtrl : in STD_LOGIC_VECTOR (1 downto 0);
           LogicalOpRes : out STD_LOGIC_VECTOR (31 downto 0));
end LogicalUnit;

architecture Behavioral of LogicalUnit is

-- signals
signal LogicalOpResTemp: std_logic_vector(31 downto 0);

begin
    LogicalMUX: process(LogicalOpCtrl, LOperand_1, LOperand_2)
    begin
        case LogicalOpCtrl is
            when "00" => LogicalOpResTemp <= LOperand_1 AND LOperand_2; -- AND
            when "01" => LogicalOpResTemp <= LOperand_1 OR LOperand_2; -- OR
            when "10" => LogicalOpResTemp <= NOT LOperand_1; -- NOT
            when others => 
        end case;
    end process;

    LogicalOpRes <= LogicalOpResTemp;
    
end Behavioral;
