library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux16bit8to1 is
    port ( 
        in000, in001, in010, in011, in100, in101, in110, in111 : in  STD_LOGIC_VECTOR(15 downto 0);
        sel : in  STD_LOGIC_VECTOR(2 downto 0); 
        Y : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end mux16bit8to1;

architecture Behavioral of mux16bit8to1 is
begin
    process(in000, in001, in010, in011, in100, in101, in110, in111, sel)
    begin
        case sel is
            when "000" => Y <= in000;  -- Select input A
            when "001" => Y <= in001;  -- Select input B
            when "010" => Y <= in010;  -- Select input C
            when "011" => Y <= in011;  -- Select input D
            when "100" => Y <= in100;  -- Select input E
            when "101" => Y <= in101;  -- Select input F
            when "110" => Y <= in110;  -- Select input G
            when "111" => Y <= in111;  -- Select input H
				when others => Y <= (others => '0');
        end case;
    end process;
end Behavioral;
