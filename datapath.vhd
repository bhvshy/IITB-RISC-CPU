library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- the datapath contains all our components port mapped to each other
-- control signals are the only inputs to our datapath, maybe memory programming inputs too
-- we can add another state where everything is held in reset mode, except the memory
-- in this state we can program the memory while everything else is 0
-- only when we activate a "run" signal, does the fsm transition to state 0

entity datapath is
	port
	(	
		clk,
		run_signal,
		IR_en,
		cr_en,
		T1_en, 
		T2_en, 
		PC_en,
		RF_en,
		RF_reset,
		IR_reset,
		cr_reset,
		PC_reset,
		T1_reset,
		T2_reset,
		PCmux_sel,
		memaddmux_sel,
		T1mux_sel,
		mem_en,
		programming_mem_en,
		programming_rf_en	: in std_logic;
		
		alu_Amux_sel,
		alu_Bmux_sel,
		T2mux_sel,
		RF_D3mux_sel,
		RF_A3mux_sel,
		alu_opcodemux_sel	: in std_logic_vector(1 downto 0);
		
		programming_mem_add,
		programming_mem_data,
		programming_rf_d3	: in std_logic_vector(15 downto 0);
		
		programming_rf_a3: in std_logic_vector(2 downto 0);
		
		op_code: out std_logic_vector(3 downto 0);
		zeroflag_out: out std_logic;
		carryflag_out: out std_logic;
		condition_reg : out std_logic_vector(1 downto 0);
		R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0);
		PC_data : out std_logic_vector(15 downto 0)
	);
end entity datapath;

architecture structure of datapath is
	signal PC_data_in, 
			PC_data_out, 
			IR_data_in, 
			mem_add_in, 
			mem_data_in, 
			mem_data_out, 
			RF_D1, 
			RF_D2,
			RF_D3,
			RF_D3_fsm,
			mem_data_in_fsm,
			mem_add_in_fsm,
			T1_data_in,
			T1_data_out,
			T2_data_in,
			T2_data_out,
			alu_A,
			alu_B,
			alu_C,
			SE_6_16_1_out,
			SE_9_16_1_out,
			PadLHI_out,
			PadLLI_out	: std_logic_vector(15 downto 0);
			
	signal IR_15_12 : std_logic_vector(3 downto 0);
	signal IR_11_9,
			IR_8_6,
			IR_5_3,
			RF_A1,
			RF_A2,
			RF_A3,
			RF_A3_fsm,
			alu_opcode : std_logic_vector(2 downto 0);
			
	signal IR_5_0 : std_logic_vector(5 downto 0);
	signal IR_8_0 : std_logic_vector(8 downto 0);
	signal carryflag, zeroflag, mem_en_signal, rf_en_signal: std_logic;

			
begin

	Cond_Code : entity work.ConditionCodeRegister
					port map(
					clk => clk,
					rst => cr_reset,
					cr_en => cr_en,
					carry_in => carryflag,
					zero_in =>zeroflag,
					condition => condition_reg
					);

