library ieee;
use ieee.std_logic_1164.all;


entity mux8x1 is
port (
		inp0 : in std_logic_vector(15 downto 0);
		inp1 : in std_logic_vector(15 downto 0);
		inp2 : in std_logic_vector(15 downto 0);
		inp3 : in std_logic_vector(15 downto 0);
		inp4 : in std_logic_vector(15 downto 0);
		inp5 : in std_logic_vector(15 downto 0);
		inp6 : in std_logic_vector(15 downto 0);
		inp7 : in std_logic_vector(15 downto 0);
		sel :  in std_logic_vector(2 downto 0);
		outp : out std_logic_vector(15 downto 0));
end entity;


architecture design of mux8x1 is

begin

process(sel, inp0, inp1, inp2, inp3, inp4, inp5, inp6, inp7)
begin
case sel is
		when "000" => outp <= inp0;
		when "001" => outp <= inp1;
		when "010" => outp <= inp2;
		when "011" => outp <= inp3;
		when "100" => outp <= inp4;
		when "101" => outp <= inp5;
		when "110" => outp <= inp6;
		when "111" => outp <= inp7;
		when others => outp <= "ZZZZZZZZZZZZZZZZ";
	end case;
end process;
end design;
		