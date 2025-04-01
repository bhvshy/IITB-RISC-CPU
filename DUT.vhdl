library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(35 downto 0);
       	output_vector: out std_logic_vector(17 downto 0));
end entity;

architecture DutWrap of DUT is
begin

   add_instance: entity work.alu
			port map (
					inputA => input_vector(31 downto 16),
					inputB => input_vector(15 downto 0),
					opcode => input_vector(34 downto 32),
					outputC => output_vector(17 downto 2),
					carryflag => output_vector(1),
					zeroflag => output_vector(0)
			);
end DutWrap;