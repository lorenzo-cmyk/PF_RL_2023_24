--- !!! DISABILITARE QUESTO FILE CONCLUSA LA VALIDAZIONE DEI COMPONENTI !!! ---

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX_MEMORY_TB IS
END MUX_MEMORY_TB;

ARCHITECTURE tb_arch OF MUX_MEMORY_TB IS
	-- Dichiarazione dei segnali per il testbench
	SIGNAL tb_INPUT_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tb_INPUT_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tb_SEL : STD_LOGIC;
	SIGNAL tb_OUTPUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	-- Connessione del componente MUX_MEMORY
	UUT : ENTITY work.MUX_MEMORY
		PORT MAP
		(
			INPUT_0 => tb_INPUT_0,
			INPUT_1 => tb_INPUT_1,
			SEL     => tb_SEL,
			OUTPUT  => tb_OUTPUT
		);
	-- Processo per il controllo delle operazioni sul mux
	PROCESS
	BEGIN
		-- Controllo funzionamento canale 0
		tb_INPUT_0 <= "10101010";
		tb_INPUT_1 <= "01010101";
		tb_SEL <= '0';
		WAIT FOR 1 ns;
		ASSERT tb_OUTPUT = "10101010" REPORT "Errore: il mux non ha eseguito lo switching sul canale 0" SEVERITY error;
		WAIT FOR 10 ns;
		-- Controllo funzionamento canale 1
		tb_INPUT_0 <= "10101010";
		tb_INPUT_1 <= "01010101";
		tb_SEL <= '1';
		WAIT FOR 1 ns;
		ASSERT tb_OUTPUT = "01010101" REPORT "Errore: il mux non ha eseguito lo switching sul canale 1" SEVERITY error;
		WAIT FOR 10 ns;
	END PROCESS;
END tb_arch;