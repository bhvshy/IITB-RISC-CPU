library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL; -- Required for std_logic_vector text I/O
library std;
use STD.TEXTIO.ALL;
library work;
use work.fsm;

entity fsm_tb is
    -- Testbench has no ports
end fsm_tb;

architecture Behavioral of fsm_tb is
    -- Signal declarations for FSM connections
    signal clk_tb: std_logic := '0';
    signal R0_tb, R1_tb, R2_tb, R3_tb, R4_tb, R5_tb, R6_tb, R7_tb: std_logic_vector(15 downto 0);
    signal programming_mem_add, programming_mem_data, programming_rf_d3: std_logic_vector(15 downto 0) := (others => '0');
    signal programming_rf_a3: std_logic_vector(2 downto 0) := (others => '0');

    signal datapath_reset: std_logic := '1';
    signal programming_mem_en, programming_rf_en: std_logic := '0';
    signal run_signal: std_logic := '0';

    -- Clock period constant
    constant clock_period: time := 20 ns;

    -- Counter for controlling the sequence
    signal counter: integer := 0;

    -- File variables for reading the program
    file program_file: text open read_mode is "C:\Users\kusha\OneDrive\Desktop\final_cpu\CPU\CPU\And.txt";
		
		
	signal PC : std_logic_vector(15 downto 0);
	signal present_state : std_logic_vector(5 downto 0);
	signal condition_register : std_logic_vector(1 downto 0);
begin
    -- Instantiate the FSM
    uut: entity work.fsm
        port map(
            clk => clk_tb,
            R0 => R0_tb,
            R1 => R1_tb,
            R2 => R2_tb,
            R3 => R3_tb,
            R4 => R4_tb,
            R5 => R5_tb,
            R6 => R6_tb,
            R7 => R7_tb,

            datapath_reset_in => datapath_reset,
            run_signal_tb => run_signal,
            programming_mem_en => programming_mem_en,
            programming_rf_en => programming_rf_en,
            programming_mem_add => programming_mem_add,
            programming_mem_data => programming_mem_data,
            programming_rf_d3 => programming_rf_d3,
            programming_rf_a3 => programming_rf_a3,
				PC => PC,
				present_state => present_state,
				condition_reg =>condition_register
        );
	
    -- Clock generation process
    clock_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for clock_period / 2;
            clk_tb <= '1';
            wait for clock_period / 2;

            counter <= counter + 1;
        end loop;
    end process;

    input_sequence: process
    variable temp_line: line; -- Declare line variable
    variable bitstring: std_logic_vector(15 downto 0); -- Declare bitstring variable
	 begin
    for i in 0 to 7 loop
        if i = 0 then
            datapath_reset <= '1'; -- Reset high for the first iteration
        else
            datapath_reset <= '0'; -- Reset low for subsequent iterations
        end if;

        -- Read each line and load it into memory
        readline(program_file, temp_line); -- Read one line from the file
        read(temp_line, bitstring);        -- Extract the value into bitstring

        -- Write to memory
        programming_rf_en <= '0'; -- Disable register write
        programming_mem_en <= '1'; -- Enable memory write
        programming_mem_add <= std_logic_vector(to_unsigned(i, 16)); -- Memory address
        programming_mem_data <= bitstring; -- Data for memory

        wait for clock_period; -- Wait for one clock cycle
    end loop;

    -- After all lines are processed, disable programming signals
    programming_rf_en <= '0';
    programming_mem_en <= '0';
    run_signal <= '1'; -- Enable run signal after initialization
	 wait;
	 end process;


    -- Output monitoring process
    monitor_process: process
    begin
        wait for 20 ns; -- Initial delay to stabilize simulation
        while true loop
            wait for clock_period; -- Wait for one clock cycle
            report "R0 = " & integer'image(to_integer(unsigned(R0_tb)));
            report "R1 = " & integer'image(to_integer(unsigned(R1_tb)));
            report "R2 = " & integer'image(to_integer(unsigned(R2_tb)));
            report "R3 = " & integer'image(to_integer(unsigned(R3_tb)));
            report "R4 = " & integer'image(to_integer(unsigned(R4_tb)));
            report "R5 = " & integer'image(to_integer(unsigned(R5_tb)));
            report "R6 = " & integer'image(to_integer(unsigned(R6_tb)));
            report "R7 = " & integer'image(to_integer(unsigned(R7_tb)));
--            report "Zero flag = " & std_logic'image(zeroflag_tb);
--            report "Carry flag = " & std_logic'image(carryflag_tb);
        end loop;
    end process;

end Behavioral;
