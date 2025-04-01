library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SE6_16 is
	port(B: in std_logic_vector(5 downto 0);
			Y: out std_logic_vector(15 downto 0));
end entity;

architecture struct of SE6_16 is
	signal temp : std_logic_vector(9 downto 0);
begin	
	temp <= (others=>B(5));
	 
	Y <= temp & B when (B(5) = '0') else (temp & B(5) & (not B(4 downto 0))) + "0000000000000001";
	

end architecture;