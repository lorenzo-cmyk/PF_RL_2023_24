--- Componente: REG_LOOP_COUNT ---

--- Librerie ---
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; --- Richiesta per incrementare uno std_logic_vector attraverso conversione a tipo numerico. https://stackoverflow.com/questions/854684/why-cant-i-increment-this-std-logic-vector

--- Definizione della entità ---
ENTITY REG_LOOP_COUNT IS
	PORT
	(
		CLK    : IN  STD_LOGIC;
		RST    : IN  STD_LOGIC;
		INC    : IN  STD_LOGIC;
		FZR    : IN  STD_LOGIC;
		OUTPUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END REG_LOOP_COUNT;

--- Architettura (behavioural) del componente ---
ARCHITECTURE REG_LOOP_COUNT_ARCH OF REG_LOOP_COUNT IS
	SIGNAL REG_DATA : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
	PROCESS (CLK, RST)
	BEGIN
		IF RST = '1' THEN
			REG_DATA <= (OTHERS => '0'); -- RST: Inizializza il componente
		ELSIF CLK'event AND CLK = '1' THEN
			IF INC = '1' THEN
				IF REG_DATA /= "1111111111" THEN
					REG_DATA <= STD_LOGIC_VECTOR(unsigned(REG_DATA) + 1); -- INC : Aumenta di una unità il contatore
				END IF;
			ELSIF FZR = '1' THEN
				REG_DATA <= (OTHERS => '0'); -- FZR: Forza a 0 il contenuto del registro
			END IF;
		END IF;
	END PROCESS;

	output <= REG_DATA; -- Output del registro

END REG_LOOP_COUNT_ARCH;