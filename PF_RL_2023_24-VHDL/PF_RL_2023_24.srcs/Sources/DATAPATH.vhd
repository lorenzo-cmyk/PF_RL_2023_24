--- Componente: DATAPATH ---

--- Librerie ---
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--- Definizione della entit� ---
ENTITY project_reti_logiche IS
	PORT
	(
		i_clk      : IN  STD_LOGIC;
		i_rst      : IN  STD_LOGIC;
		i_start    : IN  STD_LOGIC;
		i_add      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_k        : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		o_done     : OUT STD_LOGIC;
		o_mem_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		i_mem_data : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		o_mem_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		o_mem_en   : OUT STD_LOGIC;
		o_mem_we   : OUT STD_LOGIC
	);
END project_reti_logiche;

--- Architettura (structural) del componente ---
ARCHITECTURE DATAPATH_ARCH OF project_reti_logiche IS

	COMPONENT REG_LAST_VALID_VALUE IS
		PORT
		(
			INPUT  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			RST    : IN  STD_LOGIC;
			FZR    : IN  STD_LOGIC;
			ENB    : IN  STD_LOGIC;
			CLK    : IN  STD_LOGIC;
			OUTPUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT REG_LAST_VALID_VALUE;

	COMPONENT REG_CREDIBILITY IS
		PORT
		(
			DEC    : IN  STD_LOGIC;
			RST    : IN  STD_LOGIC;
			FZR    : IN  STD_LOGIC;
			FLL    : IN  STD_LOGIC;
			CLK    : IN  STD_LOGIC;
			OUTPUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT REG_CREDIBILITY;

	COMPONENT MUX_MEMORY IS
		PORT
		(
			INPUT_0 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			INPUT_1 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			SEL     : IN  STD_LOGIC;
			OUTPUT  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT MUX_MEMORY;

	COMPONENT CMP_MACHINE_CONDITIONS IS
		PORT
		(
			INPUT_0  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			INPUT_1  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			INPUT_2  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			OUTPUT_0 : OUT STD_LOGIC;
			OUTPUT_1 : OUT STD_LOGIC
		);
	END COMPONENT CMP_MACHINE_CONDITIONS;

	COMPONENT REG_CURR_ADDRESS IS
		PORT
		(
			INC    : IN  STD_LOGIC;
			RST    : IN  STD_LOGIC;
			ENB    : IN  STD_LOGIC;
			CLK    : IN  STD_LOGIC;
			INPUT  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			OUTPUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT REG_CURR_ADDRESS;

	COMPONENT REG_LOOP_COUNT IS
		PORT
		(
			CLK    : IN  STD_LOGIC;
			RST    : IN  STD_LOGIC;
			INC    : IN  STD_LOGIC;
			FZR    : IN  STD_LOGIC;
			OUTPUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
		);
	END COMPONENT REG_LOOP_COUNT;

	COMPONENT CMP_LOOP_CONDITION IS
		PORT
		(
			INPUT_0 : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
			INPUT_1 : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
			OUTPUT  : OUT STD_LOGIC
		);
	END COMPONENT CMP_LOOP_CONDITION;

	COMPONENT FSM IS
		PORT
		(
			CMP_MACHINE_CONDITIONS_S0 : IN  STD_LOGIC;
			CMP_MACHINE_CONDITIONS_S1 : IN  STD_LOGIC;
			CMP_LOOP_CONDITION_S0     : IN  STD_LOGIC;
			LAST_VALID_VALUE_FZR      : OUT STD_LOGIC;
			LAST_VALID_VALUE_ENB      : OUT STD_LOGIC;
			REG_CREDIBILITY_FZR       : OUT STD_LOGIC;
			REG_CREDIBILITY_FLL       : OUT STD_LOGIC;
			REG_CREDIBILITY_DEC       : OUT STD_LOGIC;
			REG_LOOP_COUNT_FZR        : OUT STD_LOGIC;
			REG_LOOP_COUNT_INC        : OUT STD_LOGIC;
			REG_CURR_ADDRESS_ENB      : OUT STD_LOGIC;
			REG_CURR_ADDRESS_INC      : OUT STD_LOGIC;
			MUX_MEMORY_SEL            : OUT STD_LOGIC;
			STR                       : IN  STD_LOGIC;
			CLK                       : IN  STD_LOGIC;
			RST                       : IN  STD_LOGIC;
			MEM_WE                    : OUT STD_LOGIC;
			MEM_EN                    : OUT STD_LOGIC;
			DONE                      : OUT STD_LOGIC
		);
	END COMPONENT FSM;

	SIGNAL INT_REG_LAST_VALID_VALUE_ENB : STD_LOGIC;
	SIGNAL INT_REG_LAST_VALID_VALUE_FZR : STD_LOGIC;
	SIGNAL INT_REG_LAST_VALID_VALUE_OUTPUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL INT_REG_CREDIBILITY_FZR : STD_LOGIC;
	SIGNAL INT_REG_CREDIBILITY_FLL : STD_LOGIC;
	SIGNAL INT_REG_CREDIBILITY_DEC : STD_LOGIC;
	SIGNAL INT_REG_CREDIBILITY_OUTPUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL INT_MUX_MEMORY_SEL : STD_LOGIC;
	SIGNAL INT_CMP_MACHINE_CONDITIONS_OUTPUT_0 : STD_LOGIC;
	SIGNAL INT_CMP_MACHINE_CONDITIONS_OUTPUT_1 : STD_LOGIC;
	SIGNAL INT_REG_CURR_ADDRESS_ENB : STD_LOGIC;
	SIGNAL INT_REG_CURR_ADDRESS_INC : STD_LOGIC;
	SIGNAL INT_REG_LOOP_COUNT_INC : STD_LOGIC;
	SIGNAL INT_REG_LOOP_COUNT_FZR : STD_LOGIC;
	SIGNAL INT_REG_LOOP_COUNT_OUTPUT : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL INT_CMP_LOOP_CONDITION_OUTPUT : STD_LOGIC;

BEGIN

	REG_LAST_VALID_VALUE_PM : REG_LAST_VALID_VALUE PORT MAP
	(
		CLK    => i_clk,
		RST    => i_rst,
		INPUT  => i_mem_data,
		ENB    => INT_REG_LAST_VALID_VALUE_ENB,
		FZR    => INT_REG_LAST_VALID_VALUE_FZR,
		OUTPUT => INT_REG_LAST_VALID_VALUE_OUTPUT
	);

	REG_CREDIBILITY_PM : REG_CREDIBILITY PORT
	MAP(
	CLK => i_clk,
	RST => i_rst,
	FZR => INT_REG_CREDIBILITY_FZR,
	FLL => INT_REG_CREDIBILITY_FLL,
	DEC => INT_REG_CREDIBILITY_DEC,
	OUTPUT => INT_REG_CREDIBILITY_OUTPUT
	);

	MUX_MEMORY_PM : MUX_MEMORY PORT
	MAP(
	INPUT_0 => INT_REG_LAST_VALID_VALUE_OUTPUT,
	INPUT_1 => INT_REG_CREDIBILITY_OUTPUT,
	SEL => INT_MUX_MEMORY_SEL,
	OUTPUT => o_mem_data
	);

	CMP_MACHINE_CONDITIONS_PM : CMP_MACHINE_CONDITIONS PORT
	MAP(
	INPUT_0 => i_mem_data,
	INPUT_1 => INT_REG_LAST_VALID_VALUE_OUTPUT,
	INPUT_2 => INT_REG_CREDIBILITY_OUTPUT,
	OUTPUT_0 => INT_CMP_MACHINE_CONDITIONS_OUTPUT_0,
	OUTPUT_1 => INT_CMP_MACHINE_CONDITIONS_OUTPUT_1
	);

	REG_CURR_ADDRESS_PM : REG_CURR_ADDRESS PORT
	MAP(
	CLK => i_clk,
	RST => i_rst,
	ENB => INT_REG_CURR_ADDRESS_ENB,
	INC => INT_REG_CURR_ADDRESS_INC,
	INPUT => i_add,
	OUTPUT => o_mem_addr
	);

	REG_LOOP_COUNT_PM : REG_LOOP_COUNT PORT
	MAP(
	CLK => i_clk,
	RST => i_rst,
	FZR => INT_REG_LOOP_COUNT_FZR,
	INC => INT_REG_LOOP_COUNT_INC,
	OUTPUT => INT_REG_LOOP_COUNT_OUTPUT
	);

	CMP_LOOP_CONDITION_PM : CMP_LOOP_CONDITION PORT
	MAP(
	INPUT_0 => INT_REG_LOOP_COUNT_OUTPUT,
	INPUT_1 => i_k,
	OUTPUT => INT_CMP_LOOP_CONDITION_OUTPUT
	);

	FSM_PM : FSM PORT
	MAP(
	CMP_MACHINE_CONDITIONS_S0 => INT_CMP_MACHINE_CONDITIONS_OUTPUT_0,
	CMP_MACHINE_CONDITIONS_S1 => INT_CMP_MACHINE_CONDITIONS_OUTPUT_1,
	CMP_LOOP_CONDITION_S0 => INT_CMP_LOOP_CONDITION_OUTPUT,
	LAST_VALID_VALUE_FZR => INT_REG_LAST_VALID_VALUE_FZR,
	LAST_VALID_VALUE_ENB => INT_REG_LAST_VALID_VALUE_ENB,
	REG_CREDIBILITY_FZR => INT_REG_CREDIBILITY_FZR,
	REG_CREDIBILITY_FLL => INT_REG_CREDIBILITY_FLL,
	REG_CREDIBILITY_DEC => INT_REG_CREDIBILITY_DEC,
	REG_LOOP_COUNT_FZR => INT_REG_LOOP_COUNT_FZR,
	REG_LOOP_COUNT_INC => INT_REG_LOOP_COUNT_INC,
	REG_CURR_ADDRESS_ENB => INT_REG_CURR_ADDRESS_ENB,
	REG_CURR_ADDRESS_INC => INT_REG_CURR_ADDRESS_INC,
	MUX_MEMORY_SEL => INT_MUX_MEMORY_SEL,
	STR => i_start,
	CLK => i_clk,
	RST => i_rst,
	MEM_WE => o_mem_we,
	MEM_EN => o_mem_en,
	DONE => o_done
	);

END DATAPATH_ARCH;