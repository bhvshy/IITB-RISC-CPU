library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity general_mux is
    generic (
        number_of_bits : integer := 16;  -- Width of each input
        number_of_select_lines : integer := 3  -- Determines the number of inputs (2^select lines)
    );
    port (
        inputs : in std_logic_vector(number_of_bits - 1 downto 0) 
            array (0 to 2**number_of_select_lines - 1);  -- Array of input vectors
        sel : in std_logic_vector(number_of_select_lines - 1 downto 0);  -- Select lines
        Y : out std_logic_vector(number_of_bits - 1 downto 0)  -- Output
    );
end entity;

architecture Behavioral of general_mux is
begin
    process(inputs, sel)
        variable selected_index : integer;
    begin
        -- Convert sel to an integer to determine which input to select
        selected_index := to_integer(unsigned(sel));
        
        -- Assign the selected input to the output
        Y <= inputs(selected_index);
    end process;
end Behavioral;
