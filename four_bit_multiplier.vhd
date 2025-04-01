library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity four_bit_multiplier is
	port(A, B: in std_logic_vector(15 downto 0);
		C: out std_logic_vector(15 downto 0)
	);
		
end entity four_bit_multiplier;

architecture multiply of four_bit_multiplier is
    signal sadderout1, sadderout2, sadderout3: std_logic_vector(3 downto 0);
    signal scout1, scout2, scout3: std_logic;
    signal adder1_a, adder1_b, adder2_a, adder2_b, adder3_a, adder3_b: std_logic_vector(3 downto 0);

begin
    adder1_a(3) <= A(3) and B(1);
    adder1_a(2) <= A(2) and B(1);
    adder1_a(1) <= A(1) and B(1);
    adder1_a(0) <= A(0) and B(1);

    adder1_b(3) <= '0';
    adder1_b(2) <= A(3) and B(0);
    adder1_b(1) <= A(2) and B(0);
    adder1_b(0) <= A(1) and B(0);

    adder1: entity work.n_bit_full_adder
        generic map (n => 4)
        port map (
            a => adder1_a,
            b => adder1_b,
            c_in => '0',
            sum => sadderout1,
            c_out => scout1
        );

    adder2_a(3) <= A(3) and B(2);
    adder2_a(2) <= A(2) and B(2);
    adder2_a(1) <= A(1) and B(2);
    adder2_a(0) <= A(0) and B(2);

    adder2_b(3) <= scout1;
    adder2_b(2) <= sadderout1(3);
    adder2_b(1) <= sadderout1(2);
    adder2_b(0) <= sadderout1(1);

    adder2: entity work.n_bit_full_adder
        generic map (n => 4)
        port map (
            a => adder2_a,
            b => adder2_b,
            c_in => '0',
            sum => sadderout2,
            c_out => scout2
        );

    adder3_a(3) <= A(3) and B(3);
    adder3_a(2) <= A(2) and B(3);
    adder3_a(1) <= A(1) and B(3);
    adder3_a(0) <= A(0) and B(3);

    adder3_b(3) <= scout2;
    adder3_b(2) <= sadderout2(3);
    adder3_b(1) <= sadderout2(2);
    adder3_b(0) <= sadderout2(1);

    adder3: entity work.n_bit_full_adder
        generic map (n => 4)
        port map (
            a => adder3_a,
            b => adder3_b,
            c_in => '0',
            sum => sadderout3,
            c_out => scout3
        );

    C(0) <= A(0) and B(0);
    C(1) <= sadderout1(0);
    C(2) <= sadderout2(0);
    C(6 downto 3) <= sadderout3;
    C(7) <= scout3;
	 C(15 downto 8) <= (others => '0');

end architecture;
