--- !!! DISABILITARE QUESTO FILE CONCLUSA LA VALIDAZIONE DEI COMPONENTI !!! ---

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CMP_MACHINE_CONDITIONS_TB IS
END ENTITY CMP_MACHINE_CONDITIONS_TB;

ARCHITECTURE tb_arch OF CMP_MACHINE_CONDITIONS_TB IS
	-- Dichiarazione dei segnali per il testbench
	SIGNAL tb_INPUT_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tb_INPUT_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tb_INPUT_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tb_OUTPUT_0 : STD_LOGIC;
	SIGNAL tb_OUTPUT_1 : STD_LOGIC;
BEGIN
	-- Connessione del componente CMP_MACHINE_CONDITIONS
	dut : ENTITY work.CMP_MACHINE_CONDITIONS
		PORT MAP
		(
			INPUT_0  => tb_INPUT_0,
			INPUT_1  => tb_INPUT_1,
			INPUT_2  => tb_INPUT_2,
			OUTPUT_0 => tb_OUTPUT_0,
			OUTPUT_1 => tb_OUTPUT_1
		);
	-- Processo per generare segnali di input
	PROCESS
	BEGIN
		tb_INPUT_0 <= "10101010";
		tb_INPUT_1 <= (OTHERS => '0');
		tb_INPUT_2 <= (OTHERS => '0');
		WAIT FOR 1 ns;
		ASSERT tb_OUTPUT_0 = '0' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_0" SEVERITY error;
		ASSERT tb_OUTPUT_1 = '0' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_1" SEVERITY error;
		WAIT FOR 10ns;
		tb_INPUT_0 <= "10101010";
		tb_INPUT_1 <= "10101010";
		tb_INPUT_2 <= "10101010";
		WAIT FOR 1 ns;
		ASSERT tb_OUTPUT_0 = '0' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_0" SEVERITY error;
		ASSERT tb_OUTPUT_1 = '1' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_1" SEVERITY error;
		WAIT FOR 10ns;
		tb_INPUT_0 <= (OTHERS => '0');
		tb_INPUT_1 <= (OTHERS => '0');
		tb_INPUT_2 <= (OTHERS => '0');
		WAIT FOR 1 ns;
		ASSERT tb_OUTPUT_0 = '1' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_0" SEVERITY error;
		ASSERT tb_OUTPUT_1 = '0' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_1" SEVERITY error;
		WAIT FOR 10ns;
		tb_INPUT_0 <= (OTHERS => '0');
		tb_INPUT_1 <= "10101010";
		tb_INPUT_2 <= "10101010";
		WAIT FOR 1 ns;
		ASSERT tb_OUTPUT_0 = '1' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_0" SEVERITY error;
		ASSERT tb_OUTPUT_1 = '1' REPORT "Errore: il comparatore non ha aggiornato correttamente il canale OUTPUT_1" SEVERITY error;
		WAIT FOR 10ns;
	END PROCESS;
END ARCHITECTURE tb_arch;