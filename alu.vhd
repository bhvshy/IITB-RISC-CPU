library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port(opcode: in std_logic_vector(2 downto 0);
		inputA, inputB: in std_logic_vector(15 downto 0);
		outputC: out std_logic_Vector(15 downto 0);
		zeroflag, carryflag: out std_logic
	);
end entity alu;

architecture manyoperationsatoncewow of alu is
	signal scarryflag: std_logic;
	signal addsuboutput, muloutput, andoutput, oroutput, impoutput, soutputC: std_logic_vector(15 downto 0);
begin
	mux: entity work.mux16bit8to1 port map(
		in000 => addsuboutput, in001 => (others => '0'), in010 => addsuboutput, in011 => muloutput,
		in100 => andoutput, in101 => oroutput, in110 => impoutput, in111 => (others => '0'), sel => opcode, Y => soutputC
	);
	
	addsub: entity work.n_bit_adder_subtractor 
	generic map(n => 16)
	port map(
		A => inputA, B => inputB, mode => opcode(1), C => addsuboutput, C_out => scarryflag
	);
	mul: entity work.four_bit_multiplier port map(
		A => inputA, B => inputB, C => muloutput
	);
	ora: entity work.n_bit_or 
	generic map(n => 16)
	port map(
		A => inputA, B => inputB, C => oroutput
	);
	andi: entity work.n_bit_and 
	generic map(n => 16)
	port map(
		A => inputA, B => inputB, C => andoutput
	);
	imp: entity work.n_bit_imply 
	generic map(n => 16)
	port map(
		A => inputA, B => inputB, C => impoutput
	);
	
	carryflag <= (not opcode(2)) and (not opcode(0)) and scarryflag;
	zeroflag <= not (soutputC(0) or soutputC(1) or soutputC(2) or soutputC(3) or
                         soutputC(4) or soutputC(5) or soutputC(6) or soutputC(7) or
                         soutputC(8) or soutputC(9) or soutputC(10) or soutputC(11) or
                         soutputC(12) or soutputC(13) or soutputC(14) or soutputC(15));
	outputC <= soutputC;
end architecture;