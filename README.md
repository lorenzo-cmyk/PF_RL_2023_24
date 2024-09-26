# Prova Finale di Reti Logiche - A.A. 2023/2024

- Scadenza: 2024-04-01
- Voto: 30/30

Realizzato assieme a [Pietro Benecchi.](https://github.com/PietroBenecchi-polimi)

# Descrizione

Il seguente progetto vede l'implementazione di un modulo hardware in linguaggio VHDL che si interfaccia con una memoria esterna per la gestione e correzione di sequenze di dati a 8 bit. Il modulo è progettato per garantire l'integrità dei dati rilevando e correggendo eventuali valori mancanti, rappresentati da zeri. In particolare, sostituisce ogni valore nullo con l'ultimo dato valido precedentemente letto, assicurando così una continuità nella sequenza elaborata. Contestualmente, ad ogni parola viene assegnato un valore di "credibilità", che parte dal massimo (255) e viene decrementato ogni volta che un dato viene sostituito, fornendo una misura della qualità e dell'affidabilità dei dati processati.

