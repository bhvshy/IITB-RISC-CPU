library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LHI is
	port(A: in std_logic_vector(8 downto 0);
			Y: out std_logic_vector(15 downto 0));
end entity;

architecture struct of LHI is
	signal temp : std_logic_vector(7 downto 0);
begin	
	temp <= (others=>'0');
	Y <= A(7 downto 0) & temp;
end architecture;