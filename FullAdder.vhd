library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           carry_in : in STD_LOGIC;
           sum : out STD_LOGIC;
           carry_out : out STD_LOGIC);
           
end FullAdder;

architecture Behavioral of FullAdder is

begin
    sum <= a XOR b XOR carry_in;
    carry_out <= (a AND b) OR (carry_in AND a) OR (carry_in AND b);
   
end Behavioral;
