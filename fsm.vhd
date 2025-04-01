library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
	port(clk, datapath_reset_in, run_signal_tb, programming_mem_en, programming_rf_en: in std_logic;
		R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0);
		programming_mem_add, programming_mem_data, programming_rf_d3: in std_logic_vector(15 downto 0);
		programming_rf_a3: in std_logic_vector (2 downto 0);
		zeroflag_out, carryflag_out: out std_logic;
		PC : out std_logic_vector(15 downto 0);
		present_state : out std_logic_vector(5 downto 0);
		condition_reg : out std_logic_vector(1 downto 0)
	);
end entity fsm;


architecture cocacola of fsm is	
	type state is (reset_state, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17);
	signal state_present, state_next: state:= reset_state;
	signal IR_en            : std_logic;
	signal cr_en            : std_logic;
	signal T1_en            : std_logic;
	signal T2_en            : std_logic;
	signal PC_en            : std_logic;
	signal RF_en            : std_logic;
	signal mem_write        : std_logic;
	signal datapath_reset   : std_logic := '0';
	signal pc_mux           : std_logic;
	signal mem_address_mux  : std_logic;
	signal t1_mux           : std_logic;
	signal zeroflag         : std_logic;
	signal carryflag         : std_logic;
	signal beq_counter      : std_logic := '0';
	signal run_signal 		: std_logic := '0';
	
	-- Signal declarations for 2-bit std_logic_vector signals
	signal alu_mux_a        : std_logic_vector(1 downto 0);
	signal alu_mux_b        : std_logic_vector(1 downto 0);
	signal t2_mux           : std_logic_vector(1 downto 0);
	signal rf_d3_mux        : std_logic_vector(1 downto 0);
	signal rf_a3_mux        : std_logic_vector(1 downto 0);
	signal alu_sel          : std_logic_vector(1 downto 0);
	
	signal op_code 			: std_logic_vector(3 downto 0);
	
