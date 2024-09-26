--- !!! DISABILITARE QUESTO FILE CONCLUSA LA VALIDAZIONE DEI COMPONENTI !!! ---

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY REG_CURR_ADDRESS_TB IS
END REG_CURR_ADDRESS_TB;

ARCHITECTURE tb_arch OF REG_CURR_ADDRESS_TB IS
	-- Dichiarazione dei segnali per il testbench
	SIGNAL tb_CLK : STD_LOGIC := '0';
	SIGNAL tb_INC : STD_LOGIC := '0';
	SIGNAL tb_RST : STD_LOGIC := '0';
	SIGNAL tb_ENB : STD_LOGIC := '0';
	SIGNAL tb_INPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL tb_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	-- Connessione del componente REG_CURR_ADDRESS
	UUT : ENTITY work.REG_CURR_ADDRESS
		PORT MAP
		(
			INC    => tb_INC,
			RST    => tb_RST,
			ENB    => tb_ENB,
			CLK    => tb_CLK,
			INPUT  => tb_INPUT,
			OUTPUT => tb_OUTPUT
		);
	-- Processo per generare il clock
	PROCESS
	BEGIN
		WAIT FOR 5 ns;
		tb_CLK <= NOT tb_CLK;
	END PROCESS;
	-- Processo per il controllo delle operazioni sul registro
	PROCESS
	BEGIN
		WAIT FOR 10 ns; -- Attendi per assicurarti che il registro si sia stabilizzato (1 ciclo di clock - concesso anche da testbench)
		-- Testa il reset asincrono
		tb_RST <= '1';
		WAIT FOR 10 ns;
		tb_RST <= '0';
		ASSERT tb_OUTPUT = "0000000000000000" REPORT "Errore: fallita inizializzazione del componente" SEVERITY error;
		WAIT FOR 10 ns;
		-- Testa le operazioni di caricamento manuale del registro
		tb_INPUT <= "0000001000001010";
		tb_ENB <= '1';
		WAIT FOR 10ns;
		tb_ENB <= '0';
		ASSERT tb_OUTPUT = "0000001000001010" REPORT "Errore: il registro non ha copiato correttamente l'input" SEVERITY error;
		WAIT FOR 10ns;
		-- Testa le operazioni di incremento
		tb_RST <= '1';
		WAIT FOR 10ns;
		tb_RST <= '0';
		tb_INC <= '1';
		WAIT FOR 10ns * 32;
		tb_INC <= '0';
		ASSERT tb_OUTPUT = "0000000000100000" REPORT "Errore: il registro non ha eseguito correttamente gli incrementi" SEVERITY error;
		WAIT FOR 10ns;
		-- Testa la protezione contro l'overflow
		tb_INPUT <= "1111111111111100";
		tb_ENB <= '1';
		WAIT FOR 10ns;
		tb_ENB <= '0';
		WAIT FOR 10ns;
		tb_INC <= '1';
		WAIT FOR 10ns * 32;
		tb_INC <= '0';
		ASSERT tb_OUTPUT = "1111111111111111" REPORT "Errore: il registro non ha supportato l'overflow" SEVERITY error;
		WAIT FOR 20ns;
	END PROCESS;
END tb_arch;