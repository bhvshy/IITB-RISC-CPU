library ieee;
use ieee.std_logic_1164.all;

entity demux1x8 is
    port (
        inp  : in  std_logic;
        sel  : in  std_logic_vector(2 downto 0);
        outp : out std_logic_vector(7 downto 0)
    );
end entity;

architecture combinational of demux1x8 is
begin
    -- Concurrent conditional assignment for each output line
    outp <=  "00000001" when sel = "000" and inp = '1' else
             "00000010" when sel = "001" and inp = '1' else
             "00000100" when sel = "010" and inp = '1' else
             "00001000" when sel = "011" and inp = '1' else
             "00010000" when sel = "100" and inp = '1' else
             "00100000" when sel = "101" and inp = '1' else
             "01000000" when sel = "110" and inp = '1' else
             "10000000" when sel = "111" and inp = '1' else
             "00000000";  -- Default output when inp is '0'
end combinational;