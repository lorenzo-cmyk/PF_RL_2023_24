--- !!! DISABILITARE QUESTO FILE CONCLUSA LA VALIDAZIONE DEI COMPONENTI !!! ---

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CMP_LOOP_CONDITION_TB IS
END CMP_LOOP_CONDITION_TB;

ARCHITECTURE tb_arch OF CMP_LOOP_CONDITION_TB IS
	-- Dichiarazione dei segnali per il testbench
	SIGNAL tb_INPUT_0 : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL tb_INPUT_1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL tb_OUTPUT : STD_LOGIC;
BEGIN
	-- Connessione del componente LOOP_CONDITION
	UUT : ENTITY work.CMP_LOOP_CONDITION
		PORT MAP
		(
			input_0 => tb_INPUT_0,
			input_1 => tb_INPUT_1,
			output  => tb_OUTPUT
		);
	-- Processo per il controllo delle operazioni 
	PROCESS
	BEGIN
		-- Controllo funzionamento segnali diversi
		tb_INPUT_0 <= "1010101000";
		tb_INPUT_1 <= "0101010100";
		WAIT FOR 1ns;
		ASSERT tb_OUTPUT = '0' REPORT "Errore: segnali diversi ma output 1" SEVERITY error;
		WAIT FOR 10 ns;
		-- Controllo funzionamento segnali uguali
		tb_INPUT_0 <= "1010101000";
		tb_INPUT_1 <= "1010101000";
		WAIT FOR 1ns;
		ASSERT tb_OUTPUT = '1' REPORT "Errore: segnali uguali ma output 0" SEVERITY error;
		WAIT FOR 10 ns;
	END PROCESS;
END tb_arch;