begin
	present_state <= std_logic_vector(to_signed(state'pos(state_present)-1,6));
	datapath_reset <= datapath_reset_in;
	run_signal <= run_signal_tb;
	
	cpu_datapath: entity work.datapath
		port map(clk => clk,
					run_signal => run_signal,
					programming_mem_en => programming_mem_en,
					programming_rf_en => programming_rf_en,
					programming_mem_add => programming_mem_add,
					programming_mem_data => programming_mem_data,
					programming_rf_a3 => programming_rf_a3,
					programming_rf_d3 => programming_rf_d3,
					IR_en => IR_en,
					cr_en => cr_en,
					T1_en => T1_en,
					T2_en => T2_en,
					PC_en => PC_en,
					RF_en => RF_en,
					mem_en => mem_write,
					alu_Amux_sel => alu_mux_a,
					alu_Bmux_sel => alu_mux_b,
					T1mux_sel => t1_mux,
					T2mux_sel => t2_mux,
					RF_reset => datapath_reset,
					IR_reset => datapath_reset,
					cr_reset => datapath_reset,
					PC_reset => datapath_reset,
					T1_reset => datapath_reset,
					T2_reset => datapath_reset,
					memaddmux_sel => mem_address_mux,
					alu_opcodemux_sel => alu_sel,
					PCmux_sel => pc_mux,
					RF_D3mux_sel => rf_d3_mux,
					RF_A3mux_sel => rf_a3_mux,
					op_code => op_code,
					zeroflag_out => zeroflag,
					carryflag_out => carryflag,
					
					R0 => R0,
					R1 => R1,
					R2 => R2,
					R3 => R3,
					R4 => R4,
					R5 => R5,
					R6 => R6,
					R7 => R7,
					PC_data => PC,
					condition_reg=>condition_reg
		);
		
	clock_process: process(clk)
	begin
		if rising_edge(clk) then
			state_present <= state_next;
		else
			null;
		end if;
	end process;
	
	state_transition_process: process(state_present,op_code,run_signal,clk)
	begin
	case state_present is
		 when reset_state=>
			if(run_signal='0') then 
				state_next<=reset_state;
			else state_next<=s0;
			end if;
			
		 when s0=> -- common	 
			beq_counter <= '0';
			state_next<=s1;
		 
		 when s1=> -- common		 
			 if op_code="0001" then 					-- ADI
				state_next<=s4;
			 elsif op_code(3)='0' and op_code/="0111" then					-- ALU
				state_next<=s2;
			 elsif op_code(3 downto 1)="101" then	-- LW/SW
				state_next<=s8;
			 elsif op_code="1100" then 				-- BEQ
				state_next<=s12;
			 elsif op_code(3 downto 2)="11" then	-- JAL/JLR/J
				state_next<=s13;
			 elsif op_code="1000" then 				-- LHI
				state_next<=s6;
			 elsif op_code="1001" then					-- LLI
				state_next<=s7;
			 else
				state_next<=s0;
			 end if;
		 
		 when s2=> -- ALU
			state_next<=s3;
		 
		 when s3=> -- ALU
			state_next<=s0;
		 
		 when s4=> -- ADI
			state_next<=s5;
		 
		 when s5=> -- ADI
			state_next<=s0;
		 
		 when s6=> -- LHI	
			state_next<=s0;
		 
		 when s7=> -- LLI
			state_next<=s0;
		 
		 when s8=> -- LW/SW
			 if op_code="1010" then 
				state_next<=s9; -- LW
			 elsif op_code="1011" then 
				state_next<=s11; -- SW
			 else
				state_next<=s0;
			 end if;
		 
		 when s9=> -- LW
			state_next<=s10;
		 
		 when s10=> -- LW
			state_next<=s0;
		 
		 when s11=> -- SW (Data to be stored is in T1, is a constant assignment to memory_data_in)
			state_next<=s0;
		 
		 when s12=> -- BEQ
			if beq_counter='0' then -- counter used to wait for zeroflag, so that branching is delayed by 1 clock cycle
				beq_counter <= '1';
				state_next <= s12;
			else
				if zeroflag='1' then 
					state_next<=s13;
					beq_counter <= '0';
				else 
					state_next<=s0;
					beq_counter <= '0';
				end if;
			end if;
		 
		 when s13=> -- BEQ
			 if op_code="1100" then 
				state_next<=s14; -- BEQ
			 elsif (op_code="1101") or (op_code="1110") then
				state_next<=s15; -- JAL
			 elsif op_code="1111" then
				state_next<=s17; -- JLR
			 else
				state_next<=s0;
			 end if;
		 
		 when s14=> -- BEQ
			state_next<=s0;
		 
		 when s15=> -- JAL/J
			 if op_code="1101" then
				state_next<=s16; -- JAL
			 elsif op_code="1110" then 
				state_next<=s0;  -- J
			 else
				state_next<=s0;
			 end if;
		 
		 when s16=> -- JAL
			state_next<=s0;
		 
		 when s17=> -- JLR
			state_next<=s0;
			
		 when others => 
			state_next <= s0;
	end case;
	
	end process;
					
	output_process:process(state_present,op_code)
	begin
	case state_present is
		 when reset_state=>
			 ir_en<='0'; 
			 cr_en<='0';
			 t1_en<='0';
			 t2_en<='0';
			 pc_en<='0'; 
			 rf_en<='0';
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00";
			 rf_a3_mux<="00";
			 mem_address_mux<='0'; 
		
		 when s0=> -- common
		
			 ir_en<='1'; -- write to IR
			 t1_en<='0';
			 cr_en<='1';
			 t2_en<='0';
			 pc_en<='1'; -- write to PC
			 rf_en<='0';
			 mem_write<='0';
			 alu_sel<="01"; --ADD
			 alu_mux_a<="00"; -- input from PC
			 alu_mux_b<="00"; -- constant(0x0001)
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='1'; -- output from ALU_C
			 rf_d3_mux<="00";
			 rf_a3_mux<="00";
			 mem_address_mux<='0'; -- Defaulted to read from PC
		 
		 when s1=> -- common
			 ir_en<='0';
			 t1_en<='1'; -- write to T1
			 t2_en<='1'; -- write to T2
			 pc_en<='0';
			 cr_en<='0';
			 rf_en<='0';
			 mem_write<='0';
			 alu_sel<="11"; --none
			 alu_mux_a<="00";
			 alu_mux_b<="00";
			 t2_mux<="00"; -- input from RF_D2
			 t1_mux<='0'; -- input from RF_D1
			 pc_mux<='0';
			 rf_d3_mux<="00";
			 rf_a3_mux<="00";
			 mem_address_mux<='0';
		 
		 when s2=> -- ALU
		 
			 ir_en<='0';
			 t1_en<='1'; -- Write ALU-C to T1
			 t2_en<='0';
			 cr_en<='1';
			 pc_en<='0';
			 rf_en<='0';
			 mem_write<='0';
			 alu_sel<="00"; -- opcode from IR
			 alu_mux_a<="01"; -- input from T1
			 alu_mux_b<="01"; -- input from T2
			 t2_mux<="00";
			 t1_mux<='1'; -- output from ALU_C
			 pc_mux<='0';
			 rf_d3_mux<="00";
			 rf_a3_mux<="00";
			 mem_address_mux<='0';
		 
		 
		 when s3=> -- ALU
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='0'; 
			 pc_en<='0';
			 cr_en<='0';
			 rf_en<='1'; -- write to RF
			 mem_write<='0';
			 alu_sel<="11"; -- none
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00"; -- input from T1 
			 rf_a3_mux<="10"; -- IR_5_3
			 mem_address_mux<='0';
		 
		 
		 when s4=> -- ADI
		 
			 ir_en<='0';
			 t1_en<='1'; -- write ALU_C to T1
			 t2_en<='0';
			 cr_en<='1'; 
			 pc_en<='0';
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="01"; -- ADD
			 alu_mux_a<="01";  -- input from T1
			 alu_mux_b<="10";  -- input from IR_5_0 sign extended
			 t2_mux<="00";
			 t1_mux<='1'; -- output from ALU_C
			 pc_mux<='0';
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='0';
		 
		 
		 when s5=> -- ADI
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='0'; 
			 pc_en<='0';
			 cr_en<='0';
			 rf_en<='1'; -- Write to RF
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00"; -- Input from T1
			 rf_a3_mux<="01"; -- IR_8_6
			 mem_address_mux<='0';
		 
		 when s6=> -- LHI
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='0';
			 cr_en<='0'; 
			 pc_en<='0';
			 rf_en<='1'; -- Write to RF 
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="10"; -- IR_7_0 padded (LHI)
			 rf_a3_mux<="00"; -- IR_11_9
			 mem_address_mux<='0';
		 
		 when s7=> -- LLI
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='0';
			 cr_en<='0'; 
			 pc_en<='0';
			 rf_en<='1'; -- Write to RF 
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="11"; -- IR_7_0 padded (LLI)
			 rf_a3_mux<="00"; -- IR_11_9
			 mem_address_mux<='0';
		 
		 when s8=> -- LW/SW
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='1'; -- Write to T2
			 pc_en<='0';
			 cr_en<='1';
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="01"; --ADD
			 alu_mux_a<="10"; -- Input from T2
			 alu_mux_b<="10"; -- IR_5_0 (sign extended)
			 t2_mux<="01"; -- output from ALU_C
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='0';
		 
		 when s9=> -- LW
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='1'; -- Write to T2
			 pc_en<='0';
			 cr_en<='0';
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="10"; -- Store memory data
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='1'; -- Read address from T2
			 
		 when s10=> -- LW
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='0';
			 cr_en<='0'; 
			 pc_en<='0';
			 rf_en<='1'; -- Store in RF
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="01"; -- Input from T2
			 rf_a3_mux<="00"; -- IR_11_9
			 mem_address_mux<='0';
		 
		 when s11=> -- SW (Data to be stored is in T1, is a constant assignment to memory_data_in)
		 
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='0';
			 cr_en<='0'; 
			 pc_en<='0';
			 rf_en<='0'; 
			 mem_write<='1'; -- Write to memory
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='1'; -- Read address from T2
		 
		 when s12=> -- BEQ
				
			 ir_en<='0';
			 t1_en<='0'; 
			 t2_en<='0';
			 cr_en<='1'; 
			 pc_en<='0';
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="10"; -- SUB
			 alu_mux_a<="01"; -- input from T1
			 alu_mux_b<="01"; -- Input from T2
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='0'; 
		 
		 when s13=> -- BEQ
		 
			 ir_en<='0';
			 cr_en<='1';
			 t1_en<='1'; -- write updated PC value to T1
			 t2_en<='0'; 
			 pc_en<='0';
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="10"; -- SUB
			 alu_mux_a<="00"; -- input from PC
			 alu_mux_b<="00"; -- constant(0x0001)
			 t2_mux<="00";
			 t1_mux<='1'; -- output from ALU_C
			 pc_mux<='0';
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='0';
		 
		 when s14=> -- BEQ
		 
			 ir_en<='0';
			 cr_en<='1';
			 t1_en<='0'; 
			 t2_en<='0'; 
			 pc_en<='1'; -- Write updated PC
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="01"; -- ADD
			 alu_mux_a<="01"; -- Input from T1
			 alu_mux_b<="10"; -- IR_5_0 (sign extended)
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='1'; -- output from ALU_C
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='0';
		 
		 when s15=> -- JAL/J
		 
			 ir_en<='0';
			 cr_en<='1';
			 t1_en<='0'; 
			 t2_en<='0'; 
			 pc_en<='1'; -- Write updated value to PC
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="01"; -- ADD
			 alu_mux_a<="01"; -- Input from T1
			 alu_mux_b<="11"; -- IR_8_0 (sign extended)
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='1'; -- output from ALU_C
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='0';
		 
		 when s16=> -- JAL
		 
			 ir_en<='0';
			 cr_en<='0';
			 t1_en<='0'; 
			 t2_en<='0'; 
			 pc_en<='0';
			 rf_en<='1'; -- Write to RF
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0';
			 rf_d3_mux<="00"; -- Input from T1
			 rf_a3_mux<="00"; -- IR_11_9
			 mem_address_mux<='0';
		 
		 when s17=> -- JLR
		 
			 ir_en<='0';
			 cr_en<='0';
			 t1_en<='0'; 
			 t2_en<='0'; 
			 pc_en<='1'; -- Write to PC
			 rf_en<='1'; -- Write to RF
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0'; -- Input from T2
			 rf_d3_mux<="00"; -- Input from T1
			 rf_a3_mux<="00"; -- IR_11_9
			 mem_address_mux<='0';
			 
		when others => 
			ir_en<='0';
			cr_en<='0';
			 t1_en<='0'; 
			 t2_en<='0'; 
			 pc_en<='0'; 
			 rf_en<='0'; 
			 mem_write<='0';
			 alu_sel<="11"; 
			 alu_mux_a<="00"; 
			 alu_mux_b<="00"; 
			 t2_mux<="00";
			 t1_mux<='0';
			 pc_mux<='0'; 
			 rf_d3_mux<="00"; 
			 rf_a3_mux<="00"; 
			 mem_address_mux<='0';
	end case;
	end process;
	
	zeroflag_out <= zeroflag;
	carryflag_out <= carryflag;
	
	
end cocacola;

