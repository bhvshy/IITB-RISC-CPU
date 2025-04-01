library ieee;
use ieee.std_logic_1164.all;

entity instruction_register is
    port (
        clk       : in  std_logic;                    
        reset     : in  std_logic;                   
        write_en  : in  std_logic;                    
        data_in   : in  std_logic_vector(15 downto 0); 
        bits_15_12 : out std_logic_vector(3 downto 0); 
        bits_11_9  : out std_logic_vector(2 downto 0); 
        bits_8_6   : out std_logic_vector(2 downto 0); 
        bits_5_3   : out std_logic_vector(2 downto 0);
        bits_5_0   : out std_logic_vector(5 downto 0); 
        bits_8_0   : out std_logic_vector(8 downto 0)  
    );
end entity;

architecture Behavioral of instruction_register is
    signal reg : std_logic_vector(15 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= (others => '0'); 
        elsif rising_edge(clk) then
            if write_en = '1' then
                reg <= data_in; 
            end if;
        end if;
	 end process;
	
    bits_15_12 <= reg(15 downto 12);
    bits_11_9  <= reg(11 downto 9);  
    bits_8_6   <= reg(8 downto 6);  
    bits_5_3   <= reg(5 downto 3);   
    bits_5_0   <= reg(5 downto 0);  
    bits_8_0   <= reg(8 downto 0); 
	 

end architecture;
