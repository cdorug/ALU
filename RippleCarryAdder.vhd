library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RippleCarryAdder is
    Port ( Operand_1 : in STD_LOGIC_VECTOR (31 downto 0);
           Operand_2 : in STD_LOGIC_VECTOR (31 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           Result : out STD_LOGIC_VECTOR (31 downto 0));
end RippleCarryAdder;

architecture Behavioral of RippleCarryAdder is

component FullAdder
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           carry_in : in STD_LOGIC;
           sum : out STD_LOGIC;
           carry_out : out STD_LOGIC);
end component;

-- signals
signal cin1, cin2, cin3, cin4, cin5, cin6, cin7, cin8, cin9, cin10, cin11, cin12,
cin13, cin14, cin15, cin16, cin17, cin18, cin19, cin20, cin21, cin22, cin23, cin24,
cin25, cin26, cin27, cin28, cin29, cin30, cin31: std_logic;

begin

FA0: FullAdder port map(Operand_1(0), Operand_2(0), Cin, Result(0), cin1);
FA1: FullAdder port map(Operand_1(1), Operand_2(1), cin1, Result(1), cin2);
FA2: FullAdder port map(Operand_1(2), Operand_2(2), cin2, Result(2), cin3);
FA3: FullAdder port map(Operand_1(3), Operand_2(3), cin3, Result(3), cin4);
FA4: FullAdder port map(Operand_1(4), Operand_2(4), cin4, Result(4), cin5);
FA5: FullAdder port map(Operand_1(5), Operand_2(5), cin5, Result(5), cin6);
FA6: FullAdder port map(Operand_1(6), Operand_2(6), cin6, Result(6), cin7);
FA7: FullAdder port map(Operand_1(7), Operand_2(7), cin7, Result(7), cin8);
FA8: FullAdder port map(Operand_1(8), Operand_2(8), cin8, Result(8), cin9);
FA9: FullAdder port map(Operand_1(9), Operand_2(9), cin9, Result(9), cin10);
FA10: FullAdder port map(Operand_1(10), Operand_2(10), cin10, Result(10), cin11);
FA11: FullAdder port map(Operand_1(11), Operand_2(11), cin11, Result(11), cin12);
FA12: FullAdder port map(Operand_1(12), Operand_2(12), cin12, Result(12), cin13);
FA13: FullAdder port map(Operand_1(13), Operand_2(13), cin13, Result(13), cin14);
FA14: FullAdder port map(Operand_1(14), Operand_2(14), cin14, Result(14), cin15);
FA15: FullAdder port map(Operand_1(15), Operand_2(15), cin15, Result(15), cin16);
FA16: FullAdder port map(Operand_1(16), Operand_2(16), cin16, Result(16), cin17);
FA17: FullAdder port map(Operand_1(17), Operand_2(17), cin17, Result(17), cin18);
FA18: FullAdder port map(Operand_1(18), Operand_2(18), cin18, Result(18), cin19);
FA19: FullAdder port map(Operand_1(19), Operand_2(19), cin19, Result(19), cin20);
FA20: FullAdder port map(Operand_1(20), Operand_2(20), cin20, Result(20), cin21);
FA21: FullAdder port map(Operand_1(21), Operand_2(21), cin21, Result(21), cin22);
FA22: FullAdder port map(Operand_1(22), Operand_2(22), cin22, Result(22), cin23);
FA23: FullAdder port map(Operand_1(23), Operand_2(23), cin23, Result(23), cin24);
FA24: FullAdder port map(Operand_1(24), Operand_2(24), cin24, Result(24), cin25);
FA25: FullAdder port map(Operand_1(25), Operand_2(25), cin25, Result(25), cin26);
FA26: FullAdder port map(Operand_1(26), Operand_2(26), cin26, Result(26), cin27);
FA27: FullAdder port map(Operand_1(27), Operand_2(27), cin27, Result(27), cin28);
FA28: FullAdder port map(Operand_1(28), Operand_2(28), cin28, Result(28), cin29);
FA29: FullAdder port map(Operand_1(29), Operand_2(29), cin29, Result(29), cin30);
FA30: FullAdder port map(Operand_1(30), Operand_2(30), cin30, Result(30), cin31);
FA31: FullAdder port map(Operand_1(31), Operand_2(31), cin31, Result(31), Cout);

end Behavioral;
