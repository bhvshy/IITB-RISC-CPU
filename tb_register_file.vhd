library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_register_file is
end entity tb_register_file;

architecture test of tb_register_file is
    -- Component Declaration
    component register_file is
        port (
            RF_A1, RF_A2, RF_A3  : in std_logic_vector(2 downto 0);
            RF_D3 : in std_logic_vector(15 downto 0);
            RF_D1, RF_D2 : out std_logic_vector(15 downto 0);
            clk, write_en, rst : in std_logic;
            R0, R1, R2, R3, R4, R5, R6, R7 : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals
    signal RF_A1, RF_A2, RF_A3 : std_logic_vector(2 downto 0) := (others => '0');
    signal RF_D3 : std_logic_vector(15 downto 0) := (others => '0');
    signal RF_D1, RF_D2 : std_logic_vector(15 downto 0);
    signal clk : std_logic := '0';
    signal write_en : std_logic := '0';
    signal rst : std_logic := '1';
    signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(15 downto 0);

    -- Clock generation process
    constant clk_period : time := 10 ns;
begin
    -- Instantiate the Register File
    uut: register_file
        port map (
            RF_A1 => RF_A1,
            RF_A2 => RF_A2,
            RF_A3 => RF_A3,
            RF_D3 => RF_D3,
            RF_D1 => RF_D1,
            RF_D2 => RF_D2,
            clk => clk,
            write_en => write_en,
            rst => rst,
            R0 => R0,
            R1 => R1,
            R2 => R2,
            R3 => R3,
            R4 => R4,
            R5 => R5,
            R6 => R6,
            R7 => R7
        );

    -- Clock generation
    clk_gen : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process clk_gen;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset the system
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Write values to registers
        for i in 0 to 7 loop
            RF_A3 <= std_logic_vector(to_unsigned(i, 3));
            RF_D3 <= std_logic_vector(to_unsigned(i * 10, 16));
            write_en <= '1';
            wait for clk_period;
        end loop;
        write_en <= '0';

        -- Read values back and check outputs
        for i in 0 to 7 loop
            RF_A1 <= std_logic_vector(to_unsigned(i, 3));  -- Reading to RF_D1
            RF_A2 <= std_logic_vector(to_unsigned(7 - i, 3)); -- Reading to RF_D2
            wait for clk_period;
        end loop;

        -- Hold simulation
        wait;
    end process stim_proc;

end architecture test;
