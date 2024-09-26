--- !!! DISABILITARE QUESTO FILE CONCLUSA LA VALIDAZIONE DEI COMPONENTI !!! ---

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY REG_LAST_VALID_VALUE_TB IS
END REG_LAST_VALID_VALUE_TB;

ARCHITECTURE tb_arch OF REG_LAST_VALID_VALUE_TB IS
	-- Dichiarazione dei segnali per il testbench
	SIGNAL tb_CLK : STD_LOGIC := '0';
	SIGNAL tb_RST : STD_LOGIC := '0';
	SIGNAL tb_FZR : STD_LOGIC := '0';
	SIGNAL tb_ENB : STD_LOGIC := '0';
	SIGNAL tb_INPUT : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL tb_OUTPUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	-- Connessione del componente REG_LAST_VALID_VALUE
	DUT : ENTITY work.REG_LAST_VALID_VALUE
		PORT MAP
		(
			INPUT  => tb_INPUT,
			RST    => tb_RST,
			FZR    => tb_FZR,
			ENB    => tb_ENB,
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
		tb_RST <= '1'; -- Attiva il segnale di reset
		WAIT FOR 10 ns;
		tb_RST <= '0'; -- Disattiva il segnale di reset
		ASSERT tb_OUTPUT = "00000000" REPORT "Errore: fallita inizializzazione del componente" SEVERITY error;
		WAIT FOR 10 ns;
		-- Testa il caricamento del registro
		tb_INPUT <= x"DD"; -- Imposta un valore di input
		tb_ENB <= '1'; -- Attiva il segnale di enable
		WAIT FOR 10 ns;
		tb_ENB <= '0'; -- Disattiva il segnale di enable
		ASSERT tb_OUTPUT = tb_INPUT REPORT "Errore: il registro non ha copiato correttamente l'input" SEVERITY error;
		WAIT FOR 10 ns;
		-- Testa la forzatura del contenuto del registro a zero
		tb_FZR <= '1'; -- Attiva il segnale di forzatura
		WAIT FOR 10 ns;
		tb_FZR <= '0'; -- Disattiva il segnale di forzatura
		ASSERT tb_OUTPUT = "00000000" REPORT "Errore: il contenuto del registro non è stato forzato a zero" SEVERITY error;
		WAIT FOR 10 ns;
		-- Testa i cambiamenti del clock (rindondante, modulo usato solo internamente)
		tb_INPUT <= x"CC"; -- Imposta un nuovo valore di input
		tb_ENB <= '1'; -- Attiva il segnale di enable
		WAIT FOR 10 ns;
		tb_ENB <= '0'; -- Disattiva il segnale di enable
		ASSERT tb_OUTPUT = x"CC" REPORT "Errore: il registro non ha mantenuto il valore corretto durante il fronte di salita del clock" SEVERITY error;
		WAIT FOR 5 ns;
		tb_ENB <= '0'; -- Disattiva il segnale di enable
		ASSERT tb_OUTPUT = x"CC" REPORT "Errore: il registro non ha mantenuto il valore corretto durante il fronte di discesa del clock" SEVERITY error;
		WAIT FOR 5 ns;
		-- Testa input massimo e minimo
		tb_INPUT <= x"FF"; -- Massimo valore di input
		tb_ENB <= '1'; -- Attiva il segnale di enable
		WAIT FOR 10 ns;
		tb_ENB <= '0'; -- Disattiva il segnale di enable
		ASSERT tb_OUTPUT = "11111111" REPORT "Errore: il registro non ha copiato correttamente il massimo valore di input" SEVERITY error;
		WAIT FOR 10 ns;
		tb_INPUT <= x"00"; -- Minimo valore di input
		tb_ENB <= '1'; -- Attiva il segnale di enable
		WAIT FOR 10 ns;
		tb_ENB <= '0'; -- Disattiva il segnale di enable
		ASSERT tb_OUTPUT = "00000000" REPORT "Errore: il registro non ha copiato correttamente il minimo valore di input" SEVERITY error;
		WAIT FOR 10 ns;
		-- Testa cambiamenti simultanei sui segnali di controllo (rindondante, modulo usato solo internamente)
		tb_FZR <= '1'; -- Attiva il segnale di forzatura
		tb_ENB <= '1'; -- Attiva il segnale di enable
		WAIT FOR 10 ns;
		ASSERT tb_OUTPUT = "00000000" REPORT "Errore: il registro non è stato forzato a zero quando sia FZR che ENB sono attivi" SEVERITY error;
		WAIT FOR 10ns;
		tb_FZR <= '0'; -- Disattiva il segnale di forzatura
		tb_ENB <= '0'; -- Disattiva il segnale di enable
		WAIT FOR 20ns;
	END PROCESS;
END tb_arch;