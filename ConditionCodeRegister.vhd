library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ConditionCodeRegister is
    Port (
        clk       : in  STD_LOGIC;       -- Clock signal
        rst       : in  STD_LOGIC;       -- Reset signal (active high)
		  cr_en     : in std_logic;
        carry_in  : in  STD_LOGIC;       -- Carry flag input
        zero_in   : in  STD_LOGIC;       -- Zero flag input
		  condition : out std_logic_vector(1 downto 0)
    );
end ConditionCodeRegister;

architecture Behavioral of ConditionCodeRegister is
    signal carry_flag : STD_LOGIC := '0';
    signal zero_flag  : STD_LOGIC := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then  -- Reset flags to 0
            carry_flag <= '0';
            zero_flag  <= '0';
        elsif rising_edge(clk) then
            if cr_en = '1' then  -- Update flags only if enable is active
                carry_flag <= carry_in;
                zero_flag  <= zero_in;
            end if;
        end if;
    end process;

    -- Assign the internal signals to the outputs
    condition <= carry_flag & zero_flag;

end Behavioral;