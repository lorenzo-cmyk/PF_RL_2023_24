--- !!! DISABILITARE QUESTO FILE CONCLUSA LA VALIDAZIONE DEI COMPONENTI !!! ---

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY REG_CREDIBILITY_TB IS
END REG_CREDIBILITY_TB;

ARCHITECTURE tb_arch OF REG_CREDIBILITY_TB IS
	-- Dichiarazione dei segnali per il testbench
	SIGNAL tb_CLK : STD_LOGIC := '0';
	SIGNAL tb_DEC : STD_LOGIC := '0';
	SIGNAL tb_RST : STD_LOGIC := '0';
	SIGNAL tb_FZR : STD_LOGIC := '0';
	SIGNAL tb_FLL : STD_LOGIC := '0';
	SIGNAL tb_OUTPUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	-- Connessione del componente REG_CREDIBILITY
	UUT : ENTITY work.REG_CREDIBILITY
		PORT MAP
		(
			DEC    => tb_DEC,
			RST    => tb_RST,
			FZR    => tb_FZR,
			FLL    => tb_FLL,
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
		ASSERT tb_OUTPUT = "00000000" REPORT "Errore: fallita inizializzazione del componente" SEVERITY error;
		WAIT FOR 10 ns;
		-- Testa le operazioni di caricamento manuale del registro
		tb_FLL <= '1';
		WAIT FOR 10ns;
		tb_FLL <= '0';
		ASSERT tb_OUTPUT = "00011111" REPORT "Errore: il contenuto del registro non è stato forzato a 31" SEVERITY error;
		WAIT FOR 10ns;
		tb_FZR <= '1';
		WAIT FOR 10ns;
		tb_FZR <= '0';
		ASSERT tb_OUTPUT = "00000000" REPORT "Errore: il contenuto del registro non è stato forzato a zero" SEVERITY error;
		WAIT FOR 10ns;
		-- Testa la protezione contro l'underflow
		tb_FLL <= '1';
		WAIT FOR 10ns;
		tb_FLL <= '0';
		tb_DEC <= '1';
		WAIT FOR 10ns * 32;
		tb_DEC <= '0';
		ASSERT tb_OUTPUT = "00000000" REPORT "Errore: il registro non ha supportato l'underflow" SEVERITY error;
		WAIT FOR 10ns;
		WAIT FOR 20ns;
	END PROCESS;
END tb_arch;