PC_data <= PC_data_out;
	PC: entity work.n_bit_register
		generic map(n => 16)
		port map(clk => clk, write_en => PC_en, reset => PC_reset,
					data_in => PC_data_in, 
					data_out => PC_data_out
		);
		
	IR: entity work.instruction_register
		port map(clk => clk, write_en => IR_en, reset => IR_reset, 
					data_in => IR_data_in, 
					bits_15_12 => IR_15_12, 
					bits_11_9 => IR_11_9, 
					bits_8_6 => IR_8_6, 
					bits_5_3 => IR_5_3, 
					bits_5_0 => IR_5_0, 
					bits_8_0 => IR_8_0
		);
		
	memory: entity work.memory
		port map(clock => clk, mem_write_en => mem_en_signal,
					mem_add => mem_add_in, 
					mem_data_in => mem_data_in, 
					mem_data_out => mem_data_out
		);
		
	RF: entity work.register_file
		port map(write_en => RF_en_signal, clk => clk, rst => RF_reset,
					RF_A1 => RF_A1, 
					RF_A2 => RF_A2, 
					RF_A3 => RF_A3, 
					RF_D1 => RF_D1, 
					RF_D2 => RF_D2, 
					RF_D3 => RF_D3,
					
					R0 => R0,
					R1 => R1,
					R2 => R2,
					R3 => R3,
					R4 => R4,
					R5 => R5,
					R6 => R6,
					R7 => R7
		);
	
	ALU: entity work.alu
		port map(opcode => alu_opcode, 
					inputA => alu_A, 
					inputB => alu_B, 
					outputC => alu_C, 
					zeroflag => zeroflag, 
					carryflag => carryflag
		);
		
	T1: entity work.n_bit_register
		generic map(n => 16)
		port map(clk => clk, write_en => T1_en, reset => T1_reset,
					data_in => T1_data_in, 
					data_out => T1_data_out
		);
	
	T2: entity work.n_bit_register
		generic map(n => 16)
		port map(clk => clk, write_en => T2_en, reset => T2_reset,
					data_in => T2_data_in, 
					data_out => T2_data_out
		);
		
	PCmux: entity work.mux16bit2to1
		port map(in0 => T2_data_out,
					in1 => alu_C,
					sel => PCmux_sel,
					Y => PC_data_in
		);
	
	Memaddmux: entity work.mux16bit2to1
		port map(in0 => PC_data_out,
					in1 => T2_data_out,
					sel => memaddmux_sel,
					Y => mem_add_in_fsm
		);
		
	SE6_16_1: entity work.SE6_16
		port map(B => IR_5_0,
					Y => SE_6_16_1_out
		);
		
	SE9_16_1: entity work.SE9_16
		port map(A => IR_8_0,
					Y => SE_9_16_1_out
		);
		
	alu_Amux: entity work.mux16bit4to1
		port map(in00 => PC_data_out,
					in01 => T1_data_out,
					in10 => T2_data_out,
					in11 => (others => '0'),
					sel => alu_Amux_sel,
					Y => alu_A
		);
	
	alu_Bmux: entity work.mux16bit4to1
		port map(in00(0) => '1',
					in00(15 downto 1) => (others => '0'),
					in01 => T2_data_out,
					in10 => SE_6_16_1_out, -- IR_5_0 sign extended
					in11 => SE_9_16_1_out, -- IR_8_0 sign extended
					sel => alu_Bmux_sel,
					Y => alu_B
		);
		
	T1mux: entity work.mux16bit2to1
		port map(in0 => RF_D1,
					in1 => alu_C,
					sel => T1mux_sel,
					Y => T1_data_in
		);
	
	T2mux: entity work.mux16bit4to1
		port map(in00 => RF_D2,
					in01 => alu_C,
					in10 => mem_data_out,
					in11 => (others => '0'),
					sel => T2mux_sel,
					Y => T2_data_in
		);
	
	PadLHI: entity work.LHI
		port map(A => IR_8_0,
					Y => PadLHI_out
		);
	
	PadLLI: entity work.pad_lli
		port map(A => IR_8_0,
					Y => PadLLI_out
		);
		
	RF_D3mux: entity work.mux16bit4to1
		port map(in00 => T1_data_out,
					in01 => T2_data_out,
					in10 => PadLHI_out,
					in11 => PadLLI_out,
					sel => RF_D3mux_sel,
					Y => RF_D3_fsm
		);
		
	RF_A3mux: entity work.mux3bit4to1
		port map(in00 => IR_11_9,
					in01 => IR_8_6,
					in10 => IR_5_3,
					in11 => (others => '0'),
					sel => RF_A3mux_sel,
					Y => RF_A3_fsm
		);
		
	alu_opcodemux: entity work.mux3bit4to1
		port map(in00 => IR_15_12(2 downto 0),
					in01 => "000", -- ADD
					in10 => "010", -- SUB
					in11 => (others => '0'),
					sel => alu_opcodemux_sel,
					Y => alu_opcode
		);
		
	mem_add_in <= mem_add_in_fsm when run_signal='1' else programming_mem_add;
	mem_data_in <= mem_data_in_fsm when run_signal='1' else programming_mem_data;
	rf_d3 <= rf_d3_fsm when run_signal='1' else programming_rf_d3;
	rf_a3 <= rf_a3_fsm when run_signal='1' else programming_rf_a3;
	
	mem_en_signal <= mem_en when run_signal='1' else programming_mem_en;
	rf_en_signal <= rf_en when run_signal='1' else programming_rf_en;
	
		
	-- constant signal mappings
	IR_data_in <= mem_data_out;
	mem_data_in_fsm <= T1_data_out;
	RF_A1 <= IR_11_9;
	RF_A2 <= IR_8_6;	
	op_code <= IR_15_12;
	zeroflag_out <= zeroflag;
	carryflag_out <= carryflag;
	

	
end architecture;
		
		
		
		
		
		
		
		
		
		
		
		