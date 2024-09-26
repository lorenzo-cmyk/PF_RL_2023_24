--- Componente: REG_LAST_VALID_VALUE ---

--- Librerie ---
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--- Definizione della entità ---
ENTITY REG_LAST_VALID_VALUE IS
	PORT
	(
		INPUT  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		RST    : IN  STD_LOGIC;
		FZR    : IN  STD_LOGIC;
		ENB    : IN  STD_LOGIC;
		CLK    : IN  STD_LOGIC;
		OUTPUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END REG_LAST_VALID_VALUE;

--- Architettura (behavioural) del componente ---
ARCHITECTURE REG_LAST_VALID_VALUE_ARCH OF REG_LAST_VALID_VALUE IS
	SIGNAL REG_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	PROCESS (CLK, RST)
	BEGIN
		IF RST = '1' THEN
			REG_DATA <= (OTHERS => '0'); -- RST: Inizializza il componente
		ELSIF CLK'event AND CLK = '1' THEN
			IF FZR = '1' THEN
				REG_DATA <= (OTHERS => '0'); -- FZR: Forza a 0 il contenuto del registro
			ELSIF ENB = '1' THEN
				REG_DATA <= INPUT; -- ENB: Copia nel registro i dati sull'ingresso
			END IF;
		END IF;
	END PROCESS;

	OUTPUT <= REG_DATA;

END REG_LAST_VALID_VALUE_ARCH;