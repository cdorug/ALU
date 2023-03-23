library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (63 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;  
           ALUOp: in STD_LOGIC_VECTOR(3 downto 0);
           STATE_IS: out STD_LOGIC_VECTOR(1 downto 0);
           result_alu : out STD_LOGIC_VECTOR (63 downto 0);
           RegA_LOW_test: out STD_LOGIC_VECTOR (31 downto 0);
           RegB_test: out STD_LOGIC_VECTOR (31 downto 0);
           B_Or_NotB_test: out STD_LOGIC_VECTOR (31 downto 0);
           mul_res_test: out STD_LOGIC_VECTOR(63 downto 0);
           state_mul_test: out std_logic_vector(1 downto 0);
           accumulator: out std_logic_vector(63 downto 0) );
end ALU;

architecture Behavioral of ALU is

component RippleCarryAdder
      Port(Operand_1 : in STD_LOGIC_VECTOR (31 downto 0);
           Operand_2 : in STD_LOGIC_VECTOR (31 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           Result : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Rotate
      Port(Operand: in std_logic_vector(31 downto 0);
           left_OR_right: in std_logic;
           RotationRes: out std_logic_vector(31 downto 0));
end component;

component LogicalUnit
      Port(LOperand_1 : in STD_LOGIC_VECTOR (31 downto 0);
           LOperand_2 : in STD_LOGIC_VECTOR (31 downto 0);
           LogicalOpCtrl : in STD_LOGIC_VECTOR (1 downto 0);
           LogicalOpRes : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Multiplier
    Port ( Multiplicand : in STD_LOGIC_VECTOR (31 downto 0);
           Multiplier : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           Start: in STD_LOGIC;
           Finished: out STD_LOGIC;
           Product: out STD_LOGIC_VECTOR(63 downto 0);
           WHAT_STATE: out STD_LOGIC_VECTOR(1 downto 0);
           CNT: out STD_LOGIC_VECTOR(5 downto 0));
end component;

-- signals
signal Acc_A: std_logic_vector(31 downto 0);
signal Acc_B: std_logic_vector(31 downto 0);
signal Tmp_A: std_logic_vector(31 downto 0);
signal result_tmp: std_logic_vector(63 downto 0) := X"0000000000000000";
signal RippleCarryAdderRes: std_logic_vector(31 downto 0) := X"00000000";
signal LogicalOpResult: std_logic_vector(31 downto 0);
signal RotationResult: std_logic_vector(31 downto 0);
signal AdderCout: std_logic;
signal B_Or_NotB: std_logic_vector(31 downto 0);
signal mul_OR_div: STD_LOGIC;
signal l_OR_r: STD_LOGIC;
signal logicalCtrl: STD_LOGIC_VECTOR (1 downto 0);
signal addOrSub: STD_LOGIC;
signal mainCtrl: STD_LOGIC_VECTOR (1 downto 0);
signal RegB: STD_LOGIC_VECTOR(31 downto 0);
signal RegA_LOW: STD_LOGIC_VECTOR(31 downto 0);
signal RegA_HIGH: STD_LOGIC_VECTOR(31 downto 0);
signal A_OR_Res: STD_LOGIC := '0';
signal InputA_MUXed_LOW: STD_LOGIC_VECTOR(31 downto 0);
signal InputA_MUXed_HIGH: STD_LOGIC_VECTOR(31 downto 0);
-- for mul 
signal Finished_mul : STD_LOGIC;
signal MulDivRes: std_logic_vector(63 downto 0);
signal State_mul : std_logic_vector(1 downto 0);
signal Counter_mul : std_logic_vector(5 downto 0) := "000000";
signal Start_mul : std_logic := '0';
--
type STATE_T is (READ, EX, WB);
signal CURR_STATE: STATE_T := READ;
--

signal COUNT_MUL : STD_LOGIC_VECTOR(6 downto 0) := "0000000";

begin
    
    InputA_MUX: process(result_tmp, A_OR_Res)
    begin
        case A_OR_Res is
            when '0' => InputA_MUXed_LOW <= A(31 downto 0);
                        InputA_MUXed_HIGH <= A(63 downto 32);
            when '1' => InputA_MUXed_LOW <= result_tmp(31 downto 0);
                        InputA_MUXed_HIGH <= result_tmp(63 downto 32);
            when others =>
        end case;
    end process;
    
    accumulator <= InputA_MUXed_HIGH & InputA_MUXed_LOW;
    
    RegisterA_LOW: process(clk)
    begin
        if rising_edge(clk) then
            RegA_LOW <= InputA_MUXed_LOW;
        end if;
    end process;
    
    RegisterA_HIGH: process(clk)
    begin
        if rising_edge(clk) then
            RegA_HIGH <= InputA_MUXed_HIGH;
        end if;
    end process;    
    
    RegisterB: process(clk)
    begin
        if rising_edge(clk) then
            RegB <= B;
        end if;
    end process;
    
    ALUCtrl: process(clk)
    begin
       if rising_edge(clk) then
            if CURR_STATE = READ then
                A_OR_Res <= '0';
                CURR_STATE <= EX;
                STATE_IS <= "01";
            elsif CURR_STATE = EX then
                Start_mul <= '1';
                case ALUOp is
                        when "0000" => addOrSub <= '0';     -- ADD
                                       mainCtrl <= "00";    -- ADD
                                       CURR_STATE <= WB;
                                       A_OR_Res <= '1';
                                       STATE_IS <= "11";
                        when "0001" => addOrSub <= '1';     -- SUB
                                       mainCtrl <= "00";    -- SUB
                                       CURR_STATE <= WB;
                                       A_OR_Res <= '1';
                                       STATE_IS <= "11";
                        when "0010" => logicalCtrl <= "00"; -- AND
                                       mainCtrl <= "01";    -- AND
                                       CURR_STATE <= WB;
                                       A_OR_Res <= '1';
                                       STATE_IS <= "11";
                        when "0011" => logicalCtrl <= "01"; -- OR
                                       mainCtrl <= "01";    -- OR
                                       CURR_STATE <= WB;
                                       A_OR_Res <= '1';
                                       STATE_IS <= "11";
                        when "0100" => logicalCtrl <= "10"; -- NOT
                                       mainCtrl <= "01";    -- NOT
                                       CURR_STATE <= WB;
                                       A_OR_Res <= '1';
                                       STATE_IS <= "11";
                        when "0101" => l_OR_r <= '0';       -- ROTATE LEFT
                                       mainCtrl <= "10";    -- ROTATE LEFT
                                       CURR_STATE <= WB;
                                       A_OR_Res <= '1';
                                       STATE_IS <= "11";
                        when "0110" => l_OR_r <= '1';       -- ROTATE RIGHT
                                       mainCtrl <= "10";    -- ROTATE RIGHT
                                       CURR_STATE <= WB;
                                       A_OR_Res <= '1';
                                       STATE_IS <= "11";
                        when "0111" =>                      -- MUL
                            --mainCtrl <= "11";    
                            if Counter_mul = "0100000" then
                                mainCtrl <= "11";    
                                CURR_STATE <= WB;
                                A_OR_Res <= '1';
                                STATE_IS <= "11";
                            else 
                                CURR_STATE <= EX;
                            end if;     
                        when others =>
                end case;
            elsif CURR_STATE = WB then
                CURR_STATE <= READ;
                STATE_IS <= "00";
            end if;
         end if;
    end process;
    
    B_Or_NegatedB: process(addOrSub, RegB)
    begin
        case addOrSub is
            when '0' => B_Or_NotB <= RegB;
            when '1' => B_Or_NotB <= NOT RegB;
            when others =>
        end case;
    end process;
    
    RCAdder: RippleCarryAdder port map(
        Operand_1 => RegA_LOW,
        Operand_2 => B_Or_NotB,
        Cin => addOrSub,
        Cout => AdderCout,
        Result => RippleCarryAdderRes);
        
    RotateUnit: Rotate port map(
        Operand => RegA_LOW,
        left_OR_right => l_OR_r,
        RotationRes => RotationResult);
  
    LogicalOpUnit: LogicalUnit port map(
        LOperand_1 => RegA_LOW,
        LOperand_2 => RegB,
        LogicalOpCtrl => logicalCtrl,
        LogicalOpRes => LogicalOpResult);
   
    MulUnit: Multiplier port map(
        Multiplicand => RegA_LOW,
        Multiplier   => RegB,
        clk          => clk,
        Start        => Start_mul,
        WHAT_STATE   => State_mul,
        Finished     => Finished_mul,
        Product      => MulDivRes,
        CNT          => Counter_mul);
        
    
    MainCtrlMUX: process(mainCtrl, RippleCarryAdderRes, LogicalOpResult, RotationResult, MulDivRes)
    begin
        case mainCtrl is
            when "00" => result_tmp <= X"00000000" & RippleCarryAdderRes;
            when "01" => result_tmp <= X"00000000" & LogicalOpResult;
            when "10" => result_tmp <= X"00000000" & RotationResult;
            when "11" => result_tmp <= MulDivRes;
            when others =>
        end case;
    end process;
      
    result_alu <= result_tmp;
    
    
    -- for testing
    RegA_LOW_test <= RegA_LOW;
    RegB_test <= RegB;
    B_Or_NotB_test <= B_Or_NotB;
    mul_res_test <= MulDivRes;
    state_mul_test <= State_mul;
    --
    
end Behavioral;
