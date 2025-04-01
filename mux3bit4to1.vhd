library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux3bit4to1 is
    port ( 
        in00, in01, in10, in11 : in  std_logic_vector(2 downto 0);
        sel : in  std_logic_vector(1 downto 0); 
        Y : out std_logic_vector(2 downto 0)  
    );
end mux3bit4to1;

architecture Behavioral of mux3bit4to1 is
begin
    process(in00, in01, in10, in11, sel)
    begin
        case sel is
            when "00" => Y <= in00;  -- Select input A
            when "01" => Y <= in01;  -- Select input B
            when "10" => Y <= in10;  -- Select input C
            when "11" => Y <= in11;  -- Select input D
				when others => Y <= (others => '0');
        end case;
    end process;
end Behavioral;
