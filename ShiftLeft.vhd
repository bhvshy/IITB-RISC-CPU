library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft is
	port(A: in std_logic_vector(15 downto 0);
			n: in integer;
			Y: out std_logic_vector(15 downto 0));
end entity;

architecture struct of ShiftLeft is
begin	
	
	Y <= std_logic_vector(shift_left(unsigned(A),n));

end architecture;