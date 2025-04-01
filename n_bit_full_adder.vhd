library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity n_bit_full_adder is
    generic (
        n : integer := 16       
    );
    port (
        a, b    : in std_logic_vector(n-1 downto 0); 
        c_in    : in std_logic;                      
        sum     : out std_logic_vector(n-1 downto 0); 
        c_out   : out std_logic                 
    );
end entity n_bit_full_adder;

architecture structural of n_bit_full_adder is
    signal carry : std_logic_vector(n downto 0);
begin
    carry(0) <= c_in;

    gen_adders: for i in 0 to n-1 generate
        full_adder_inst: entity work.full_adder
            port map (
                a     => a(i),   
                b     => b(i),       
                c_in  => carry(i), 
                s     => sum(i),     
                c_out => carry(i+1)  
            );
    end generate gen_adders;
    c_out <= carry(n); 
end architecture structural;
