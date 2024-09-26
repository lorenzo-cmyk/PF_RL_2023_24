--- Componente: REG_CREDIBILITY ---

--- Librerie ---
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; --- Richiesta per decrementare uno std_logic_vector attraverso conversione a tipo numerico. https://stackoverflow.com/questions/854684/why-cant-i-increment-this-std-logic-vector

--- Definizione della entità ---
ENTITY REG_CREDIBILITY IS
	PORT
	(
		DEC    : IN  STD_LOGIC;
		RST    : IN  STD_LOGIC;
		FZR    : IN  STD_LOGIC;
		FLL    : IN  STD_LOGIC;
		CLK    : IN  STD_LOGIC;
		OUTPUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END REG_CREDIBILITY;

--- Architettura (behavioural) del componente ---
ARCHITECTURE REG_CREDIBILITY_ARCH OF REG_CREDIBILITY IS
	SIGNAL REG_DATA : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	PROCESS (CLK, RST)
	BEGIN
		IF RST = '1' THEN
			REG_DATA <= (OTHERS => '0'); -- RST: Inizializza il componente
		ELSIF CLK'event AND CLK = '1' THEN
			IF FZR = '1' THEN
				REG_DATA <= (OTHERS => '0'); -- FZR: Forza a 0 il contenuto del registro
			ELSIF FLL = '1' THEN
				REG_DATA <= "00011111"; -- FLL: Forza a 31 il contenuto del registro
			ELSIF DEC = '1' THEN
				IF REG_DATA /= "00000000" THEN
					REG_DATA <= STD_LOGIC_VECTOR(unsigned(REG_DATA) - 1); -- DEC: Decrementa di una unità il contatore
				END IF;
			END IF;
		END IF;
	END PROCESS;

	OUTPUT <= REG_DATA; -- Output del registro

END REG_CREDIBILITY_ARCH;