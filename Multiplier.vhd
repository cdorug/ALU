library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Multiplier is
    Port ( Multiplicand : in STD_LOGIC_VECTOR (31 downto 0);
           Multiplier : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           Start: in STD_LOGIC;
           Finished: out STD_LOGIC;
           Product: out STD_LOGIC_VECTOR(63 downto 0);
           WHAT_STATE: out STD_LOGIC_VECTOR(1 downto 0);
           CNT: out STD_LOGIC_VECTOR(5 downto 0));
end Multiplier;

architecture Behavioral of Multiplier is

type STATE_T is (INIT, ADD, SHIFT, HALT);
signal CURRENT_STATE: STATE_T := HALT;
signal A: STD_LOGIC_VECTOR(32 downto 0) := "000000000000000000000000000000000";
signal M: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal Q: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal sum_tmp: STD_LOGIC_VECTOR(4 downto 0) := "00000";
signal COUNT: STD_LOGIC_VECTOR(5 downto 0) := "000000";

begin

    Transitions: process(clk)
    begin
    if rising_edge(clk) then
        case CURRENT_STATE is
            when INIT => 
                if Q(0) = '0' then
                    CURRENT_STATE <= SHIFT;
                    WHAT_STATE <= "10";
                    Q <= A(0) & Q(31 downto 1);
                    A <= '0' & A(32 downto 1);
                    COUNT <= COUNT + 1;
                elsif Q(0) = '1' then
                    CURRENT_STATE <= ADD;
                    WHAT_STATE <= "01";
                    A <= A + M;
                end if;  
            when ADD =>
                CURRENT_STATE <= SHIFT;
                WHAT_STATE <= "10";
                Q <= A(0) & Q(31 downto 1);
                A <= '0' & A(32 downto 1);
                COUNT <= COUNT + 1;
            when SHIFT =>
                if COUNT = "100000" then
                    CURRENT_STATE <= HALT;
                    WHAT_STATE <= "11";
                    FINISHED <= '1';
                else
                    if Q(0) = '0' then
                        CURRENT_STATE <= SHIFT;
                        WHAT_STATE <= "10";
                        Q <= A(0) & Q(31 downto 1);
                        A <= '0' & A(32 downto 1);
                        COUNT <= COUNT + 1;
                    elsif Q(0) = '1' then
                        CURRENT_STATE <= ADD;
                        WHAT_STATE <= "01";
                        A <= A + M;
                    end if; 
                end if;
            when HALT =>
                if Start = '1' then
                    CURRENT_STATE <= INIT;
                    WHAT_STATE <= "00";
                    A <= "000000000000000000000000000000000";
                    M <= Multiplicand;
                    Q <= Multiplier;
                    COUNT <= "000000"; 
                else 
                    CURRENT_STATE <= HALT;
                    WHAT_STATE <= "11";
                    FINISHED <= '1';
                end if;
        end case;
    end if;
    end process;
    
    Product <= A(31 downto 0) & Q;
    CNT <= COUNT;
    
end Behavioral;
