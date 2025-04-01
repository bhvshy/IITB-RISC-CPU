library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity memory is
port (
		mem_add : in std_logic_vector(15 downto 0);
		mem_data_in : in std_logic_vector(15 downto 0);
		mem_data_out : out std_logic_vector(15 downto 0);
		mem_write_en : in std_logic;
		clock : in std_logic);
end entity memory;

architecture design of memory is
	type mem_array is array (0 to 511) of std_logic_vector(15 downto 0);
	signal mem : 	mem_array := (others => "0000000000000000");

begin
	process(clock)
	begin
			if(rising_edge(clock)) then
				if(mem_write_en = '1') then	
						mem(to_integer(unsigned(mem_add))) <= mem_data_in;
				end if;
			end if;
	end process;
	mem_data_out <= mem(to_integer(unsigned(mem_add)));
	
end architecture design;