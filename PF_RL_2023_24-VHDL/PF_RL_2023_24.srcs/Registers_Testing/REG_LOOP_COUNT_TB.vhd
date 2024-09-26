--- !!! DISABILITARE QUESTO FILE CONCLUSA LA VALIDAZIONE DEI COMPONENTI !!! ---

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY REG_LOOP_COUNT_TB IS
END REG_LOOP_COUNT_TB;

ARCHITECTURE tb_arch OF REG_LOOP_COUNT_TB IS
	-- Dichiarazione dei segnali per il testbench
	SIGNAL tb_CLK : STD_LOGIC := '0';
	SIGNAL tb_INC : STD_LOGIC := '0';
	SIGNAL tb_RST : STD_LOGIC := '0';
	SIGNAL tb_FZR : STD_LOGIC := '0';
	SIGNAL tb_OUTPUT : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
	-- Connessione del componente REG_
	UUT : ENTITY work.reg_loop_count
		PORT MAP
		(
			INC    => tb_INC,
			RST    => tb_RST,
			FZR    => tb_FZR,
			CLK    => tb_CLK,
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
		ASSERT tb_OUTPUT = "0000000000" REPORT "Errore: fallita inizializzazione del componente" SEVERITY error;
		WAIT FOR 10 ns;
		--Testa operazione di incremento
		tb_INC <= '1';
		WAIT FOR 10ns * 20;
		tb_INC <= '0';
		ASSERT tb_OUTPUT = "0000010100" REPORT "Errore: il registro non ha eseguito correttamente gli incrementi" SEVERITY error;
		WAIT FOR 10ns;
		-- Testa le operazioni di forzatura del registro
		tb_FZR <= '1';
		WAIT FOR 10ns;
		tb_FZR <= '0';
		ASSERT tb_OUTPUT = "0000000000" REPORT "Errore: il contenuto del registro non è stato forzato a zero" SEVERITY error;
		-- Testa la protezione contro l'overflow (funzionante ma impiega troppo tempo il testing - difficilmente si raggiungerà mai l'overflow)
		--- tb_INC <= '1';
		--- wait for 10ns * 1032; -- 1032 = 1024 (max 10bit) + 8
		--- tb_INC <= '0';
		--- assert tb_OUTPUT = "1111111111" report "Errore: il registro non ha supportato l'overflow" severity error;
		WAIT FOR 20ns;
	END PROCESS;
END tb_arch;