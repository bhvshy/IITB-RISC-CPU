library ieee;
use ieee.std_logic_1164.all;


entity reg is

port (
		D : in std_logic_vector(15 downto 0);
		clk, rst, write_en : in std_logic;
		Q : out std_logic_vector(15 downto 0)
		);	
end entity;


architecture design of reg is

begin
process (clk,rst, write_en)

begin
if(rst = '1') then
	Q <= (others => '0');
elsif (write_en = '1' and rising_edge(clk)) then
	Q <= D;
end if;

end process;

end design;