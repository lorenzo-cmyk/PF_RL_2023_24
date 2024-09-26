--- Componente: REG_CURR_ADDRESS ---

--- Librerie ---
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; --- Richiesta per incrementare uno std_logic_vector attraverso conversione a tipo numerico. https://stackoverflow.com/questions/854684/why-cant-i-increment-this-std-logic-vector

--- Definizione della entità  ---
ENTITY REG_CURR_ADDRESS IS
	PORT
	(
		INC    : IN  STD_LOGIC;
		RST    : IN  STD_LOGIC;
		ENB    : IN  STD_LOGIC;
		CLK    : IN  STD_LOGIC;
		INPUT  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END REG_CURR_ADDRESS;

--- Architettura (behavioural) del componente ---
ARCHITECTURE REG_CURR_ADDRESS_ARCH OF REG_CURR_ADDRESS IS
	SIGNAL REG_DATA : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	PROCESS (CLK, RST)
	BEGIN
		IF RST = '1' THEN
			REG_DATA <= (OTHERS => '0'); -- RST: Inizializza il componente
		ELSIF CLK'event AND CLK = '1' THEN
			IF ENB = '1' THEN
				REG_DATA <= INPUT; -- ENB: Copia nel registro i dati sull'ingresso
			ELSIF INC = '1' THEN
				IF REG_DATA /= "1111111111111111" THEN
					REG_DATA <= STD_LOGIC_VECTOR(unsigned(REG_DATA) + 1); -- INC: Incrementa di una unità il contatore
				END IF;
			END IF;
		END IF;
	END PROCESS;

	OUTPUT <= REG_DATA; -- Output del registro

END REG_CURR_ADDRESS_ARCH;