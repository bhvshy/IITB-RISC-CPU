library ieee;
use ieee.std_logic_1164.all;

entity register_file is

port (
		RF_A1, RF_A2, RF_A3  : in std_logic_vector(2 downto 0);
		RF_D3 : in std_logic_vector(15 downto 0);
		RF_D1, RF_D2 : out std_logic_vector(15 downto 0);
		clk, write_en, rst : in std_logic;
		R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0)
		);
end entity register_file;



architecture design of register_file is
component reg is
port (
		D : in std_logic_vector(15 downto 0);
		clk, rst, write_en : in std_logic;
		Q : out std_logic_vector(15 downto 0)
		);	
end component reg;

component demux1x8 is
port (
		inp : in std_logic;
		sel : in std_logic_vector(2 downto 0);
		outp : out std_logic_vector(7 downto 0)
		);
end component demux1x8;

component mux8x1 is
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
end component;


type reg_array is array (7 downto 0) of std_logic_vector(15 downto 0);

signal enable : std_logic_vector(7 downto 0);
signal r_out : reg_array:= (others => "0000000000000001");
begin

inst_demultiplexer : demux1x8 port map(write_en, RF_A3, enable);
													 
inst_multiplexer_1 : mux8x1 port map(r_out(0), r_out(1), r_out(2), r_out(3), r_out(4), r_out(5), r_out(6), r_out(7),
													RF_A1, RF_D1);													 

inst_multiplexer_2 : mux8x1 port map(r_out(0), r_out(1), r_out(2), r_out(3), r_out(4), r_out(5), r_out(6), r_out(7),
													RF_A2, RF_D2);
											
gen : for i in 0 to 7 generate 
inst_reg_i : reg port map(RF_D3, clk, rst, enable(i), r_out(i));
end generate gen;

R0 <= r_out(0);
R1 <= r_out(1);
R2 <= r_out(2);
R3 <= r_out(3);
R4 <= r_out(4);
R5 <= r_out(5);
R6 <= r_out(6);
R7 <= r_out(7);

end design;