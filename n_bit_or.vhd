library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity n_bit_or is
    generic (
        n : integer := 16          
    );
    port (
        A, B : in std_logic_vector(n-1 downto 0); 
        C : out std_logic_vector(n-1 downto 0) 
    );
end entity n_bit_or;

architecture dataflow of n_bit_or is
begin
    gen_inverter: for i in 0 to n-1 generate
        C(i) <= A(i) or B(i);
    end generate;
end architecture dataflow;

