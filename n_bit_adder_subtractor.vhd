library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity n_bit_adder_subtractor is
    generic (
        n : integer := 16  
    );
    port (
        A     : in std_logic_vector(n-1 downto 0); 
        B     : in std_logic_vector(n-1 downto 0); 
        mode  : in std_logic;                       
        C   : out std_logic_vector(n-1 downto 0);  
        c_out : out std_logic                       
    );
end entity n_bit_adder_subtractor;

architecture structural of n_bit_adder_subtractor is
    signal B_inverted : std_logic_vector(n-1 downto 0);
    signal cin, scout : std_logic;
    signal B_to_add   : std_logic_vector(n-1 downto 0); 
begin
    cin <= mode;
    B_to_add <= B_inverted when mode = '1' else B; 
    inverter_inst: entity work.n_bit_inverter
        generic map (n => n)
        port map (
            A => B,
            Y => B_inverted
        );
    adder_inst: entity work.n_bit_full_adder
        generic map (n => n)
        port map (
            a     => A,
            b     => B_to_add,
            c_in  => cin,
            sum   => C,
            c_out => scout
        );
	c_out <= scout xor cin;
end architecture structural;
