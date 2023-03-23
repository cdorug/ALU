library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std;

entity Rotate is
    Port (Operand: in std_logic_vector(31 downto 0);
          left_OR_right: in std_logic;
          RotationRes: out std_logic_vector(31 downto 0)
          );
end Rotate;

architecture Behavioral of Rotate is
signal RotationRes_temp: std_logic_vector(31 downto 0);
signal MSB: std_logic;
signal LSB: std_logic;
begin

    MSB <= Operand(31);
    RotationMUX: process(Operand, left_OR_right)
    begin
        case left_OR_right is
            when '0' => RotationRes_temp <= Operand(30 downto 0) & Operand(31); -- left
            when '1' => RotationRes_temp <= Operand(0) & Operand(31 downto 1); -- right
            when others =>
        end case;
    end process;
    
    RotationRes <= RotationRes_temp;

end Behavioral;
