library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity n_bit_inverter is
    generic (
        n : integer := 16          
    );
    port (
        A : in std_logic_vector(n-1 downto 0); 
        Y : out std_logic_vector(n-1 downto 0) 
    );
end entity n_bit_inverter;

architecture dataflow of n_bit_inverter is
begin
    gen_inverter: for i in 0 to n-1 generate
        Y(i) <= not A(i);
    end generate;
end architecture dataflow;

