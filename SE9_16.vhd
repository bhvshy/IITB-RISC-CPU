library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SE9_16 is
	port(A: in std_logic_vector(8 downto 0);
			Y: out std_logic_vector(15 downto 0));
end entity;

architecture struct of SE9_16 is
	signal temp : std_logic_vector(6 downto 0);
begin	
	temp <= (others=>A(8));
	Y <= temp & A when (A(8) = '0') else (temp & A(8) & (not A(7 downto 0))) + "0000000000000001";

end architecture;