library ieee;
use ieee.std_logic_1164.all;

entity pad_lli is
    port (
        a  : in  std_logic_vector(8 downto 0);   -- 9-bit input
        y : out std_logic_vector(15 downto 0)   -- 16-bit output
    );
end pad_lli;

architecture Behavioral of pad_lli is
begin
    y <= "00000000" & a(7 downto 0); -- Concatenate 8 zeros with the last 8 bits of input
end Behavioral;
